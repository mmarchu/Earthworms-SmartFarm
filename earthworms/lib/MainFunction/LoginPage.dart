import 'dart:convert';
import 'package:earthworms/MainFunction/RegisterPage.dart';
import 'package:earthworms/HomeandData/homepage.dart';
import 'package:earthworms/NewHomePage/NewHomepage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:earthworms/mqtt/mqttmanage.dart';

// ignore: must_be_immutable
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

String DBname = '';
String DBlastname = '';
String DBtoken = '';

// Save the token
Future<void> saveData(String key, String value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(key, value);
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> _login() async {
    final InputEmail = emailController.text;
    final InputPassword = passwordController.text;

    final response =
        await http.post(Uri.parse('http://localhost:4000/api/auth/login'),
            headers: <String, String>{
              'Content-Type': 'application/json; charest=UTF-8',
              'Authorization': 'Bearer $DBtoken',
            },
            body: jsonEncode({'email': InputEmail, 'password': InputPassword}));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      DBname = data['name'];
      DBlastname = data['lastname'];
      DBtoken = data['token'];
      ConMqtt();
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                Newhomepage(email: InputEmail, name: DBname, lastname: DBlastname),
          ));
      await saveData('Token', DBtoken);
      print(DBtoken);
    } else {
      var snackBar = SnackBar(
          content: Text("Login Failed. Please check your Email and Password."));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, Constraints) {
      final screenWidth = MediaQuery.of(context).size.width;
      final screenHeight = MediaQuery.of(context).size.height;
      final smallestDimension =
          screenWidth < screenHeight ? screenWidth : screenHeight;
      final textScaleFactor = smallestDimension / 400;
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
                          height: 250 * textScaleFactor,
                          width: 250 * textScaleFactor),
                      const SizedBox(height: 10),

                      //Text
                      Text('Welcome back to our Farm!',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xff0e4f55),
                            fontSize: 16 * textScaleFactor,
                          )),
                      const SizedBox(height: 25),

                      //Email
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: TextFormField(
                          controller: emailController,
                          obscureText: false,
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
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
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
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
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
                              child: Text(
                                'Register',
                                style: TextStyle(
                                    color: Color.fromRGBO(17, 41, 34, 0.9),
                                    decoration: TextDecoration.underline,
                                    fontSize: 16 * textScaleFactor),
                              ),
                            )
                          ],
                        ),
                      ),

                      // Login button
                      InkWell(
                        onTap: () async {
                          print('login');
                          _login();
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
    });
  }
}
