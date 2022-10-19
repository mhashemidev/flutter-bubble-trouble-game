import 'dart:async';

import 'package:bubble_trouble/presentation/widgets/my_ball.dart';
import 'package:bubble_trouble/presentation/widgets/my_missile.dart';
import 'package:bubble_trouble/presentation/widgets/my_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widgets/key_button.dart';

enum direction { LEFT, RIGHT }

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  double playerX = 0;
  double missileX = 0;
  double missileHeight = 10;
  bool midShot = false;
  double ballX = 0.5;
  double ballY = 1;
  var ballDirection = direction.LEFT;

  void startGame() {
    double time = 0;
    double height = 0;
    double velocity = 60;

    Timer.periodic(const Duration(milliseconds: 10), (timer) {
      // quadratic bounce equation
      height = -5 * time * time + velocity * time;

      if (height < 0) {
        time = 0;
      }

      setState(() {
        ballY = heightToPosition(height);
      });

      if (ballX - 0.005 < -1) {
        ballDirection = direction.RIGHT;
      } else if (ballX + 0.03 > 1) {
        ballDirection = direction.LEFT;
      }

      setState(() {
        if (ballDirection == direction.LEFT) ballX -= 0.005;
        if (ballDirection == direction.RIGHT) ballX += 0.005;
      });

      if (playerDies()) {
        timer.cancel();
        _showDialog();
      }

      time += 0.1;
    });
  }

  double heightToPosition(double height) {
    double totalHeight = MediaQuery.of(context).size.height * 3 / 4;
    double position = 1 - 2 * height / totalHeight;
    return position;
  }

  void moveLeft() {
    setState(() {
      if (playerX - 0.1 > -1) playerX -= 0.1;
      if (!midShot) missileX = playerX;
    });
  }

  void moveRight() {
    setState(() {
      if (playerX + 0.1 < 1) playerX += 0.1;
      if (!midShot) missileX = playerX;
    });
  }

  void fireMissile() {
    if (!midShot) {
      Timer.periodic(const Duration(milliseconds: 20), (timer) {
        midShot = true;
        setState(() {
          missileHeight += 10;
        });

        // stop missile when it reaches top of the screen
        if (missileHeight > MediaQuery.of(context).size.height * 3 / 4) {
          timer.cancel();
          resetMissile();
        }

        // check if missile hits the ball
        if (ballY > heightToPosition(missileHeight) &&
            (ballX - missileX).abs() < 0.04) {
          resetMissile();
          ballY = 0;
          timer.cancel();
        }
      });
    }
  }

  void resetMissile() {
    missileX = playerX;
    missileHeight = 10;
    midShot = false;
  }

  bool playerDies() {
    if ((ballX - playerX).abs() < 0.005 && ballY > 0.75) {
      return true;
    }
    return false;
  }

  _showDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.grey[700],
            title: const Text(
              "You dead bro!!!",
              style: TextStyle(color: Colors.white),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKey: (RawKeyEvent event) {
        if (event.isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
          moveLeft();
        } else if (event.isKeyPressed(LogicalKeyboardKey.arrowRight)) {
          moveRight();
        } else if (event.isKeyPressed(LogicalKeyboardKey.arrowUp)) {
          fireMissile();
        }
      },
      child: Column(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              color: Colors.pink[100],
              child: Center(
                child: Stack(
                  children: [
                    MyBall(ballX: ballX, ballY: ballY),
                    MyMissile(missileHeight: missileHeight, missileX: missileX),
                    MyPlayer(playerX: playerX),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.grey,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  KeyButton(icon: Icons.play_arrow, onTap: startGame),
                  KeyButton(icon: Icons.arrow_back, onTap: moveLeft),
                  KeyButton(icon: Icons.arrow_upward, onTap: fireMissile),
                  KeyButton(icon: Icons.arrow_forward, onTap: moveRight),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
