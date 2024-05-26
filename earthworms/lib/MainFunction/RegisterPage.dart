import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Text editing controller
  TextEditingController nameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController ConfirmPassController = TextEditingController();

  Future<void> _regis() async {
    final InputName = nameController.text;
    final InputLastname = lastnameController.text;
    final InputEmail = emailController.text;
    final InputPassword = passwordController.text;
    final InputConfirmPass = ConfirmPassController.text;

    var url;
    if (Platform.isAndroid) {
      url = 'http://10.0.2.2:4000/api/auth/register';
    } else if (Platform.isIOS) {
      url = 'http://127.0.0.1:4000/api/auth/register';
    }

    final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charest=UTF-8'
        },
        body: jsonEncode({
          'name': InputName,
          'lastname': InputLastname,
          'email': InputEmail,
          'password': InputPassword,
          'confirmpassword': InputConfirmPass
        }));

    if (response.statusCode == 400) {
      var snackBar = SnackBar(content: Text("Already have this email."));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (InputName.isEmpty ||
        InputLastname.isEmpty ||
        InputEmail.isEmpty ||
        InputPassword.isEmpty ||
        InputConfirmPass.isEmpty) {
      var snackBar = SnackBar(content: Text("Please fill in complete information."));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (passwordController.text != ConfirmPassController.text) {
      var snackBar =
          SnackBar(content: Text("Those passwords didn't match. Try again."));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      var snackBar =
          SnackBar(content: Text("You account has been successfully created."));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.pop(context);
    }
    ;
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Scaffold(
            appBar: AppBar(
              title: const Text("Register",
              style: TextStyle(color: Color.fromRGBO(250, 246, 229, 1)),),
              backgroundColor: Color(0xff0e4f55),
            ),
            backgroundColor: Color.fromRGBO(250, 246, 229, 1),
            body: SafeArea(
              child: Container(
                  child: SingleChildScrollView(
                child: Column(children: [
                  const SizedBox(height: 40),

                  // Name
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    child: TextFormField(
                      controller: nameController,
                      obscureText: false,
                      textCapitalization: TextCapitalization.words,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromRGBO(42, 62, 54, 1))),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        fillColor: Color.fromRGBO(42, 62, 54, 1),
                        filled: true,
                        hintText: "Name",
                        hintStyle: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Lastname
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    child: TextFormField(
                      controller: lastnameController,
                      obscureText: false,
                      textCapitalization: TextCapitalization.words,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromRGBO(42, 62, 54, 1))),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        fillColor: Color.fromRGBO(42, 62, 54, 1),
                        filled: true,
                        hintText: "Lastname",
                        hintStyle: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Email
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    child: TextFormField(
                      controller: emailController,
                      obscureText: false,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromRGBO(42, 62, 54, 1))),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        fillColor: Color.fromRGBO(42, 62, 54, 1),
                        filled: true,
                        hintText: "Email",
                        hintStyle: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Password
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    child: TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromRGBO(42, 62, 54, 1))),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        fillColor: Color.fromRGBO(42, 62, 54, 1),
                        filled: true,
                        hintText: "Password",
                        hintStyle: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Confirm Password
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    child: TextFormField(
                      controller: ConfirmPassController,
                      obscureText: true,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromRGBO(42, 62, 54, 1))),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        fillColor: Color.fromRGBO(42, 62, 54, 1),
                        filled: true,
                        hintText: "Confirm Password",
                        hintStyle: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Regis button
                  InkWell(
                    onTap: () {
                      print("register");
                      _regis();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.symmetric(horizontal: 25),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(239, 165, 38, 1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                      ),
                    ),
                  )
                ]),
              )),
            )));
  }
}
