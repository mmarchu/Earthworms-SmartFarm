import 'dart:convert';
import 'package:earthworms/Profile/RegisterPage.dart';
import 'package:earthworms/MainFunc/homepage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

// ignore: must_be_immutable
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String CorrectEmail = "admin@test.com";
  String CorrectPassword = "admin";
  String CorrectName = "Admin";
  String CorrectLastname = "Test";

  // void login() {
  //   if (emailController.text == CorrectEmail &&
  //       passwordController.text == CorrectPassword) {
  //     Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => homepage(
  //               email: CorrectEmail,
  //               name: CorrectName,
  //               lastname: CorrectLastname),
  //         ));
  //   } else {
  //     var snackBar = SnackBar(
  //         content:
  //             Text("Login Failed. Please check your username and password."));
  //     ScaffoldMessenger.of(context).showSnackBar(snackBar);
  //   }
  // }

  Future<void> _login() async {
    final email = emailController.text;
    final password = passwordController.text;

    final response = await http.post(
      Uri.parse('http://localhost:4000/api/auth/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charest=UTF-8'
      },
      body: jsonEncode({'email': email, 'password': password}));
      if (response.statusCode == 200) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => homepage(
                  email: CorrectEmail,
                  name: CorrectName,
                  lastname: CorrectLastname),
            ));
      } else {
          var snackBar = SnackBar(
            content:
              Text("Login Failed. Please check your username and password."));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }

  }

  @override
  Widget build(BuildContext context) {
    //final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Scaffold(
            backgroundColor: Color.fromRGBO(250, 246, 229, 1),
            body: SafeArea(
              child: Container(
                  child: SingleChildScrollView(
                child: Column(
                  children: [
                    //const SizedBox(height: 1),
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
                        // validator: (value) {
                        //   if (value.isEmpty) {
                        //     return 'Please enter your name';
                        //   }
                        //   return null;
                        // },
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                        decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromRGBO(17, 41, 34, 0.9)),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          fillColor: Color.fromRGBO(42, 62, 54, 1),
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
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                        decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromRGBO(17, 41, 34, 0.9)),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          fillColor: Color.fromRGBO(42, 62, 54, 1),
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
                                  decoration: TextDecoration.underline),
                            ),
                          )
                        ],
                      ),
                    ),

                    // Login button
                    InkWell(
                      onTap: () {
                        print('login');
                        //login();
                        _login();
                        // Navigator.pushReplacement(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => homepage()));
                      },
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        margin: const EdgeInsets.symmetric(horizontal: 25),
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(239, 165, 38, 1),
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
            )));
  }
}
