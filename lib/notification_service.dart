import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'kural_model.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz.initializeTimeZones();
    try {
      final location = tz.getLocation('Asia/Kolkata');
      tz.setLocalLocation(location);
    } catch (e) {
      debugPrint("Timezone initialization error: $e");
    }

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        debugPrint("Notification tapped: ${details.payload}");
      },
    );
  }

  Future<void> requestPermissions() async {
    final androidImplementation = _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (androidImplementation != null) {
      await androidImplementation.requestNotificationsPermission();
      await androidImplementation.requestExactAlarmsPermission();
    }
  }

  Future<Kural?> _getKuralForDate(DateTime date) async {
    try {
      final String response = await rootBundle.loadString(
        'assets/data/kurals.json',
      );
      final Map<String, dynamic> jsonMap = json.decode(response);
      final List<dynamic> kuralsData = jsonMap['kurals'] as List<dynamic>;
      final allKurals = kuralsData.map((item) => Kural.fromJson(item)).toList();
      final filteredKurals = allKurals
          .where((k) => k.section != "காமத்துப்பால்")
          .toList();

      final int seed = date.year * 10000 + date.month * 100 + date.day;
      final random = Random(seed);
      return filteredKurals[random.nextInt(filteredKurals.length)];
    } catch (e) {
      return null;
    }
  }

  /// PRODUCTION METHOD: Schedules the daily Kural for 5:00 AM IST with full content
  Future<void> scheduleDaily5AMKural() async {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);

    // Set target to 5:00 AM today
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      17,
      5,
      0,
    );

    // If it's already past 5 AM today, schedule for 5 AM tomorrow
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    final kural = await _getKuralForDate(scheduledDate);
    if (kural == null) return;

    // Constructing the body with Kural, Tamil meaning, and English meaning
    final String fullBody =
        "${kural.kural[0]}\n${kural.kural[1]}\n\n"
        "விளக்கம்: ${kural.meaning['ta_mu_va']}\n\n"
        "English: ${kural.meaning['en']}";

    final androidDetails = AndroidNotificationDetails(
      'daily_kural_channel',
      'Daily Kural',
      channelDescription: 'Daily Tirukkural notification at 5:00 AM',
      importance: Importance.max,
      priority: Priority.high,
      category: AndroidNotificationCategory.reminder,
      // Uses BigTextStyle to ensure all meaning text is visible in the notification shade
      styleInformation: BigTextStyleInformation(
        fullBody,
        contentTitle: "தினசரி குறள் ${kural.number}",
        summaryText: "அதிகாரம்: ${kural.chapter}",
      ),
    );

    await _notificationsPlugin.zonedSchedule(
      0,
      "தினசரி குறள் ${kural.number}",
      fullBody,
      scheduledDate,
      NotificationDetails(
        android: androidDetails,
      ), // Removed 'const' here to fix the error
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }
}
