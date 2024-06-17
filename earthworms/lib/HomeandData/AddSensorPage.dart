import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:earthworms/HomeandData/homepage.dart';
import 'package:earthworms/MainFunction/LoginPage.dart';
import 'package:earthworms/mqtt/mqttmanage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mqtt_client/mqtt_client.dart';
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

//Func. Logout
void _logout() async {
  await removeData('Token');
  await removeData('email');
  print("Log out");
}

//Load data from sharePref
Future<String?> loadData(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(key);
}

class _AddSensorPageState extends State<AddSensorPage> {
  TextEditingController NameSensor = TextEditingController();
  final ValueNotifier<bool> _isButtonEnabled = ValueNotifier<bool>(false);
  final StreamController<String> messageController =
      StreamController<String>.broadcast();
  List<String> ListSensor = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'];
  List<String> ListMacAdd = [
    'aaaaa',
    'bbbbb',
    'ccccc',
    'ddddd',
    'eeeee',
    'fffff',
    'ggggg',
    'hhhhh'
  ];
  List<String> sensorData = [];

  // Lode data after add sensor before back to homepage
  Future<void> LodeDataToHomePage() async {
    String? token = await loadData('Token');
    String? email = await loadData('email');
    var url;

    if (Platform.isAndroid) {
      //url = 'http://10.0.2.2:4000/api/auth/getoneuser';
      url = 'http://192.168.1.40:4000/api/auth/getoneuser';
    } else if (Platform.isIOS) {
      url = 'http://127.0.0.1:4000/api/auth/getoneuser';
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
                  )),
          (Route<dynamic> Route) => false);
    }
    ;
  }

  @override
  void initState() {
    messageController.stream.listen((data) {
      setState(() {
        sensorData.add(data);
      });
    });
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      DialogScanSenser(context);
    });
    NameSensor.addListener(_handleTextFieldChange);
  }

  Future<void> _addSensor(String MacAdd, String NameSensor) async {
    final email = widget.email;
    final MacAddress = MacAdd;
    final SensorName = NameSensor;

    final response = await http.post(
        Uri.parse("http://127.0.0.1:4000/api/auth/register"),
        headers: <String, String>{
          'Content-Type': 'application/json; charesr=UTF-8'
        },
        body: jsonEncode(
            {'email': email, 'MacAdd': MacAddress, 'SensorName': SensorName}));

    if (response.statusCode == 200) {
      var snackBar = SnackBar(content: Text("Sensor added"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      LodeDataToHomePage();
      // Navigator.pushAndRemoveUntil(
      //     context,
      //     MaterialPageRoute(
      //         builder: (context) => HomePage(
      //               name: widget.name,
      //               lastname: widget.lastname,
      //               email: widget.email,
      //             )),
      //     (Route<dynamic> Route) => false);
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
        builder: (context) {
          Future.delayed(Duration(seconds: 5), () {
            Navigator.pop(context);
          });
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

  //Public "true" for scan sensor
  void _publishMQTT(String email) {
    final builder = MqttClientPayloadBuilder();
    builder.addString('true,$email');
    const topic = 'scan_sensor';
    client.publishMessage(topic, MqttQos.exactlyOnce, builder.payload!);
  }

  //Dialog Add Sensor
  void _DialogNewNameSensor(String Name, String MacAdd) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Information'),
          content: TextField(
            controller: NameSensor,
            decoration: InputDecoration(hintText: "Enter your name of sensor"),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ValueListenableBuilder(
                valueListenable: _isButtonEnabled,
                builder: (context, isEnabled, child) {
                  return TextButton(
                      child: Text('OK'),
                      onPressed: isEnabled
                          ? () {
                              String NewNameSensor = NameSensor.text;
                              print("Name: $NewNameSensor");
                              print(widget.email);
                              print("Mac: $MacAdd");
                              LodeDataToHomePage();
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
        _publishMQTT(widget.email);
        DialogScanSenser(context);
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
    return LayoutBuilder(builder: (context, Constraints) {
      final screenWidth = MediaQuery.of(context).size.width;
      final screenHeight = MediaQuery.of(context).size.height;
      final smallestDimension =
          screenWidth < screenHeight ? screenWidth : screenHeight;
      final textScaleFactor = smallestDimension / 400;
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
            onTap: _OnTapBottomBar,
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
                    child: Column(
                      children: [
                        Expanded(
                            child: ListView.builder(
                                itemCount: ListSensor.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                      onTap: () async {
                                        _DialogNewNameSensor(ListSensor[index],
                                            ListMacAdd[index]);
                                      },
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            width: 360 * textScaleFactor,
                                            height: 80 * textScaleFactor,
                                            child: DecoratedBox(
                                              decoration: BoxDecoration(
                                                  color: Color.fromRGBO(
                                                      232, 225, 198, 1),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 30 *
                                                            textScaleFactor),
                                                    child: Text(
                                                      ListSensor[index],
                                                      style: TextStyle(
                                                          fontSize: 20 *
                                                              textScaleFactor,
                                                          fontWeight:
                                                              FontWeight.bold),
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
                                      ));
                                }))
                      ],
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
