import 'package:chat_app/screen/login_screen.dart';
import 'package:chat_app/screen/register_screen.dart';
import 'package:flutter/material.dart';

class LoginOrRegisterAuth extends StatefulWidget {
  const LoginOrRegisterAuth({super.key});

  @override
  State<LoginOrRegisterAuth> createState() => _LoginOrRegisterAuthState();
}

class _LoginOrRegisterAuthState extends State<LoginOrRegisterAuth> {
  // initial show login screen
  bool showLoginScreen = true;
  void togglePages() {
    setState(() {
      showLoginScreen = !showLoginScreen;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginScreen) {
      return LoginScreen(
        onTap: togglePages,
      );
    } else {
      return RegisterScreen(
        onTap: togglePages,
      );
    }
  }
}
