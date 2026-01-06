import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'kural_model.dart';
import 'chapter_keywords.dart';
import 'kural_data_maps.dart';


final List<String> englishChapterTitles = [
  "Praise of God", "Praise of Rain", "Greatness of Renunciation", "Righteousness", "Family Life",
  "Wives Welfare", "Children", "Kindness", "Hospitality", "Sweet Talk",
  "Gratitude", "Balanced", "Self-Control", "Right Conduct", "Adultery",
  "Patience", "Envy", "Non-Coveting", "Not Back-Biting", "Frivolity of Speech",
  "Fear of Evil Deeds", "Decorum", "Liberality", "Renown", "Compassion",
  "Abstaining from Meat", "Penance", "Improper Conduct", "Non-Stealing", "Truth",
  "Not Getting Angry", "Not Doing Evil", "Not Killing", "Instability", "Renunciation",
  "Realising Knowledge", "Destruction of Desire", "Fate", "Majesty", "Learning",
  "Non-Learning", "Hearing", "Knowledge", "Restraining Faults", "Association with Elders",
  "Avoiding Low Company", "Action after Due Deliberation", "Knowing the Enemy's Strength", "Knowing the Time", "Knowing the Place",
  "Engaging Servants After Test", "Appointment According to Merit", "Cherishing One's Kindred", "Against Forgetfulness", "Righteous Sceptre",
  "Unrighteous Rule", "Tyranny", "Kindliness", "Spies", "Exertion",
  "Against Sloth", "Perseverance", "Courage", "Ministers", "Good Speech",
  "Purity in Action", "Resoluteness", "Means of Action", "Embassy", "Co-operation with King",
  "Reading One's Intentions", "Knowing the Assembly", "Not to be Afraid of Assembly", "Country", "Fortress",
  "Acquisition of Wealth", "Value of an Army", "Courage of the Army", "Friendship", "Identifying Friends",
  "Friendship Behaviour", "Bad Friendship", "False Alliance", "Stupidity", "Ignorance",
  "Discord", "Enmity", "Knowing the Enemy's Strength", "Internal Foes", "Not Censuring the Great",
  "Fear of Wife", "Prostitutes", "Avoiding Alcohol", "Gambling", "Medicine",
  "Noble Lineage", "Honour", "Greatness", "Good Conduct", "Courtesy",
  "Unprofitable Wealth", "Modesty", "Exalting One's Family", "Agriculture", "Poverty",
  "Begging", "Fear of Begging", "Meanness", "Lover's Distraction", "Reading Love's Signs",
  "Ecstasy of Love's Union", "His Lady", "Affirmation of Love", "Speaking Out Unabashed", "Rumours of Secret Love",
  "The Pangs of Separation", "The Cry of the Separated", "On Eyes That Languish", "Grieving Over Love's Pallor", "Feeling All Alone",
  "Recollecting the Pleasures of Love", "Dreams of Love", "Sunset and Sorrow", "Wasting Away", "Soliloquy of the Lady Love",
  "Loss of Modesty", "Distress of each Towards the Other", "Speaking on the Signs", "Yearning After Union", "Speaking with the Mind",
  "Lovers' Misunderstanding", "Subtlety of Lovers' Misunderstanding", "Pleasures of Lovers' Misunderstanding"
];

class TitleOrNumberPage extends StatefulWidget {
  final List<Kural> kurals;

  const TitleOrNumberPage({super.key, required this.kurals});

  @override
  _TitleOrNumberPageState createState() => _TitleOrNumberPageState();
}

class _TitleOrNumberPageState extends State<TitleOrNumberPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  String? _selectedSection;
  String? _selectedChapter;
  List<Kural> _searchResults = [];
  String _searchMode = '';
  String _searchLabel = '';
  final FlutterTts _flutterTts = FlutterTts();
  List<String> _languages = [];

  Set<String> getUniqueChaptersForSection(String section) {
    return widget.kurals
        .where((kural) => kural.section == section)
        .map((kural) => kural.chapter)
        .toSet();
  }

  void _searchByTitle(String titleInput) {
    String input = titleInput.trim();
    if (input.isEmpty) return;

    String? matchedTamilTitle;

    // Match English → Tamil chapter mapping
    englishToTamilChapterMap.forEach((eng, tam) {
      if (input.toLowerCase() == eng.toLowerCase()) {
        matchedTamilTitle = tam;
      }
    });

    // If English/Tamil title found
    setState(() {
      _searchResults = widget.kurals
          .where((k) => k.chapter == matchedTamilTitle || k.chapter == input)
          .toList();
    });

    // 🔥 NEW: If no matches found → show bilingual message
    if (_searchResults.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Chapter not found. Please enter the correct name or select through Section.\n"
            "அதிகாரப் பெயர் பொருந்தவில்லை. சரியான பெயரை உள்ளிடவும் அல்லது பால் மூலம் தேர்வு செய்யவும்.",
            style: TextStyle(fontSize: 14),
          ),
          duration: Duration(seconds: 5),
        ),
      );
    }

    // Labels + Reset other search modes
    _searchLabel = "Search Results - Chapter / தேடல் முடிவுகள் - அதிகாரம்";
    _searchMode = 'title';
    _numberController.clear();
   _selectedSection = null;
   _selectedChapter = null;
  }

  void _searchByNumber(String numberInput) {
    final int? kuralNum = int.tryParse(numberInput);

    // If input is not a valid number
    if (kuralNum == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid number.")),
      );
      return;
    }

    // Number out of valid range
    if (kuralNum < 1 || kuralNum > 1330) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Number not found. Enter a number from 1 to 1330. 1 இலிருந்து 1330 வரையிலான எண்ணை உள்ளிடவும்.")),
      );
      return;
    }

    // Search result
    final results = widget.kurals.where((k) => k.number == kuralNum).toList();

    // If number does not exist inside JSON (extremely rare but safe)
    if (results.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Kural number not found. Please try another. வேறு எண்ணை முயற்சிக்கவும்")),
      );
      return;
    }

    // Otherwise update the UI
    setState(() {
      _searchResults = results;
     _searchLabel = "Search Results - Kural Number / தேடல் முடிவுகள் - குறள் எண்";
      _searchMode = 'number';
      _titleController.clear();
      _selectedSection = null;
      _selectedChapter = null;
    });
  }


  void _searchByChapterFromSection(String? chapter) {
    if (chapter == null) return;
    setState(() {
      _searchResults = widget.kurals.where((k) => k.chapter == chapter).toList();
      _searchLabel = "Search Results - Section & Chapter / தேடல் முடிவுகள் - பால் & அதிகாரம்";
      _searchMode = 'section';
      _titleController.clear();
      _numberController.clear();
    });
  }

  Future<void> _speakEnglish(Kural kural) async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.speak(kural.meaning["en"] ?? "");
  }

  Future<void> _speakTamil(Kural kural) async {
    String tamilText = "${kural.kural[0]}\n${kural.kural[1]}\nதமிழ் விளக்கம்:\n${kural.meaning["ta_salamon"] ?? ""}";
    //String tamilText = "${kural.kural[0]}\n${kural.kural[1]}\n${kural.meaning["ta_salamon"] ?? ""}";
    if (_languages.contains("ta-IN")) {
      await _flutterTts.setLanguage("ta-IN");
      await _flutterTts.speak(tamilText);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Tamil TTS not supported on this device. இந்த போனில் தமிழ் பேச்சு ஆதரிக்கப்படவில்லை.")),
      );
    }
  }

  Map<String, String> chapterEnglishMap = {};

  @override
  void initState() {
    super.initState();

    _flutterTts.getLanguages.then((langs) {
      setState(() {
        _languages = List<String>.from(langs);
      });
    });

    // 👇 Extract Tamil chapter names in order from loaded Kurals
    final orderedTamilChapters = <String>[];
    final seen = <String>{};

    for (var kural in widget.kurals) {
      if (!seen.contains(kural.chapter)) {
        orderedTamilChapters.add(kural.chapter);
        seen.add(kural.chapter);
    } 
    }

    // 👇 Map each Tamil chapter to English using index
    for (int i = 0; i < orderedTamilChapters.length && i < englishChapterTitles.length; i++) {
      chapterEnglishMap[orderedTamilChapters[i]] = englishChapterTitles[i];
    }
  }



  @override
  void dispose() {
    _flutterTts.stop();
    _titleController.dispose();
    _numberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sections = widget.kurals.map((k) => k.section).toSet().toList();
    final chapters = _selectedSection != null
        ? getUniqueChaptersForSection(_selectedSection!).toList()
        : [];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true, // optional if back button is required
        toolbarHeight: 70, // slightly increased height for two lines
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Search by Section/Chapter/Number',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            Text(
              'பால், அதிகாரம், எண் மூலம் தேடல்',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _numberController,
                decoration: InputDecoration(
                  // The problematic long label text
                  labelText: 'Enter Kural Number / குறள் எண்ணை உள்ளிடவும்', 
                  labelStyle: TextStyle(fontSize: 13),  
                // 👇 ADD THIS LINE to allow the label to wrap
                  alignLabelWithHint: true, 

                  suffixIcon: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () => _searchByNumber(_numberController.text),
                  ),
                )
              ),
              SizedBox(height: 16),

              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  // The problematic long label text
                  labelText: 'Enter Chapter Title / அதிகாரத்தை உள்ளிடவும்',
                  labelStyle: TextStyle(fontSize: 13),
                  // 👇 ADD THIS LINE to allow the label to wrap
                  alignLabelWithHint: true,

                  suffixIcon: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () => _searchByTitle(_titleController.text),
                  ),
                ),
              ),
              SizedBox(height: 16),              


              DropdownButton<String>(
                value: _selectedSection,
                isExpanded: true,
                hint: Text('Select Section /  பாலை தேர்ந்தெடுக்கவும்', style:TextStyle(fontSize: 12)),
                items: sections.map((section) {
                  final english = sectionTranslations[section] ?? '';
                  return DropdownMenuItem<String>(
                    value: section,
                    child: Text('$section - $english', style: TextStyle(fontSize: 12),),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedSection = value;
                    _selectedChapter = null;
                    _searchResults = [];
                    _titleController.clear();
                    _numberController.clear();
                  });
                },
              ),
              SizedBox(height: 14),

            if (_selectedSection != null)
              DropdownButton<String>(
                value: _selectedChapter,
                isExpanded: true,
                hint: Text('Select Chapter / அதிகாரத்தை தேர்ந்தெடுக்கவும்', style:TextStyle(fontSize: 12)),
                items: chapters.map((chapter) {
                  final english = chapterEnglishMap[chapter] ?? '';
                  return DropdownMenuItem<String>(
                    value: chapter,
                    child: Text('$chapter - ${chapterEnglishMap[chapter] ?? ''}', style: TextStyle(fontSize: 12),),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedChapter = value;
                    _searchByChapterFromSection(value);
                  });
                },
               ),
              SizedBox(height: 14),

              Divider(height: 24, thickness: 1),
              if (_searchResults.isNotEmpty)
                Text(_searchLabel, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),

              ..._searchResults.map((kural) {
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Kural/குறள் எண் ${kural.number}",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(kural.kural[0], style: TextStyle(fontSize: 13),),
                        Text(kural.kural[1], style: TextStyle(fontSize: 13),),
                        SizedBox(height: 6),
                        Text("Meaning (EN): ${kural.meaning["en"] ?? ""}"),
                        SizedBox(height: 6),
                        Text("தமிழ் விளக்கம்: ${kural.meaning["ta_salamon"] ?? ""}", style: TextStyle(fontSize: 12),),
                        SizedBox(height: 6),
                        Text("தமிழ் விளக்கம்: ${kural.meaning["ta_mu_va"] ?? ""}", style: TextStyle(fontSize: 12),),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // English Audio Group
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.volume_up,
                                    color: Colors.blue,
                                  ),
                                  tooltip: 'Speak English',
                                  onPressed: () => _speakEnglish(kural),
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
                              width: 20,
                            ), // Spacing between the two audio buttons
                            // Tamil Audio Group
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.record_voice_over,
                                    color: Colors.orange,
                                  ),
                                  tooltip: 'Speak Tamil',
                                  onPressed: () => _speakTamil(kural),
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
              }),
            ],
          ),
        ),
      ),
    );
  }
}
