import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'kural_model.dart';
import 'quiz_page.dart';
import 'daily_kural_page.dart';
import 'title_or_number_page.dart';
import 'hint_search_page.dart';
import 'help_page.dart';
import 'about_page.dart';
import 'notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final notificationService = NotificationService();
  await notificationService.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tirukkural App',
      theme: ThemeData(primarySwatch: Colors.teal, useMaterial3: true),
      home: const KuralHomePage(),
    );
  }
}

class KuralHomePage extends StatefulWidget {
  const KuralHomePage({super.key});

  @override
  State<KuralHomePage> createState() => _KuralHomePageState();
}

class _KuralHomePageState extends State<KuralHomePage> {
  late Future<List<Kural>> futureKurals;
  final NotificationService _notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    futureKurals = loadKurals();

    // Initialize permissions and schedule production daily kural
    _initNotifications();
  }

  Future<void> _initNotifications() async {
    // 1. Request necessary permissions for notifications and alarms
    await _notificationService.requestPermissions();

    // 2. Activate the production schedule for 5:00 AM IST
    await _notificationService.scheduleDaily5AMKural();
  }

  Future<List<Kural>> loadKurals() async {
    try {
      final String jsonString = await rootBundle.loadString(
        'assets/data/kurals.json',
      );
      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      final List<dynamic> kuralsData = jsonMap['kurals'];
      return kuralsData.map((json) => Kural.fromJson(json)).toList();
    } catch (e) {
      debugPrint("Data load error: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF6558DA), Color(0xFF6558DA)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Center(
            child: Text(
              "Kural for All/குறள் அனைவருக்கும்",
              style: TextStyle(
                fontSize: 15,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      body: FutureBuilder<List<Kural>>(
        future: futureKurals,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError ||
              !snapshot.hasData ||
              snapshot.data!.isEmpty) {
            return const Center(child: Text('Error loading data.'));
          } else {
            final kurals = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Image.asset(
                      'assets/images/tiruvalluvar.png',
                      height: 180,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 10),
                    _buildNavButton(
                      context,
                      'Daily Kural / தினக்குறள்',
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DailyKuralPage(kurals: kurals),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildNavButton(
                      context,
                      "Search by Section/Chapter/Number",
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              TitleOrNumberPage(kurals: kurals),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildNavButton(
                      context,
                      "Search by Hint / குறிப்பு மூலம் தேடல்",
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HintSearchPage(kurals: kurals),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildNavButton(
                      context,
                      'Quiz / வினாடி வினா',
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuizPage(kurals: kurals),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton.icon(
                          icon: const Icon(Icons.info),
                          label: const Text(
                            'About/அறிமுகம்',
                            style: TextStyle(fontSize: 12),
                          ),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AboutPage(),
                            ),
                          ),
                        ),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.help_outline),
                          label: const Text(
                            'Help/உதவி',
                            style: TextStyle(fontSize: 12),
                          ),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HelpPage(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildNavButton(
    BuildContext context,
    String title,
    VoidCallback onTap,
  ) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.85,
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF6558DA),
            foregroundColor: Colors.white,
            elevation: 6,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(title, textAlign: TextAlign.center),
        ),
      ),
    );
  }
}
