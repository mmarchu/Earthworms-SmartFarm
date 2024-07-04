import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:earthworms/HomeandData/homepage.dart';
import 'package:earthworms/MainFunction/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddSensorPage extends StatefulWidget {
  final String name;
  final String lastname;
  final String email;
  AddSensorPage(
      {required this.name, required this.lastname, required this.email, t});

  @override
  State<AddSensorPage> createState() => _AddSensorPageState();
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

//Func. Logout
void _logout() async {
  await removeData('Token');
  await removeData('email');
  print("Log out");
}

class _AddSensorPageState extends State<AddSensorPage> with WidgetsBindingObserver {
  TextEditingController NameSensor = TextEditingController();
  final ValueNotifier<bool> _isButtonEnabled = ValueNotifier<bool>(false);
  final StreamController<List<Map<String, String>>> _streamController =
      StreamController();
  //List<String> sensorData = [];
  List<String> GPIO_Port = ['1', '2', '3', '4', '5'];
  String SelectGPIO = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      DialogScanSenser(context);
    });
    NameSensor.addListener(_handleTextFieldChange);
    SensorsListAPI();
    //_TokenChenkTimeout();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    // Remove observer when the state is disposed
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      print("Paused");
    }
    if (state == AppLifecycleState.resumed) {
      CheckToken();
    }
  }

  // void _TokenChenkTimeout() {
  //   Timer.periodic(Duration(minutes: 1), (timer) {
  //     CheckToken();
  //   });
  // }

  Future<void> CheckToken() async {
    String? token = await loadData('Token');
    String? email = await loadData('email');
    var url;

    if (Platform.isAndroid) {
      //url = 'http://10.0.2.2:4000/api/auth/getoneuser';
      url = 'http://192.168.1.40:4000/api/auth/getoneuser';
    } else if (Platform.isIOS) {
      url = 'http://127.0.0.1:4000/api/auth/getoneuser';
      //IP HomeWifi
      //url = 'http://192.168.1.40:4000/api/auth/getoneuser';
    }

    final response = await http.post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charest=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'email': email}));

    if (response.statusCode == 401) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Session Timeout'),
            actions: <Widget>[
              Column(
                children: [
                  Text("Session expired. You will be redirected to Login page"),
                  TextButton(
                    child: Text(
                      'OK',
                      style: TextStyle(color: Color(0xff0e4f55)),
                    ),
                    onPressed: () {
                      _logout();
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                          (Route<dynamic> Route) => false);
                    },
                  ),
                ],
              ),
            ],
          );
        },
      );
    } else {
      print("ยังอยู่จ้าาOnAddSensorPage");
    }
  }

  // Lode data after add sensor before back to homepage
  Future<void> LodeDataToHomePage() async {
    String? token = await loadData('Token');
    String? email = await loadData('email');
    var url;

    if (Platform.isAndroid) {
      url = 'http://10.0.2.2:4000/api/auth/getoneuser';
      //url = 'http://192.168.1.40:4000/api/auth/getoneuser';
    } else if (Platform.isIOS) {
      url = 'http://127.0.0.1:4000/api/auth/getoneuser';
      //IP HomeWifi
      //url = 'http://192.168.1.40:4000/api/auth/getoneuser';
    }

    final response = await http.post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charest=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'email': email}));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      DBemail = data['email'];
      DBname = data['name'];
      DBlastname = data['lastname'];
      DBSensorsDynamic = data['sensors'];
      List<String> sensorIdList =
          DBSensorsDynamic.map((item) => item['sensor_id'].toString()).toList();
      List<String> macAddressList =
          DBSensorsDynamic.map((item) => item['mac_address'].toString())
              .toList();
      List<String> sensorNameList =
          DBSensorsDynamic.map((item) => item['sensor_name'].toString())
              .toList();

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => HomePage(
                    name: DBname,
                    lastname: DBlastname,
                    email: DBemail,
                    sensorIdList: sensorIdList,
                    macAddressList: macAddressList,
                    sensorNameList: sensorNameList,
                    GpioList: ['3'],
                    modeList: [false],
                  )),
          (Route<dynamic> Route) => false);
    }
    ;
  }

  // API receive sensor list
  Future<void> SensorsListAPI() async {
    final email = widget.email;
    String? token = await loadData('Token');
    var url;
    if (Platform.isAndroid) {
      //IP Localhost
      url = 'http://10.0.2.2:4000/api/sensor/create';
      //IP HomeWifi
      //url = 'http://192.168.1.40:4000/api/sensor/create';
    } else if (Platform.isIOS) {
      //IP Localhost
      url = 'http://127.0.0.1:4000/api/sensor/create';
      //IP HomeWifi
      //url = 'http://192.168.1.40:4000/api/sensor/create';
    }

    final response = await http.post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charesr=UTF-8',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode({'email': email, 'createSensor': 'false'}));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['data'] != null && data['data'] is List) {
        List<Map<String, String>> sensorList =
            List<Map<String, String>>.from(data['data'].map((item) => {
                  //'status': int.parse(item['status'].toString()),
                  'address': item['address'].toString(),
                  'name': item['name'].toString()
                }));
        print(sensorList);
        _streamController.add(sensorList);
      } else {
        //throw Exception('Data format is incorrect');
      }
      Navigator.pop(context);
    } else {
      Navigator.pop(context);
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Sensor not found'),
            actions: <Widget>[
              TextButton(
                child: Text(
                  'Try Again',
                  style: TextStyle(color: Color(0xff0e4f55)),
                ),
                onPressed: () {
                  // Navigator.pop(context);
                  // DialogScanSenser(context);
                  // SensorsListAPI();
                  LodeDataToHomePage();
                },
              ),
            ],
          );
        },
      );
    }
  }

  // API add sensor to board
  Future<void> _addSensor(String MacAdd, String NameSensor) async {
    final email = widget.email;
    final MacAddress = MacAdd;
    final SensorName = NameSensor;
    String? token = await loadData('Token');

    var url;
    if (Platform.isAndroid) {
      //IP Localhost
      url = 'http://10.0.2.2:4000/api/sensor/create';
      //IP HomeWifi
      //url = 'http://192.168.1.40:4000/api/sensor/create';
    } else if (Platform.isIOS) {
      //IP Localhost
      url = 'http://127.0.0.1:4000/api/sensor/create';
      //IP HomeWifi
      //url = 'http://192.168.1.40:4000/api/sensor/create';
    }

    final response = await http.post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charesr=UTF-8',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode({
          'createSensor': 'true',
          'user_id': email,
          'mac_address': MacAddress,
          'sensor_name': SensorName
        }));

    if (response.statusCode == 200) {
      var snackBar = SnackBar(content: Text("Sensor added"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      LodeDataToHomePage();
    } else if (response.statusCode == 402) {
      var snackBar = SnackBar(content: Text("Duplicate Sensor! Try again."));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.pop(context);
    } else {
      var snackBar = SnackBar(content: Text("Can not Connect! Try again."));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.pop(context);
    }
  }

  //เช็คว่ามีการใส่ชื่อไปหรือป่าว
  void _handleTextFieldChange() {
    final isFilled = NameSensor.text.isNotEmpty;
    _isButtonEnabled.value = isFilled;
  }

  // Dialog Scan Senor
  void DialogScanSenser(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        // chsend
        builder: (context) {
          return AlertDialog(
              title: Text("Scan Sensor"),
              content: Row(
                children: [
                  Text("Put the sensors near the board."),
                  Padding(
                    padding: const EdgeInsets.only(left: 7),
                    child: SizedBox(
                      width: 30,
                      height: 30,
                      child: LoadingAnimationWidget.halfTriangleDot(
                        color: Color(0xff0e4f55),
                        size: 40,
                      ),
                    ),
                  )
                ],
              ));
        });
  }

  //Dialog Add Sensor
  void _DialogNewNameSensor(String Name, String MacAdd) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Sensor name'),
          content: Container(
            height: 100,
            child: Column(
              children: [
                TextField(
                  controller: NameSensor,
                  decoration:
                      InputDecoration(hintText: "Enter your name of sensor"),
                ),
                // DropdownButton(
                //   items: [
                //     DropdownMenuItem(child: Text(GPIO_Port[index]))
                //   ],)
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'CANCEL',
                style: TextStyle(color: Color(0xff0e4f55)),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ValueListenableBuilder(
                valueListenable: _isButtonEnabled,
                builder: (context, isEnabled, child) {
                  return TextButton(
                      child: Text(
                        'CONNECT',
                        style: TextStyle(
                            color: isEnabled ? Color(0xff0e4f55) : Colors.grey),
                      ),
                      onPressed: isEnabled
                          ? () {
                              String NewNameSensor = NameSensor.text;
                              print("Name: $NewNameSensor");
                              print(widget.email);
                              print("Mac: $MacAdd");
                              //LodeDataToHomePage();
                              _addSensor(MacAdd, NewNameSensor);
                            }
                          : null);
                })
          ],
        );
      },
    );
  }

  //Conditions BottomBar
  Future<void> _OnTapBottomBar(int index) async {
    switch (index) {
      case 0:
        Navigator.pop(context);
        break;
      case 1:
        DialogScanSenser(context);
        SensorsListAPI();
        break;
      case 2:
        showCupertinoModalPopup<void>(
            context: context,
            builder: (BuildContext context) => CupertinoAlertDialog(
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
                          style: TextStyle(color: Colors.blue),
                        )),
                    CupertinoDialogAction(
                        onPressed: () {
                          _logout();
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()),
                              (Route<dynamic> Route) => false);
                        },
                        child: Text(
                          "Yes",
                          style: TextStyle(color: Colors.blue),
                        ))
                  ],
                ));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final smallestDimension =
        screenWidth < screenHeight ? screenWidth : screenHeight;
    final textScaleFactor = smallestDimension / 400;

    return LayoutBuilder(builder: (context, Constraints) {
      return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Scaffold(
          backgroundColor: Color.fromRGBO(250, 246, 229, 1),
          bottomNavigationBar: BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.refresh_outlined,
                  size: 29 * textScaleFactor,
                ),
                label: 'Refresh',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.logout_rounded),
                label: 'Logout',
              ),
            ],
            currentIndex: 1,
            selectedItemColor: Color.fromRGBO(232, 225, 198, 1),
            unselectedItemColor: Colors.white,
            backgroundColor: Color(0xff0e4f55),
            onTap: (index) {
              _OnTapBottomBar(index);
            },
          ),
          body: Stack(
            children: [
              Container(
                height: screenHeight,
                color: Color(0xff0e4f55),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 70 * textScaleFactor),
                      child: Text(
                        "Add Sensor",
                        style: TextStyle(
                            fontSize: 30 * textScaleFactor,
                            color: Color.fromRGBO(250, 246, 229, 1),
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ),
              Positioned(
                top: screenHeight * 0.15,
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
                    child: StreamBuilder<List<Map<String, String>>>(
                      stream: _streamController.stream,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return Center(child: Text('No data available'));
                        } else {
                          final sensorList = snapshot.data!;
                          return ListView.builder(
                            itemCount: sensorList.length,
                            itemBuilder: (context, index) {
                              final name = sensorList[index]['name'];
                              final Mac = sensorList[index]['address'];
                              return GestureDetector(
                                onTap: () async {
                                  _DialogNewNameSensor(
                                      sensorList[index]['name']!,
                                      sensorList[index]['address']!);
                                },
                                child: Column(
                                  children: [
                                    SizedBox(
                                      width: 360 * textScaleFactor,
                                      height: 100 * textScaleFactor,
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                            color: Color.fromRGBO(
                                                232, 225, 198, 1),
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: 30 * textScaleFactor),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 16 *
                                                            textScaleFactor),
                                                    child: Text(
                                                      name != null
                                                          ? name
                                                          : '{}',
                                                      style: TextStyle(
                                                          fontSize: 30 *
                                                              textScaleFactor,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  Text(
                                                    Mac != null ? Mac : '{}',
                                                    style: TextStyle(
                                                        fontSize: 15 *
                                                            textScaleFactor,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10 * textScaleFactor,
                                    )
                                  ],
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
