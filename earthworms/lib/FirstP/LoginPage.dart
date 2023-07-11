import 'package:earthworms/FirstP/RegisterPage.dart';
import 'package:earthworms/MainFunc/homepage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

// ignore: must_be_immutable
class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  //text editing controller
  // final emailController = TextEditingController();
  // final passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void _LohinFunc() async {
    String email = emailController.text;
    String password = passwordController.text;
  }

  @override
  Widget build(BuildContext context) {
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Scaffold(
          backgroundColor: const Color.fromRGBO(250, 246, 229, 1),
          body: SafeArea(
              child: Center(
            child: Column(
              children: <Widget>[
                const SizedBox(height: 1),
                if (!isKeyboard)

                  //logo
                  Image.asset("images/EarthwormIcon.png",
                      height: 250, width: 250),
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

                //Email
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: TextFormField(
                    controller: emailController,
                    obscureText: false,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your Email';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color.fromRGBO(17, 41, 34, 0.9)),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      fillColor: Color.fromRGBO(17, 41, 34, 0.9),
                      filled: true,
                      hintText: 'Email',
                      hintStyle: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                //Password
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your Password';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color.fromRGBO(17, 41, 34, 0.9)),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      fillColor: Color.fromRGBO(17, 41, 34, 0.9),
                      filled: true,
                      hintText: 'Password',
                      hintStyle: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
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
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                )),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegisterPage()),
                          );
                        },
                        child: const Text(
                          'Register',
                          style: TextStyle(
                            color: Color.fromRGBO(17, 41, 34, 0.9),
                            decoration: TextDecoration.underline
                          ),),
                      )
                    ],
                  ),
                ),

                // Login button
                InkWell(
                  onTap: () {
                    print('login');
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => homepage()));
                    //login(emailController, passwordController);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.symmetric(horizontal: 25),
                    decoration: BoxDecoration(
                        color: const Color.fromRGBO(239, 165, 38, 1),
                        borderRadius: BorderRadius.circular(20)),
                    child: const Center(
                      child: Text(
                        'Login',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )),
        ));
  }
}
