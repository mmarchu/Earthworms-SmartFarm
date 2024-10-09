import 'dart:convert';
import 'dart:io';
import 'package:earthworms/HomeandData/Components/url.dart';
import 'package:earthworms/MainFunction/RegisterPage.dart';
import 'package:earthworms/HomeandData/homepage.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:earthworms/mqtt/mqttmanage.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

// ignore: must_be_immutable
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

String? emailError;
String? passwordError;
String id = '';
String DBname = '';
String DBlastname = '';
String DBtoken = '';
String DBemail = '';
List<dynamic> DBSensorsDynamic = [];

// Save the token
Future<void> saveData(String key, String value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(key, value);
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isPasswordVisible = true;

  Future<void> _login() async {
    final InputEmail = emailController.text;
    final InputPassword = passwordController.text;

    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter your email and password.'),
        ),
      );
      return;
    }

    var url;
    if (Platform.isAndroid) {
      url = ApiUrl.ANDlogin;
    } else if (Platform.isIOS) {
      url = ApiUrl.IOSlogin;
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
            'Content-Type': 'application/json; charest=UTF-8',
          },
          body: jsonEncode({'email': InputEmail, 'password': InputPassword}));

      Navigator.of(context).pop();

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        id = data['id'].toString();
        DBemail = data['email'];
        DBname = data['name'];
        DBlastname = data['lastname'];
        DBtoken = data['token'];
        DBSensorsDynamic = data['sensors'];

        // Extract sensor details into separate lists
        List<String> sensorIdList = [];
        List<String> macAddressList = [];
        List<String> sensorNameList = [];
        List<String> GpioList = [];
        List<bool> modeList = [];
        List<bool> powerList = [];

        // ignore: unnecessary_null_comparison, unnecessary_type_check
        if (DBSensorsDynamic != null && DBSensorsDynamic is List) {
          sensorIdList =
              DBSensorsDynamic.map((item) => item['id'].toString()).toList();
          macAddressList =
              DBSensorsDynamic.map((item) => item['macAddress'].toString())
                  .toList();
          sensorNameList =
              DBSensorsDynamic.map((item) => item['name'].toString()).toList();
          GpioList =
              DBSensorsDynamic.map((item) => item['gpio'].toString()).toList();
          modeList =
              DBSensorsDynamic.map((item) => item['mode'].toString() == '1')
                  .toList();
          powerList =
              DBSensorsDynamic.map((item) => item['power'].toString() == '1')
                  .toList();
        }
        print(sensorIdList);
        ConMqtt(DBemail);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(
                id: id,
                name: DBname,
                lastname: DBlastname,
                email: DBemail,
                sensorIdList: sensorIdList,
                macAddressList: macAddressList,
                sensorNameList: sensorNameList,
                GpioList: GpioList,
                modeList: modeList,
                powerList: powerList,
              ),
            ));
        await saveData('Token', DBtoken);
        await saveData('email', DBemail);
        await saveData('user_id', id);
        print("Token: " + DBtoken);
        print("Sensor List: $sensorIdList");
        print(sensorNameList);
        print(macAddressList);
        print(GpioList);
        print(modeList);
      } else {
        var snackBar = SnackBar(
            content:
                Text("Login Failed. Please check your Email and Password."));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (e) {
      print('Failed to connect to server: $e');
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
                          decoration: InputDecoration(
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromRGBO(17, 41, 34, 0.9)),
                            ),
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            fillColor: const Color.fromRGBO(42, 62, 54, 1),
                            filled: true,
                            hintText: 'Email',
                            hintStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                            errorText: emailError, // Display error message
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
                      const SizedBox(height: 10),

                      //Password
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: TextFormField(
                          controller: passwordController,
                          obscureText: _isPasswordVisible,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                          decoration: InputDecoration(
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

                      Padding(
                        padding: EdgeInsets.only(right: 20 * textScaleFactor),
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
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                              child: Text(
                                _isPasswordVisible
                                    ? 'Show Password'
                                    : 'Hide Password',
                                style: TextStyle(
                                    color: Color.fromRGBO(17, 41, 34, 0.698),
                                    fontSize: 15 * textScaleFactor),
                              ),
                            )
                          ],
                        ),
                      ),

                      // Login button
                      InkWell(
                        onTap: () async {
                          print('login');
                          //_login();
                          if (emailError == null && passwordError == null) {
                            _login();
                          } else {
                            var snackBar = SnackBar(
                                content: Text(
                                    'Please enter your email and password.'));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
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
                      SizedBox(height: 15 * textScaleFactor),

                      //Register Button
                      InkWell(
                        onTap: () async {
                          print('Register');
                          emailController.clear();
                          passwordController.clear();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegisterPage()));
                        },
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          margin: const EdgeInsets.symmetric(horizontal: 25),
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(250, 246, 229, 1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: Color.fromRGBO(239, 165, 38, 1),
                                  width: 2)),
                          child: const Center(
                            child: Text(
                              'Register',
                              style: TextStyle(
                                  color: Color.fromRGBO(239, 165, 38, 1),
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
