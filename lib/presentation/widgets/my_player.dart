import 'package:flutter/material.dart';

class MyPlayer extends StatelessWidget {
  final double playerX;
  const MyPlayer({Key? key, required this.playerX}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(playerX, 1),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Container(
          width: 50,
          height: 50,
          color: Colors.deepPurple,

        ),
      ),
    );
  }
}
