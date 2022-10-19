import 'package:flutter/material.dart';

class KeyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  const KeyButton({Key? key, required this.icon, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: Container(
          color: Colors.grey[100],
          width: 50.0,
          height: 50.0,
          child: Center(
            child: Icon(icon),
          ),
        ),
      ),
    );
  }
}
