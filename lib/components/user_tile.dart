import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../theme/theme_provider.dart';

class UserTile extends StatelessWidget {
  const UserTile({super.key, required this.onTap, required this.text});

  final String text;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).colorScheme.secondary,
        ),
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        padding: EdgeInsets.all(25),
        child: Row(
          children: [
            Icon(Icons.person, color: isDarkMode ? Colors.grey : Colors.black),
            Text(
              text,
              style: TextStyle(color: isDarkMode ? Colors.grey : Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
