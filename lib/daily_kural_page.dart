import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_tts/flutter_tts.dart';
import 'kural_data_maps.dart';
import 'kural_model.dart';

class DailyKuralPage extends StatefulWidget {
  final List<Kural> kurals;

  const DailyKuralPage({super.key, required this.kurals});

  @override
  State<DailyKuralPage> createState() => _DailyKuralPageState();
}

class _DailyKuralPageState extends State<DailyKuralPage> {
  Kural? todayKural;
  final FlutterTts _flutterTts = FlutterTts();
  List<String> _languages = [];

  @override
  void initState() {
    super.initState();
    _checkTtsLanguages();
    loadKuralsAndPickToday();
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }

  Future<void> _checkTtsLanguages() async {
    _languages = List<String>.from(await _flutterTts.getLanguages);
  }

  Future<void> loadKuralsAndPickToday() async {
    final String response = await rootBundle.loadString(
      'assets/data/kurals.json',
    );
    final Map<String, dynamic> jsonMap = json.decode(response);

    // Extract list of kurals safely
    final List<dynamic> kuralsData = jsonMap['kurals'] as List<dynamic>;
    final List<Kural> allKurals = kuralsData
        .map((item) => Kural.fromJson(item))
        .toList();

    final filteredKurals = allKurals
        .where((kural) => kural.section != "காமத்துப்பால்")
        .toList();

    final today = DateTime.now();
    final int seed = int.parse(
      "${today.year}${today.month.toString().padLeft(2, '0')}${today.day.toString().padLeft(2, '0')}",
    );
    final random = Random(seed);
    final kural = filteredKurals[random.nextInt(filteredKurals.length)];

    setState(() {
      todayKural = kural;
    });
  }

  Future<void> _speakEnglish() async {
    if (todayKural == null) return;
    final String englishText = todayKural!.meaning["en"] ?? '';
    await _flutterTts.setLanguage("en-IN");
    await _flutterTts.speak(englishText);
  }

  Future<void> _speakTamil() async {
    if (todayKural == null) return;

    if (_languages.contains("ta-IN")) {
      final kural = todayKural!;
      final String tamilText =
          "${kural.kural[0]}\n${kural.kural[1]}\nதமிழ் விளக்கம்:\n${kural.meaning["ta_salamon"] ?? ""}";
      await _flutterTts.setLanguage("ta-IN");
      await _flutterTts.speak(tamilText);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Tamil audio is not available. Please check your TTS settings. இந்த போனில் தமிழ் பேச்சு ஆதரிக்கப்படவில்லை.",
          ),
        ),
      );
    }
  }

  String getEnglishChapterName(String tamilChapter) {
    final clean = tamilChapter.trim();

    for (final entry in chapterEnglishMap.entries) {
      if (entry.key.trim() == clean) {
        return entry.value;
      }
    }
    return ''; // Fallback
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Daily One Kural/தினம் ஒரு குறள்",
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
      ),
      body: todayKural == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Kural #: ${todayKural!.number}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "அதிகாரம்/Chapter: ${todayKural!.chapter} / ${getEnglishChapterName(todayKural!.chapter)}",
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "பால்/Section: ${todayKural!.section} / ${sectionTranslations[todayKural!.section] ?? ''}",
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    "${todayKural!.kural[0]}\n${todayKural!.kural[1]}",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "விளக்கம் :\n${todayKural!.meaning['ta_mu_va'] ?? ''}",
                    style: const TextStyle(fontSize: 13),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "விளக்கம் :\n${todayKural!.meaning['ta_salamon'] ?? ''}",
                    style: const TextStyle(fontSize: 13),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "English Meaning:\n${todayKural!.meaning['en'] ?? ''}",
                    style: const TextStyle(fontSize: 15),
                  ),
                  const SizedBox(height: 25), // Spacing before icons
                  // Icons are now inside the Column so they scroll with the text
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // English Audio Column
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            icon: const Icon(
                              Icons.volume_up,
                              color: Colors.blue,
                              size: 24,
                            ),
                            tooltip: 'Speak English',
                            onPressed: _speakEnglish,
                          ),
                          const Text(
                            "English",
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 20),
                      // Tamil Audio Column
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            icon: const Icon(
                              Icons.record_voice_over,
                              color: Colors.orange,
                              size: 24,
                            ),
                            tooltip: 'Speak Tamil',
                            onPressed: _speakTamil,
                          ),
                          const Text(
                            "தமிழ்",
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20), // Bottom padding
                ],
              ),
            ),
    );
  }
}
