// import 'dart:convert';
// import 'dart:io';
// import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  //text editing controller
  var nameController = TextEditingController();
  var lastnameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return  AnnotatedRegion<SystemUiOverlayStyle>( 
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
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
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: TextFormField(
              controller: nameController,
              obscureText: false,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white
              ),
              decoration: const InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color.fromRGBO(42, 62, 54, 1))),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                fillColor: Color.fromRGBO(42, 62, 54, 1),
                filled: true,
                hintText: "Name",
                hintStyle:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 30),

          // Lastname
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: TextFormField(
              controller: lastnameController,
              obscureText: false,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white
              ),
              decoration: const InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color.fromRGBO(42, 62, 54, 1))),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                fillColor: Color.fromRGBO(42, 62, 54, 1),
                filled: true,
                hintText: "Lastname",
                hintStyle:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 30),

          // Email
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: TextFormField(
              controller: emailController,
              obscureText: false,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white
              ),
              decoration: const InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color.fromRGBO(42, 62, 54, 1))),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                fillColor: Color.fromRGBO(42, 62, 54, 1),
                filled: true,
                hintText: "Email",
                hintStyle:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 30),

          // Password
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: TextFormField(
              controller: passwordController,
              obscureText: true,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white
              ),
              decoration: const InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color.fromRGBO(42, 62, 54, 1))),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                fillColor: Color.fromRGBO(42, 62, 54, 1),
                filled: true,
                hintText: "Password",
                hintStyle:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 30),

          // Regis button
          InkWell(
            onTap: () {
              print('Register');
              var snackBar = SnackBar(content: Text(passwordController.text));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              //register();
            },
            child: Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.symmetric(horizontal: 25),
              decoration: BoxDecoration(
                color: Color.fromRGBO(239, 165, 38, 1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Center(
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
