import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  //text editing controller
  var nameController = TextEditingController();
  var lastnameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  // Future register() async {
  //   var URL = 'http://http://127.0.0.1:3306/testDatabase/insert.php';
  //   final Uri url = Uri.parse(URL);
  //   var myReq = {};
  //   myReq['surename'] = nameController;
  //   myReq['lastname'] = lastnameController;
  //   myReq['email'] = emailController;
  //   myReq['password'] = passwordController;
  //   String jsonReq = jsonEncode(myReq);
  //   var response = await http.post(url,
  //       body: jsonReq,
  //       headers: {HttpHeaders.contentTypeHeader: 'application/json'});
  //   if (response.statusCode == 200) {
  //     var msg = jsonDecode(response.body);
  //     print(msg);
  //     if (msg["status"] == "Success") {
  //       print('Register success');
  //       //Navigator.pop(context);
  //     } else {
  //       print('Format Error');
  //     }
  //   } else {
  //     print('Error');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
        backgroundColor: const Color(0xff675D50),
      ),
      backgroundColor: Color.fromRGBO(214, 232, 219, 1),
      body: SafeArea(
          child: Center(
        child: Column(children: [
          const SizedBox(height: 40),

          // Name
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: TextFormField(
              controller: nameController,
              obscureText: false,
              decoration: const InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffC1D0B5))),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                fillColor: Color(0xffC1D0B5),
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
              decoration: const InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffC1D0B5))),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                fillColor: Color(0xffC1D0B5),
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
              decoration: const InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffC1D0B5))),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                fillColor: Color(0xffC1D0B5),
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
              decoration: const InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffC1D0B5))),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                fillColor: Color(0xffC1D0B5),
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
              //register();
            },
            child: Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.symmetric(horizontal: 25),
              decoration: BoxDecoration(
                color: const Color(0xffA9907E),
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
    );
  }
}
