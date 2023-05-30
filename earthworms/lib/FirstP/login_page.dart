import 'package:earthworms/FirstP/regis_page.dart';
import 'package:earthworms/MainFunc/homepage.dart';
import 'package:earthworms/components/login_button.dart';
import 'package:earthworms/components/my_textfield.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  //text editing controller
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void MySignFunc() {}

  @override
  Widget build(BuildContext context) {
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
      backgroundColor: Color.fromRGBO(214, 232, 219, 1),
      body: SafeArea(
          child: Center(
        child: Column(
          children: [
            const SizedBox(height: 1),
            if (!isKeyboard)

              //logo
              Image.asset("images/EarthwormIcon.png", height: 250, width: 250),
            const SizedBox(height: 10),

            //Text
            const Text(
              'Welcome back to our Farm!',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xff0e4f55),
                  fontSize: 16),
            ),
            const SizedBox(height: 25),

            //username
            MyTextField(
              controller: emailController,
              hintText: 'Email',
              obscureText: false,
            ),
            const SizedBox(height: 15),

            //password
            MyTextField(
              controller: passwordController,
              hintText: 'Password',
              obscureText: true,
            ),
            const SizedBox(height: 7),

            //Register button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    style: ElevatedButton.styleFrom(
                        textStyle: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterPage()),
                      );
                    },
                    child: const Text('Register'),
                  )
                ],
              ),
            ),

            // Login button
            LoginButton(
              onTap: MySignFunc,
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => homepage()),
                );
              },
              child: const Text('home')
            )
          ],
        ),
      )),
    );
  }
}
