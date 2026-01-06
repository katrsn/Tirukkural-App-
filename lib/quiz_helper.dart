import 'dart:math';
import 'kural_model.dart';

class QuizQuestion {
  final String question;
  final String answer;

  QuizQuestion({required this.question, required this.answer});
}

class QuizGenerator {
  static final _random = Random();

  static List<QuizQuestion> generateQuestions(List<Kural> kurals, int count) {
    List<Kural> filteredKurals = kurals
        .where((kural) => kural.section != "இன்பத்துப்பால்")
        .toList();

    filteredKurals.shuffle();
    List<QuizQuestion> questions = [];

    for (int i = 0; i < count && i < filteredKurals.length; i++) {
      final kural = filteredKurals[i];
      final type = _random.nextInt(5);

      switch (type) {
        case 0:
          questions.add(QuizQuestion(
              question:
                  "குறள் எண் ${kural.number} என்பதன் விளக்கம் என்ன?\nWhat is the explanation of Kural number ${kural.number}?\n\n${kural.kural.join("\n")}",
              answer:
                  "${kural.meaning['ta_mu_va']}\n\nEnglish: ${kural.meaning['en']}"));
          break;
        case 1:
          questions.add(QuizQuestion(
              question:
                  "பின்வரும் விளக்கத்துக்கு பொருந்தும் குறள் எது?\nWhich Kural matches the explanation?\n\n${kural.meaning['ta_salamon']}",
              answer: kural.kural.join("\n")));
          break;
        case 2:
          questions.add(QuizQuestion(
              question:
                  "குறள் எண் ${kural.number} எந்த அதிகாரத்தில் உள்ளது?\nWhich chapter does Kural number ${kural.number} belong to?",
              answer: kural.chapter));
          break;
        case 3:
          questions.add(QuizQuestion(
              question:
                  "‘${kural.chapter}’ அதிகாரத்திற்கு அடுத்த அதிகாரம் எது?\nWhat is the next chapter after '${kural.chapter}'?",
              answer: findNextChapter(kurals, kural.chapter)));
          break;
        case 4:
          questions.add(QuizQuestion(
              question:
                  "‘${kural.chapter}’ அதிகாரத்தில் உள்ள 10 குறள்களை பட்டியலிடுக.\nList the 10 Kurals in '${kural.chapter}' chapter.",
              answer: listKuralsInChapter(kurals, kural.chapter)));
          break;
      }
    }

    return questions;
  }

  static String findNextChapter(List<Kural> kurals, String currentChapter) {
    final chapters = [
      ...{for (var kural in kurals) kural.chapter}
    ].toList();
    final index = chapters.indexOf(currentChapter);
    if (index >= 0 && index < chapters.length - 1) {
      return chapters[index + 1];
    }
    return "முடிவடைந்தது / End of chapters";
  }

  static String listKuralsInChapter(List<Kural> kurals, String chapter) {
    final filtered = kurals.where((k) => k.chapter == chapter).toList();
    return filtered
        .map((k) => "${k.number}. ${k.kural.join(" ")}")
        .join("\n\n");
  }
}
