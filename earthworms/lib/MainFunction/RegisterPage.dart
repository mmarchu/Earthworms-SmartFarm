import 'dart:convert';
import 'dart:io';
import 'package:earthworms/HomeandData/Components/url.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';

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
  String? nameError;
  String? lastnameError;
  String? emailError;
  String? passwordError;
  String? ConfirmPasswordError;
  String SavePassword = '';
  bool ispasswordVisible = true;
  Future<void> _regis() async {
    final InputName = nameController.text;
    final InputLastname = lastnameController.text;
    final InputEmail = emailController.text;
    final InputPassword = passwordController.text;
    final InputConfirmPass = ConfirmPassController.text;

    var url;
    if (Platform.isAndroid) {
      url = ApiUrl.ANDregister;
    } else if (Platform.isIOS) {
      url = ApiUrl.IOSregister;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            width: 300,
            height: 100,
            child: Center(
              child: LoadingAnimationWidget.halfTriangleDot(
                color: Color(0xff0e4f55),
                size: 50,
              ),
            ),
          ),
        );
      },
    );

    try {
      final response = await http.post(Uri.parse(url),
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

      Navigator.pop(context);

      if (response.statusCode == 400) {
        var snackBar = SnackBar(content: Text("Already have this email."));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else if (InputName.isEmpty ||
          InputLastname.isEmpty ||
          InputEmail.isEmpty ||
          InputPassword.isEmpty ||
          InputConfirmPass.isEmpty) {
        var snackBar =
            SnackBar(content: Text("Please fill in complete information."));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else if (passwordController.text != ConfirmPassController.text) {
        var snackBar =
            SnackBar(content: Text("Those passwords didn't match. Try again."));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        var snackBar = SnackBar(
            content: Text("You account has been successfully created."));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.pop(context);
      }
    } catch (e) {
      print('Failed to connect to server: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_rounded,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                color: Colors.white, // สีของปุ่ม
              ),
              title: Text(
                "Register",
                style: TextStyle(
                    color: Color.fromRGBO(250, 246, 229, 1),
                    fontWeight: FontWeight.bold,
                    fontSize: 25),
              ),
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
                        errorText: nameError,
                      ),
                      onChanged: (value) {
                        setState(() {
                          if (value.isEmpty) {
                            nameError = "Name cannot be empty";
                          } else {
                            nameError = null;
                          }
                        });
                      },
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
                        errorText: lastnameError,
                      ),
                      onChanged: (value) {
                        setState(() {
                          if (value.isEmpty) {
                            lastnameError = "Lastname cannot be empty";
                          } else {
                            lastnameError = null;
                          }
                        });
                      },
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
                        errorText: emailError,
                      ),
                      onChanged: (value) {
                        // Validate email after user stops typing
                        setState(() {
                          if (EmailValidator.validate(value)) {
                            emailError = null; // Email is valid
                          } else {
                            emailError =
                                'Invalid email address'; // Show error message
                          }
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Password
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    child: TextFormField(
                      controller: passwordController,
                      obscureText: ispasswordVisible,
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
                        errorText: passwordError,
                      ),
                      onChanged: (value) {
                        setState(() {
                          if (value.length > 5) {
                            passwordError = null;
                          } else {
                            passwordError =
                                'Password must be at least 6 characters';
                          }
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Confirm Password
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    child: TextFormField(
                      controller: ConfirmPassController,
                      obscureText: ispasswordVisible,
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
                        errorText: ConfirmPasswordError,
                      ),
                      onChanged: (value) {
                        setState(() {
                          if (value == passwordController.text) {
                            ConfirmPasswordError = null;
                          } else {
                            ConfirmPasswordError = 'Password does not match';
                          }
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 20),
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
                            setState(() {
                              ispasswordVisible = !ispasswordVisible;
                            });
                          },
                          child: Text(
                            ispasswordVisible
                                ? 'Show Password'
                                : 'Hide Password',
                            style: TextStyle(
                                color: Color.fromRGBO(17, 41, 34, 0.698),
                                fontSize: 15),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Regis button
                  InkWell(
                    onTap: () {
                      print("register");
                      if (nameError == null &&
                          lastnameError == null &&
                          emailError == null &&
                          passwordError == null &&
                          ConfirmPasswordError == null) {
                        _regis();
                        print("regis success");
                      } else {
                        var snackBar = SnackBar(
                            content: Text('Please fill all the fields'));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
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
