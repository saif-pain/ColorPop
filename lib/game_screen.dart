import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class ColorMatchGame extends StatefulWidget {
  const ColorMatchGame({super.key});

  @override
  _ColorMatchGameState createState() => _ColorMatchGameState();
}

class _ColorMatchGameState extends State<ColorMatchGame> {
  final List<Color> colors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
  ];
  late Color currentColor;
  int score = 0;
  double progress = 1.0;
  Timer? timer;
  Duration roundDuration = Duration(seconds: 3);

  @override
  void initState() {
    super.initState();
    startNewRound();
  }

  void startNewRound() {
    currentColor = colors[Random().nextInt(colors.length)];
    progress = 1.0;

    timer?.cancel();
    timer = Timer.periodic(Duration(milliseconds: 50), (t) {
      setState(() {
        progress -= 0.05;
        if (progress <= 0) {
          t.cancel();
          showGameOverDialog();
        }
      });
    });
  }

  void checkAnswer(Color selectedColor) {
    if (selectedColor == currentColor) {
      setState(() {
        score++;
        if (roundDuration.inMilliseconds > 800) {
          roundDuration -= Duration(milliseconds: 100);
        }
      });
      startNewRound();
    } else {
      timer?.cancel();
      showGameOverDialog();
    }
  }

  void showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text("🎮 Game Over"),
        content: Text("Your Score: $score"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              restartGame();
            },
            child: Text("Play Again"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(); // Go back to home
            },
            child: Text("Home"),
          ),
        ],
      ),
    );
  }

  void restartGame() {
    setState(() {
      score = 0;
      roundDuration = Duration(seconds: 3);
    });
    startNewRound();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Widget colorButton(Color color) {
    return Expanded(
      child: GestureDetector(
        onTap: () => checkAnswer(color),
        child: Container(
          height: 70,
          margin: EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('🎨 ColorPop'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Text('Score: $score', style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: Colors.white24,
              valueColor: AlwaysStoppedAnimation<Color>(currentColor),
            ),
            SizedBox(height: 40),
            Center(
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: currentColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: currentColor.withOpacity(0.6),
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                ),
              ),
            ),
            Spacer(),
            Row(children: colors.map((c) => colorButton(c)).toList()),
          ],
        ),
      ),
    );
  }
}
