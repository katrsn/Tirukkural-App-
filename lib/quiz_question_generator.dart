import 'dart:math';
import 'kural_model.dart';

class QuizQuestion {
  final String questionTa;
  final String questionEn;
  final String answerTa;
  final String answerEn;

  QuizQuestion({
    required this.questionTa,
    required this.questionEn,
    required this.answerTa,
    required this.answerEn,
  });
}

class QuizGenerator {
  final List<Kural> kurals;
  final Random _random = Random();

  QuizGenerator(this.kurals);

  List<QuizQuestion> generateQuiz(int count) {
    List<Kural> validKurals = kurals
        .where((k) => k.section != "இன்பத்துப்பால்")
        .toList();

    validKurals.shuffle();

    List<QuizQuestion> questions = [];
    Set<int> usedNumbers = {};

    for (var kural in validKurals) {
      if (usedNumbers.contains(kural.number)) continue;

      final int type = _random.nextInt(4);
      late String qTa, qEn, aTa, aEn;

      switch (type) {
        case 0:
          qTa = "குறள் எண் ${kural.number} இற்கான குறளை சொல்லுங்கள்.";
          qEn = "What is the couplet for Kural number ${kural.number}?";
          aTa = kural.kural.join("\n");
          aEn = kural.meaning['en'] ?? "";
          break;
        case 1:
          qTa = "${kural.kural[0]}... என்ற குறள் எண் எது?";
          qEn = "Which Kural number has the line: '${kural.kural[0]}'?";
          aTa = "குறள் எண்: ${kural.number}";
          aEn = "Kural Number: ${kural.number}";
          break;
        case 2:
          qTa = "${kural.kural[0]} குறள் எந்த அதிகாரத்தில் வருகிறது?";
          qEn = "Which chapter does the Kural '${kural.kural[0]}' belong to?";
          aTa = "அதிகாரம்: ${kural.chapter}";
          aEn = "Chapter: ${kural.chapter}";
          break;
        case 3:
          qTa = "${kural.chapter} அதிகாரத்தில் வரும் மற்றொரு குறள்?";
          qEn = "Name another Kural from the chapter '${kural.chapter}'?";
          aTa = kural.kural.join("\n");
          aEn = kural.meaning['en'] ?? "";
          break;
      }

      questions.add(QuizQuestion(
        questionTa: qTa,
        questionEn: qEn,
        answerTa: aTa,
        answerEn: aEn,
      ));

      usedNumbers.add(kural.number);
      if (questions.length >= count) break;
    }

    return questions;
  }
}
