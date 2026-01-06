// lib/hint_search_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'kural_model.dart';

class HintSearchPage extends StatefulWidget {
  final List<Kural> kurals;
  const HintSearchPage({super.key, required this.kurals});

  @override
  State<HintSearchPage> createState() => _HintSearchPageState();
}

class _HintSearchPageState extends State<HintSearchPage> {
  final TextEditingController _controller = TextEditingController();
  List<Kural> _filteredKurals = [];
  late stt.SpeechToText _speech;
  bool _isListening = false;
  // --- STT CHANGE: State for language selection ---
  String _selectedLocaleId = 'ta-IN'; // Default to Tamil
  final FlutterTts _flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _flutterTts.setSpeechRate(0.5);
  }

  /// Smart search with Tamil + English fuzzy, accent‑insensitive match
  void _performSearch() {
    final keyword = _controller.text.trim().toLowerCase();
    if (keyword.isEmpty) return;

    // English word regex (whole-word match)
    final englishRegex = RegExp(r'\b' + RegExp.escape(keyword) + r'\b');

    final results = widget.kurals.where((kural) {
      final english = (kural.meaning["en"] ?? "").toLowerCase();
      final tamil1 = (kural.meaning["ta_mu_va"] ?? "").toLowerCase();
      final tamil2 = (kural.meaning["ta_salamon"] ?? "").toLowerCase();
      final couplet = kural.kural.join(" ").toLowerCase();

      // English: stricter match
      final englishMatch = englishRegex.hasMatch(english);

      // Tamil: simple contains (DO NOT use regex)
      final tamilMatch =
          tamil1.contains(keyword) ||
          tamil2.contains(keyword) ||
          couplet.contains(keyword);

      return englishMatch || tamilMatch;
    }).toList();

    setState(() => _filteredKurals = results);

    if (results.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "No matching Kural found. Try another word.\n"
            "பொருத்தமான குறள் எதுவும் கிடைக்கவில்லை.",
          ),
        ),
      );
    }
  }

  /// 🎤 Voice input - Updated for Tamil detection and No Auto-Search
  Future<void> _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          localeId: _selectedLocaleId, // Use selected language (ta-IN or en-IN)
          onResult: (result) {
            setState(() {
              _controller.text = result.recognizedWords;
              // Stop listening animation once the result is final
              if (result.finalResult) {
                _isListening = false;
              }
            });
          },
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _speech.stop();
    _flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Search by Hint/குறிப்பு மூலம் தேடல்',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            const Text(
              "Enter a hint (eg. education, God, ...). குறிப்பு கொடுங்கள் (உ. கல்வி, கடவுள், நட்பு,...)",
              style: TextStyle(fontSize: 16),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: 'Enter hint word',
                    ),
                  ),
                ),
                // --- STT CHANGE: Positions swapped to put selector near mic ---
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _performSearch,
                ),
                DropdownButton<String>(
                  value: _selectedLocaleId,
                  underline: const SizedBox(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedLocaleId = newValue!;
                    });
                  },
                  items: const [
                    DropdownMenuItem(
                      value: 'ta-IN',
                      child: Text("தமிழ்", style: TextStyle(fontSize: 12)),
                    ),
                    DropdownMenuItem(
                      value: 'en-IN',
                      child: Text("Eng", style: TextStyle(fontSize: 12)),
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(
                    _isListening ? Icons.mic_off : Icons.mic,
                    color: _isListening ? Colors.red : null,
                  ),
                  onPressed: _listen,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: _filteredKurals.isEmpty
                  ? const Center(child: Text('No results yet.'))
                  : ListView.builder(
                      itemCount: _filteredKurals.length,
                      itemBuilder: (context, index) {
                        final kural = _filteredKurals[index];
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Full Width Kural Text
                                Text(
                                  "${kural.kural[0]}\n${kural.kural[1]}",
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Kural #: ${kural.number}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "தமிழ் விளக்கம்: ${kural.meaning["ta_salamon"] ?? ""}",
                                ),
                                SizedBox(height: 6),
                                Text(
                                  "தமிழ் விளக்கம்: ${kural.meaning["ta_mu_va"] ?? ""}",
                                ),
                                Text("English: ${kural.meaning["en"] ?? ""}"),

                                const Divider(), // Separator before icons
                                // Icons and Text displayed AFTER each Kural (Full Width Row)
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
                                          onPressed: () async {
                                            final english =
                                                kural.meaning['en'] ?? '';
                                            await _flutterTts.setLanguage(
                                              'en-IN',
                                            );
                                            await _flutterTts.speak(english);
                                          },
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
                                    const SizedBox(
                                      width: 25,
                                    ), // Spacing between the two columns
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
                                          onPressed: () async {
                                            if ((await _flutterTts.getLanguages)
                                                .contains("ta-IN")) {
                                              final tamil =
                                                  "${kural.kural[0]}\n${kural.kural[1]}\nதமிழ் விளக்கம்:\n${kural.meaning["ta_salamon"] ?? ""}";
                                              await _flutterTts.setLanguage(
                                                'ta-IN',
                                              );
                                              await _flutterTts.speak(tamil);
                                            } else {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                    "Tamil audio is not available. Please check your TTS settings. இந்த போனில் தமிழ் பேச்சு ஆதரிக்கப்படவில்லை.",
                                                  ),
                                                ),
                                              );
                                            }
                                          },
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
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
