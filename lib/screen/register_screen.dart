import 'package:chat_app/services/auth/auth_service.dart';
import 'package:chat_app/components/my_button.dart';
import 'package:chat_app/components/my_text_field.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key, required this.onTap});
  final void Function()? onTap;

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmedPassController = TextEditingController();

  void signUp(BuildContext context) async {
    AuthService authService = AuthService();

    if (passwordController.text == confirmedPassController.text) {
      try {
        final String email = emailController.text.trim();
        final String password = passwordController.text.trim();
        authService.signUpWithEmailAndPassword(email, password);
      } catch (e) {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text('error occure $e'),
                ));
      }
    } else {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text("password don't match!"),
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // logo
            Icon(
              Icons.message,
              size: 60,
              color: Theme.of(context).colorScheme.primary,
            ),
            // wellcome message
            SizedBox(height: 50),
            Text(
              "Lets create acount an for you!",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.primary, fontSize: 16),
            ),
            SizedBox(height: 30),
            // email textform field
            MyTextField(
              controller: emailController,
              hintText: 'Email',
              obsecureText: false,
            ),
            SizedBox(height: 15),
            // pass textformfield
            MyTextField(
              controller: passwordController,
              hintText: 'Password',
              obsecureText: true,
            ),
            SizedBox(height: 15),
            // confirm password
            MyTextField(
              controller: confirmedPassController,
              hintText: 'Confirmed',
              obsecureText: true,
            ),
            // login button
            SizedBox(height: 40),
            MyButton(
              onPress: () => signUp(context),
              title: 'Register',
            ),
            // register
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Already have an acount?  ',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
                GestureDetector(
                  onTap: widget.onTap,
                  child: Text(
                    'Login now',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
