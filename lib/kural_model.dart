class Kural {
  final int number;
  final String section;
  final String chapter;
  final List<String> kural;
  final Map<String, String> meaning;

  Kural({
    required this.number,
    required this.section,
    required this.chapter,
    required this.kural,
    required this.meaning,
  });

  factory Kural.fromJson(Map<String, dynamic> json) {
    return Kural(
      number: json['number'] ?? 0,
      section: json['section'] ?? '',
      chapter: json['chapter'] ?? '',
      kural: List<String>.from(json['kural'] ?? ['', '']),
      meaning: Map<String, String>.from(json['meaning'] ?? {
        'ta_mu_va': '',
        'ta_salamon': '',
        'en': '',
      }),
    );
  }

  /// ✅ Provides a default empty Kural to prevent null errors
  factory Kural.empty() {
    return Kural(
      number: 0,
      section: '',
      chapter: '',
      kural: ['', ''],
      meaning: {
        'ta_mu_va': '',
        'ta_salamon': '',
        'en': '',
      },
    );
  }
}
