import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String title;
  final VoidCallback onPress;
  const MyButton({super.key, required this.title, required this.onPress});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(10),
        ),
        height: 60,
        width: 350,
        margin: EdgeInsets.symmetric(horizontal: 24),
        child: Center(child: Text(title)),
      ),
    );
  }
}
