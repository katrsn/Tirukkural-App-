import 'package:flutter/material.dart';
import 'kural_model.dart';
import 'quiz_helper.dart';

class QuizPage extends StatefulWidget {
  final List<Kural> kurals;

  const QuizPage({super.key, required this.kurals});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<QuizQuestion> questions = [];

  @override
  void initState() {
    super.initState();
    questions = QuizGenerator.generateQuestions(widget.kurals, 5);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
//        title: const Text('Tirukkural Quiz/திருக்குறள் வினாடி வினா')
        title: const Column(
          // Align the text to the start (left side) of the AppBar title area
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, // Keep the column compact vertically
          children: [
            Text(
              'Tirukkural Quiz',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            // Add a small space between the two lines
            SizedBox(height: 4),
            Text(
              'திருக்குறள் வினாடி வினா',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: questions.length,
        itemBuilder: (context, index) {
          final q = questions[index];
          return Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ExpansionTile(
              title: Text(
                "Q${index + 1}: ${q.question}",
                style: const TextStyle(),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    q.answer,
                    style: const TextStyle(fontSize: 15, height: 1.5),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            questions = QuizGenerator.generateQuestions(widget.kurals, 5);
          });
        },
        tooltip: 'New Quiz',
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
