import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:earthworms/HomeandData/Components/url.dart';
import 'package:earthworms/HomeandData/homepage.dart';
import 'package:earthworms/MainFunction/LoginPage.dart';
import 'package:earthworms/mqtt/mqttmanage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:email_validator/email_validator.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class Profilepage extends StatefulWidget {
  final String id;
  final String name;
  final String lastname;
  final String email;
  Profilepage(
      {required this.id,
      required this.name,
      required this.lastname,
      required this.email,
      super.key});

  @override
  State<Profilepage> createState() => _ProfilepageState();
}

// Delete Token in SharePref
Future<void> removeData(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove(key);
}

//Load Token
Future<String?> loadData(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(key);
}

class _ProfilepageState extends State<Profilepage> {
  late String topic;
  late String email;
  late String notify;
  TextEditingController nameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmNewPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    email = widget.email;
    topic = '$email/flora';
    // notify = '$email/notify';
  }

// Unsubscribe mqtt topic
  void unsubscribe(String topic) {
    // String subTopicEnemiesNotify = 'Enemies/notify';
    client.unsubscribe(topic);
    // client.unsubscribe(notify);
    // client.unsubscribe(subTopicEnemiesNotify);
    print("UnSubscribe topic: $topic");
    // print("UnSubscribe topic: $notify");
    // print("UnSubscribe topic: $subTopicEnemiesNotify");
  }

//Func. Logout
  void _logout() async {
    await removeData('Token');
    await removeData('user_id');
    await removeData('email');
    unsubscribe(topic);
    print("Log out");
    String? token = await loadData('Token');
    String? user_id = await loadData('user_id');
    String? email = await loadData('email');
    print("SharePreference Token: $token");
    print("SharePreference user_id: $user_id");
    print("SharePreference email: $email");
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
        (Route<dynamic> Route) => false);
  }

//Func. back to homePage after change email or password
  Future<void> LodeDataToHomePage() async {
    String? token = await loadData('Token');
    String? idString = await loadData('user_id');
    int? user_id = int.tryParse(idString!);
    var url;

    if (Platform.isAndroid) {
      url = ApiUrl.ANDgetoneuser;
    } else if (Platform.isIOS) {
      url = ApiUrl.IOSgetoneuser;
    }

    try {
      final response = await http.post(Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charest=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({'user_id': user_id}));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        DBemail = data['email'];
        DBname = data['name'];
        DBlastname = data['lastname'];
        DBSensorsDynamic = data['sensors'];
        List<String> sensorIdList =
            DBSensorsDynamic.map((item) => item['id'].toString()).toList();
        List<String> macAddressList =
            DBSensorsDynamic.map((item) => item['macAddress'].toString())
                .toList();
        List<String> sensorNameList =
            DBSensorsDynamic.map((item) => item['name'].toString()).toList();
        List<String> GpioList =
            DBSensorsDynamic.map((item) => item['gpio'].toString()).toList();
        List<bool> modeList =
            DBSensorsDynamic.map((item) => item['mode'].toString() == '1')
                .toList();
        List<bool> powerList =
            DBSensorsDynamic.map((item) => item['power'].toString() == '1')
                .toList()
                .toList();
        client.unsubscribe(topic);
        client.unsubscribe(notify);
        print("UnSubscribe topic: $topic");
        print("UnSubscribe topic: $notify");
        ConMqtt(DBemail);
        Navigator.pushAndRemoveUntil(
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
                    )),
            (Route<dynamic> Route) => false);
      }
    } catch (e) {
      print('Failed to connect to server: $e');
    }
  }

//dialog Change Name
  void changeNameDialog() {
    String? nameError;
    ValueNotifier<bool> isButtonEnabled = ValueNotifier<bool>(false);

    void _resetvalues() {
      nameController.clear();
    }

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Change Name"),
            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return Container(
                width: 350,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: TextFormField(
                          controller: nameController,
                          textCapitalization: TextCapitalization.words,
                          decoration: InputDecoration(
                            hintText: "Enter your name",
                            errorText: nameError,
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xff0e4f55), width: 2),
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              if (nameController.text.isNotEmpty) {
                                nameError = null;
                                isButtonEnabled.value = true;
                              } else {
                                nameError = 'Please enter your name';
                                isButtonEnabled.value = false;
                              }
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _resetvalues();
                },
                child: Text(
                  'CANCEL',
                  style: TextStyle(color: Color(0xff0e4f55)),
                ),
              ),
              ValueListenableBuilder(
                  valueListenable: isButtonEnabled,
                  builder: (context, isEnabled, child) {
                    return TextButton(
                        child: Text(
                          'DONE',
                          style: TextStyle(
                              color:
                                  isEnabled ? Color(0xff0e4f55) : Colors.grey),
                        ),
                        onPressed: isEnabled
                            ? () {
                                print("Change name done");
                              }
                            : null);
                  })
            ],
          );
        });
  }

// //Api Change Name
//   Future<void> changeName() async {
//     String? token = await loadData('Token');
//     String? idString = await loadData('user_id');
//     int? user_id = int.tryParse(idString!);
//     var url;
//     final name = nameController.text;

//     if (Platform.isAndroid) {
//       url = ApiUrl.ANDchangeName;
//     } else if (Platform.isIOS) {
//       url = ApiUrl.IOSchangeName;
//     }

//dialog Change Name
  void changeLastnameDialog() {
    String? lastnameError;
    ValueNotifier<bool> isButtonEnabled = ValueNotifier<bool>(false);

    void _resetvalues() {
      lastnameController.clear();
    }

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Change Lastname"),
            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return Container(
                width: 350,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: TextFormField(
                          controller: lastnameController,
                          textCapitalization: TextCapitalization.words,
                          decoration: InputDecoration(
                            hintText: "Enter your lastname",
                            errorText: lastnameError,
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xff0e4f55), width: 2),
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              if (lastnameController.text.isNotEmpty) {
                                lastnameError = null;
                                isButtonEnabled.value = true;
                              } else {
                                lastnameError = 'Please enter your name';
                                isButtonEnabled.value = false;
                              }
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _resetvalues();
                },
                child: Text(
                  'CANCEL',
                  style: TextStyle(color: Color(0xff0e4f55)),
                ),
              ),
              ValueListenableBuilder(
                  valueListenable: isButtonEnabled,
                  builder: (context, isEnabled, child) {
                    return TextButton(
                        child: Text(
                          'DONE',
                          style: TextStyle(
                              color:
                                  isEnabled ? Color(0xff0e4f55) : Colors.grey),
                        ),
                        onPressed: isEnabled
                            ? () {
                                print("Change Lastname done");
                              }
                            : null);
                  })
            ],
          );
        });
  }

//Api Change Password
  Future<void> _changePassword() async {
    String? token = await loadData('Token');
    String? idString = await loadData('user_id');
    int? user_id = int.tryParse(idString!);
    final password = passwordController.text;
    final newPassword = newPasswordController.text;
    final confirmNewPassword = confirmNewPasswordController.text;
    var url;

    if (Platform.isAndroid) {
      url = ApiUrl.ANDchangePassword;
    } else if (Platform.isIOS) {
      url = ApiUrl.IOSchangePassword;
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
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({
            'user_id': user_id,
            'oldPassword': password,
            'newPassword': newPassword,
            'confirmPassword': confirmNewPassword
          }));

      Navigator.pop(context);

      if (response.statusCode == 200) {
        var snackBar = SnackBar(content: Text("Change password successfully."));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        _logout();
      } else {
        var snackBar = SnackBar(content: Text("please try again."));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.pop(context);
      }
    } catch (e) {
      print('Failed to connect to server: $e');
    }
  }

//dialog change password
  void changePasswordDialog() {
    String? passwordError;
    String? newPasswordError;
    String? confirmNewPasswordError;
    bool ispasswordVisible = true;
    ValueNotifier<bool> isButtonEnabled = ValueNotifier<bool>(false);
    void updateButtonState() {
      isButtonEnabled.value = passwordError == null &&
          newPasswordError == null &&
          confirmNewPasswordError == null &&
          passwordController.text.isNotEmpty &&
          newPasswordController.text.isNotEmpty &&
          confirmNewPasswordController.text.isNotEmpty;
    }

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Change Password"),
            content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Container(
                  width: 350,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // Old Password
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: TextFormField(
                            controller: passwordController,
                            obscureText: ispasswordVisible,
                            decoration: InputDecoration(
                              hintText: "Current password",
                              errorText: passwordError,
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xff0e4f55), width: 2),
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                passwordError = null;
                                updateButtonState();
                              });
                            },
                          ),
                        ),
                        const SizedBox(height: 15),

                        // New Password
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: TextFormField(
                            controller: newPasswordController,
                            obscureText: ispasswordVisible,
                            decoration: InputDecoration(
                              hintText: "New password",
                              errorText: newPasswordError,
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xff0e4f55), width: 2),
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                if (value.length < 6) {
                                  newPasswordError =
                                      'Password must be at least 6 characters';
                                } else {
                                  newPasswordError = null;
                                }
                                if (confirmNewPasswordController.text !=
                                    value) {
                                  confirmNewPasswordError =
                                      'Passwords do not match';
                                } else {
                                  confirmNewPasswordError = null;
                                }
                                updateButtonState();
                              });
                            },
                          ),
                        ),
                        const SizedBox(height: 15),

                        // Confirm New Password
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: TextFormField(
                            controller: confirmNewPasswordController,
                            obscureText: ispasswordVisible,
                            decoration: InputDecoration(
                              hintText: "Confirm password",
                              errorText: confirmNewPasswordError,
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xff0e4f55), width: 2),
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                if (value != newPasswordController.text) {
                                  confirmNewPasswordError =
                                      'Passwords do not match';
                                } else {
                                  confirmNewPasswordError = null;
                                }
                                updateButtonState();
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 5),
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
                      ],
                    ),
                  ),
                );
              },
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  passwordController.clear();
                  newPasswordController.clear();
                  confirmNewPasswordController.clear();
                },
                child: Text(
                  'CANCEL',
                  style: TextStyle(color: Color(0xff0e4f55)),
                ),
              ),
              ValueListenableBuilder<bool>(
                valueListenable: isButtonEnabled,
                builder: (context, isEnabled, child) {
                  return TextButton(
                    onPressed: isEnabled
                        ? () {
                            _changePassword();
                          }
                        : null,
                    child: Text(
                      'DONE',
                      style: TextStyle(
                          color: isEnabled ? Color(0xff0e4f55) : Colors.grey),
                    ),
                  );
                },
              ),
            ],
          );
        });
  }

//Api Change Email
  Future<void> _changeEmail() async {
    String? token = await loadData('Token');
    String? idString = await loadData('user_id');
    int? user_id = int.tryParse(idString!);
    var url;

    if (Platform.isAndroid) {
      url = ApiUrl.ANDchangeEmail;
    } else if (Platform.isIOS) {
      url = ApiUrl.IOSchangeEmail;
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
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({
            'user_id': user_id,
            'password': passwordController.text,
            'email': widget.email,
            'new_email': emailController.text
          }));

      Navigator.pop(context);
      if (response.statusCode == 200) {
        var snackBar = SnackBar(content: Text("Change email successfully."));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        LodeDataToHomePage();
      } else if (response.statusCode == 401) {
        var snackBar = SnackBar(content: Text("Password is incorrect."));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.pop(context);
        emailController.clear();
        passwordController.clear();
      } else {
        var snackBar = SnackBar(content: Text("Please try again."));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.pop(context);
        emailController.clear();
        passwordController.clear();
      }
    } catch (e) {}
  }

//dialog Change Email
  void changeEmailDialog() {
    String? passwordError;
    String? emailError;
    bool isPasswordVisible = true;
    ValueNotifier<bool> isButtonEnabled = ValueNotifier<bool>(false);

    void _resetvalues() {
      emailController.clear();
      passwordController.clear();
      isButtonEnabled.value = false;
    }

    void updateButtonState() {
      isButtonEnabled.value = passwordError == null &&
          passwordController.text.isNotEmpty &&
          emailError == null &&
          emailController.text.isNotEmpty;
    }

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Change Email"),
            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return Container(
                width: 350,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                            hintText: "New Email",
                            errorText: emailError,
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xff0e4f55), width: 2),
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              if (EmailValidator.validate(value)) {
                                emailError = null; // Email is valid
                              } else {
                                emailError =
                                    'Invalid email address'; // Show error message
                              }
                              updateButtonState();
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: TextFormField(
                          controller: passwordController,
                          obscureText: isPasswordVisible,
                          decoration: InputDecoration(
                            hintText: "Current password",
                            errorText: passwordError,
                            suffixIcon: IconButton(
                              icon: Icon(isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              onPressed: () {
                                setState(() {
                                  isPasswordVisible = !isPasswordVisible;
                                });
                              },
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xff0e4f55), width: 2),
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              if (value.length < 6) {
                                passwordError =
                                    'Password must be at least 6 characters';
                              } else {
                                passwordError = null;
                              }
                              updateButtonState();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _resetvalues();
                },
                child: Text(
                  'CANCEL',
                  style: TextStyle(color: Color(0xff0e4f55)),
                ),
              ),
              ValueListenableBuilder(
                  valueListenable: isButtonEnabled,
                  builder: (context, isEnabled, child) {
                    return TextButton(
                        child: Text(
                          'NEXT',
                          style: TextStyle(
                              color:
                                  isEnabled ? Color(0xff0e4f55) : Colors.grey),
                        ),
                        onPressed: isEnabled
                            ? () {
                                print("NEXT");
                                _changeEmail();
                              }
                            : null);
                  })
            ],
          );
        });
  }

//Api Delete Account
  Future<void> _deleteAccount() async {
    String? token = await loadData('Token');
    String? idString = await loadData('user_id');
    int? user_id = int.tryParse(idString!);
    final password = passwordController.text;
    var url;

    if (Platform.isAndroid) {
      url = ApiUrl.ANDdeleteAccount;
    } else if (Platform.isIOS) {
      url = ApiUrl.IOSdeleteAccount;
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
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({
            'user_id': user_id,
            'confirmPassword': password,
          }));

      Navigator.pop(context);

      if (response.statusCode == 200) {
        var snackBar = SnackBar(content: Text("Delete Account Successfully."));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        _logout();
      } else {
        var snackBar = SnackBar(content: Text("please try again."));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.pop(context);
      }
    } catch (e) {
      print('Failed to connect to server: $e');
    }
  }

//dialog Delete Account
  void DeleteAccountDialog() {
    String? passwordError;
    bool isPasswordVisible = true;
    final ValueNotifier<bool> _isButtonEnabled = ValueNotifier<bool>(false);

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Delete Account"),
            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return Container(
                width: 350,
                child: SingleChildScrollView(
                  child: Column(children: [
                    TextFormField(
                      controller: passwordController,
                      obscureText: isPasswordVisible,
                      decoration: InputDecoration(
                          hintText: "Password",
                          errorText: passwordError,
                          suffixIcon: IconButton(
                            icon: Icon(isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                isPasswordVisible = !isPasswordVisible;
                              });
                            },
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Color(0xff0e4f55), width: 2),
                          )),
                      onChanged: (value) {
                        setState(() {
                          if (value.length < 6) {
                            passwordError =
                                'Password must be at least 6 characters';
                          } else {
                            passwordError = null;
                          }
                          _isButtonEnabled.value = passwordError == null;
                        });
                      },
                    )
                  ]),
                ),
              );
            }),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  passwordController.clear();
                },
                child: Text(
                  'CANCEL',
                  style: TextStyle(color: Color(0xff0e4f55)),
                ),
              ),
              ValueListenableBuilder<bool>(
                valueListenable: _isButtonEnabled,
                builder: (context, isEnabled, child) {
                  return TextButton(
                    onPressed: isEnabled
                        ? () {
                            showDialog<String>(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) => AlertDialog(
                                      title: Text(
                                        "Delete Account",
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                            onPressed: () => Navigator.pop(
                                                context, 'Cancel'),
                                            child: Text(
                                              "Cancel",
                                              style: TextStyle(
                                                color: Color(0xff0e4f55),
                                              ),
                                            )),
                                        TextButton(
                                            onPressed: () {
                                              _deleteAccount();
                                            },
                                            child: Text(
                                              "Delete",
                                              style: TextStyle(
                                                  color: Color(0xff0e4f55)),
                                            ))
                                      ],
                                    ));
                          }
                        : null,
                    child: Text(
                      'NEXT',
                      style: TextStyle(
                          color: isEnabled ? Color(0xff0e4f55) : Colors.grey),
                    ),
                  );
                },
              ),
            ],
          );
        });
  }

  void _openLineAPP() async {
    const url = "https://lin.ee/Uc51ZBq";
    final Uri uri = Uri.parse(url); // แป
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, Constraints) {
      final ScreenWidth = MediaQuery.of(context).size.width;
      final ScreenHeight = MediaQuery.of(context).size.height;
      final smallestDimension =
          ScreenWidth < ScreenHeight ? ScreenWidth : ScreenHeight;
      final TextScaleFacetor = smallestDimension / 400;
      return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: Scaffold(
            body: Container(
              child: SingleChildScrollView(
                child: Stack(
                  children: [
                    Container(
                      height: ScreenHeight,
                      color: Color(0xff0e4f55),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 70 * TextScaleFacetor,
                            left: 10 * TextScaleFacetor,
                            child: IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: Icon(
                                  Icons.arrow_back_ios_rounded,
                                  size: 35 * TextScaleFacetor,
                                  color: Color.fromRGBO(250, 246, 229, 1),
                                )),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                  top: 73 * TextScaleFacetor,
                                ),
                                child: Text(
                                  "Profile",
                                  style: TextStyle(
                                      color: Color.fromRGBO(250, 246, 229, 1),
                                      fontSize: 30 * TextScaleFacetor,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    Positioned(
                        top: ScreenHeight * 0.15,
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(27),
                            topRight: Radius.circular(27),
                          ),
                          child: Container(
                            color: Color.fromRGBO(250, 246, 229, 1),
                            child: Column(
                              children: [
                                SizedBox(height: 10 * TextScaleFacetor),
                                Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                        top: 5 * TextScaleFacetor,
                                        left: 40 * TextScaleFacetor,
                                        bottom: 2 * TextScaleFacetor,
                                      ),
                                      child: Text(
                                        "Name",
                                        style: TextStyle(
                                            fontSize: 15 * TextScaleFacetor,
                                            color: const Color.fromARGB(
                                                255, 51, 51, 51),
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: ScreenWidth - 50,
                                  height: 60 * TextScaleFacetor,
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                            color: Color(0xff0e4f55),
                                            width: 2)),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 10 * TextScaleFacetor),
                                          child: SizedBox(
                                            width: ScreenWidth - 120,
                                            height: 60 * TextScaleFacetor,
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    left:
                                                        30 * TextScaleFacetor),
                                                child: AutoSizeText(
                                                  widget.name,
                                                  style: TextStyle(
                                                    fontSize:
                                                        17 * TextScaleFacetor,
                                                    color: Colors.black,
                                                  ),
                                                  maxLines: 1,
                                                  textAlign: TextAlign.left,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            Icons.edit,
                                            color: Color(0xff0e4f55),
                                          ),
                                          onPressed: () {
                                            changeNameDialog();
                                            print("Edit Name");
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 5 * TextScaleFacetor),
                                Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                        top: 5 * TextScaleFacetor,
                                        left: 40 * TextScaleFacetor,
                                        bottom: 2 * TextScaleFacetor,
                                      ),
                                      child: Text(
                                        "Lastname",
                                        style: TextStyle(
                                            fontSize: 15 * TextScaleFacetor,
                                            color: const Color.fromARGB(
                                                255, 51, 51, 51),
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: ScreenWidth - 50,
                                  height: 60 * TextScaleFacetor,
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                            color: Color(0xff0e4f55),
                                            width: 2)),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 10 * TextScaleFacetor),
                                          child: SizedBox(
                                            width: ScreenWidth - 120,
                                            height: 60 * TextScaleFacetor,
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                  left: 30 * TextScaleFacetor,
                                                ),
                                                child: AutoSizeText(
                                                  widget.lastname,
                                                  style: TextStyle(
                                                    fontSize:
                                                        17 * TextScaleFacetor,
                                                    color: Colors.black,
                                                  ),
                                                  maxLines: 1,
                                                  textAlign: TextAlign.left,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            Icons.edit,
                                            color: Color(0xff0e4f55),
                                          ),
                                          onPressed: () {
                                            changeLastnameDialog();
                                            print("Edit lastname");
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 5 * TextScaleFacetor),
                                Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                        top: 5 * TextScaleFacetor,
                                        left: 40 * TextScaleFacetor,
                                        bottom: 2 * TextScaleFacetor,
                                      ),
                                      child: Text(
                                        "Email",
                                        style: TextStyle(
                                            fontSize: 15 * TextScaleFacetor,
                                            color: const Color.fromARGB(
                                                255, 51, 51, 51),
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: ScreenWidth - 50,
                                  height: 60 * TextScaleFacetor,
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                            color: Color(0xff0e4f55),
                                            width: 2)),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 10 * TextScaleFacetor),
                                          child: SizedBox(
                                            width: ScreenWidth - 120,
                                            height: 60 * TextScaleFacetor,
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                  left: 30 * TextScaleFacetor,
                                                ),
                                                child: AutoSizeText(
                                                  widget.email,
                                                  style: TextStyle(
                                                    fontSize:
                                                        17 * TextScaleFacetor,
                                                    color: Colors.black,
                                                  ),
                                                  maxLines: 1,
                                                  textAlign: TextAlign.left,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            Icons.edit,
                                            color: Color(0xff0e4f55),
                                          ),
                                          onPressed: () {
                                            changeEmailDialog();
                                            print("Edit Email");
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: 20 * TextScaleFacetor,
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      print("Line connection");
                                      _openLineAPP();
                                    },
                                    child: SizedBox(
                                      width: ScreenWidth - 50,
                                      height: 65 * TextScaleFacetor,
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                          color: Color.fromRGBO(74, 163, 97, 1),
                                          borderRadius:
                                              BorderRadius.circular(27),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  right: 10 * TextScaleFacetor),
                                              child: Image.asset(
                                                'images/line.png',
                                                width: 50 * TextScaleFacetor,
                                                height: 50 * TextScaleFacetor,
                                              ),
                                            ),
                                            Text(
                                              "Connect to Line Notification",
                                              style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      250, 246, 229, 1),
                                                  fontSize:
                                                      15 * TextScaleFacetor,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: 20 * TextScaleFacetor,
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      print("Change Password");
                                      changePasswordDialog();
                                    },
                                    child: SizedBox(
                                      width: ScreenWidth - 50,
                                      height: 65 * TextScaleFacetor,
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                          color:
                                              Color.fromRGBO(239, 165, 38, 1),
                                          borderRadius:
                                              BorderRadius.circular(27),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Change Password",
                                              style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      250, 246, 229, 1),
                                                  fontSize:
                                                      18 * TextScaleFacetor,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: 20 * TextScaleFacetor,
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      print("Logout");
                                      showCupertinoModalPopup<void>(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              CupertinoAlertDialog(
                                                title: Text('Are you sure?'),
                                                content: Text(
                                                    'Are you sure you want to logout of the application'),
                                                actions: <CupertinoDialogAction>[
                                                  CupertinoDialogAction(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text(
                                                        "No",
                                                        style: TextStyle(
                                                            color: Colors.blue),
                                                      )),
                                                  CupertinoDialogAction(
                                                      onPressed: () {
                                                        _logout();
                                                      },
                                                      child: Text(
                                                        "Yes",
                                                        style: TextStyle(
                                                            color: Colors.blue),
                                                      ))
                                                ],
                                              ));
                                    },
                                    child: SizedBox(
                                      width: ScreenWidth - 50,
                                      height: 65 * TextScaleFacetor,
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(27),
                                            border: Border.all(
                                              color: Color.fromARGB(
                                                  255, 143, 48, 48),
                                              width: 3,
                                            )),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Logout",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Color.fromARGB(
                                                    255, 143, 48, 48),
                                                fontSize: 18 * TextScaleFacetor,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        )),
                    Positioned(
                        right: 40 * TextScaleFacetor,
                        bottom: 30 * TextScaleFacetor,
                        child: FloatingActionButton(
                          onPressed: () {
                            DeleteAccountDialog();
                          },
                          child: Icon(
                            Icons.delete,
                            size: 30,
                            color: Colors.white,
                          ),
                          backgroundColor: Color.fromARGB(255, 143, 48, 48),
                        )),
                    // Positioned(
                    //     right: 35 * TextScaleFacetor,
                    //     top: 135 * TextScaleFacetor,
                    //     child: IconButton(
                    //         onPressed: () {
                    //           print("Edit Profile");
                    //         },
                    //         icon: Icon(
                    //           Icons.edit,
                    //           size: 25 * TextScaleFacetor,
                    //           color: Color(0xff0e4f55),
                    //         ))),
                  ],
                ),
              ),
            ),
          ));
    });
  }
}
