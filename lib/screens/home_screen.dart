import 'package:flutter/material.dart';
import 'package:quizz_app/models/question_model.dart';
import '../constants.dart';
import '../widgets/question_widget.dart';
import '../widgets/next_button.dart';
import '../widgets/option_card.dart';
import '../widgets/result_box.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<question> _questions = [
    question(
      id: '10',
      title: 'What is 5 + 5?',
      options: {'11': false, '12': false, '10': true, '13': false},
    ),
    question(
      id: '11',
      title: 'What is 10 + 5?',
      options: {'11': false, '15': true, '16': false, '13': false},
    ),
    question(
      id: '12',
      title: 'What is 10 + 17?',
      options: {'21': false, '27': true, '26': false, '23': false},
    ),
    question(
      id: '13',
      title: 'What is 9 + 5?',
      options: {'14': true, '15': false, '16': false, '13': false},
    ),
    question(
      id: '14',
      title: 'What is 10 + 10?',
      options: {'20': true, '15': false, '16': false, '13': false},
    ),
  ];

  int index = 0;
  int score = 0;
  bool isPressed = false;
  bool isAlreadySelected = false;

  void nextQuestion() {
    if (index == _questions.length - 1) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => ResultBox(
          result: score,
          questionLength: _questions.length,
          onPressed: startOver,
        ),
      );
    } else {
      if (isPressed) {
        setState(() {
          index++;
          isPressed = false;
          isAlreadySelected = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select an option'),
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.symmetric(vertical: 20.0),
          ),
        );
      }
    }
  }

  void checkAnswerAndUpdate(bool value) {
    if (isAlreadySelected) {
      return;
    } else {
      if (value) {
        score++;
      }
      setState(() {
        isPressed = true;
        isAlreadySelected = true;
      });
    }
  }

  void startOver() {
    setState(() {
      index = 0;
      score = 0;
      isPressed = false;
      isAlreadySelected = false;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: const Text('Quiz App'),
        backgroundColor: background,
        shadowColor: Colors.transparent,
        actions: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Text(
              'Score: $score',
              style: const TextStyle(fontSize: 18.0),
            ),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          children: [
            Questionwidget(
              indexAction: index,
              question: _questions[index].title,
              totalQuestions: _questions.length,
            ),
            const Divider(color: neutral),
            const SizedBox(height: 25.0),
            for (int i = 0; i < _questions[index].options.length; i++)
              OptionCard(
                option: _questions[index].options.keys.toList()[i],
                color: isPressed
                    ? _questions[index].options.values.toList()[i] == true
                        ? correct
                        : incorrect
                    : neutral,
                onTap: () => checkAnswerAndUpdate(_questions[index].options.values.toList()[i]),
              ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: NextButton(nextQuestion: nextQuestion),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
