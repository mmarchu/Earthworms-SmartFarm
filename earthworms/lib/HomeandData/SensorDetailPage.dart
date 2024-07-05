import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:earthworms/HomeandData/HtimeSeries.dart';
import 'package:earthworms/HomeandData/TemtimeSeries.dart';
import 'package:earthworms/HomeandData/homepage.dart';
import 'package:earthworms/MainFunction/LoginPage.dart';
import 'package:earthworms/mqtt/mqttmanage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/services.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class SensorDetailPage extends StatefulWidget {
  final String nameSensor;
  final String macAddress;
  final String email;
  final String sensorId;
  final String GpioList;
  final int index;
  bool mode;
  bool power;

  SensorDetailPage(
      {required this.nameSensor,
      required this.macAddress,
      required this.email,
      required this.sensorId,
      required this.GpioList,
      required this.index,
      required this.mode,
      required this.power});

  @override
  State<SensorDetailPage> createState() => _SensorDetailPageState();
}

//Delete Token in SharePref
Future<void> removeData(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove(key);
}

void _logout() async {
  await removeData('Token');
  await removeData('email');
  print("Log out");
}

class _SensorDetailPageState extends State<SensorDetailPage>
    with WidgetsBindingObserver {
  final BehaviorSubject<Map<String, List<String>>> _dataController =
      BehaviorSubject<Map<String, List<String>>>();
  late bool New_mode;
  late bool New_power;
  late String Mac_Address;

  @override
  void initState() {
    super.initState();
    _updateMQTT();
    New_mode = widget.mode;
    New_power = widget.power;
    Mac_Address = widget.macAddress;
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
      print("ยังอยู่จ้าาOnDetailPage");
    }
  }

  //Load data from sharePref
  Future<String?> loadData(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

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
                    GpioList: ["3", "2"],
                    modeList: [false, true],
                  )),
          (Route<dynamic> Route) => false);
    }
    ;
  }

  // Delete Sensor
  Future<void> DeleteSensor() async {
    String? token = await loadData('Token');

    var url;

    if (Platform.isAndroid) {
      //IP Localhost
      url = 'http://10.0.2.2:4000/api/sensor/create';
      //IP HomeWifi
      //url = 'http://192.168.1.40:4000/api/sensor/delete';
    } else if (Platform.isIOS) {
      url = 'http://127.0.0.1:4000/api/sensor/delete';
      //IP HomeWifi
      //url = 'http://192.168.1.40:4000/api/sensor/delete';
    }

    final response = await http.post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charest=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'sensor_id': widget.sensorId}));

    if (response.statusCode == 200) {
      var snackBar = SnackBar(content: Text("delete successful"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      LodeDataToHomePage();
    } else {
      var snackBar = SnackBar(content: Text("Can't Delete! Try again."));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.pop(context);
    }
  }

  //Get data from sensor by MQTT
  Future<void> _updateMQTT() async {
    Timer.periodic(Duration(seconds: 1), (timer) {
      client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
        final recMess = c![0].payload as MqttPublishMessage;
        final pt =
            MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
        print(pt);
        _MQTTtoJsonList(pt);
      });
    });
  }

  void _MQTTtoJsonList(String message) {
    final List<dynamic> parsedData = jsonDecode(message);
    List<String> macAddresses = [];
    List<String> temperatures = [];
    List<String> moisture = [];
    List<String> lights = [];
    List<String> conductivities = [];
    List<String> batteries = [];

    for (var item in parsedData) {
      macAddresses.add(item['macAddress'].toString());
      temperatures.add(item['temperature'].toString());
      moisture.add(item['moisture'].toString());
      lights.add(item['light'].toString());
      conductivities.add(item['conductivity'].toString());
      batteries.add(item['battery'].toString());
    }

    _dataController.add({
      'MacAddress': macAddresses,
      'Temperature': temperatures,
      'Moisture': moisture,
      'Light': lights,
      'Conductivity': conductivities,
      'Battery': batteries,
    });

    print(macAddresses);
    print(temperatures);
    print(moisture);
    print(lights);
    print(conductivities);
    print(batteries);
  }

  void _publishMQTT() {
    final builder = MqttClientPayloadBuilder();
    builder.addString('$Mac_Address,$New_mode,$New_power');
    //print('$M_A,$power');

    const topic = 'waterpump';
    client.publishMessage(topic, MqttQos.exactlyOnce, builder.payload!);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, Constraints) {
      final ScreenWidth = MediaQuery.of(context).size.width;
      final ScreenHeight = MediaQuery.of(context).size.height;
      final smallestDimension =
          ScreenWidth < ScreenHeight ? ScreenWidth : ScreenHeight;
      final textScaleFactor = smallestDimension / 400;
      return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Scaffold(
            backgroundColor: Color.fromRGBO(250, 246, 229, 1),
            body: Stack(
              children: [
                Container(
                  height: ScreenHeight,
                  color: Color(0xff0e4f55),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                          padding: EdgeInsets.only(top: 20 * textScaleFactor),
                          child: SizedBox(
                            width: ScreenWidth,
                            height: 140 * textScaleFactor,
                            child: Center(
                              child: AutoSizeText(
                                widget.nameSensor,
                                style: TextStyle(
                                  fontSize: 35 * textScaleFactor,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromRGBO(250, 246, 229, 1),
                                ),
                                maxLines: 2,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ))
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
                        topRight: Radius.circular(27)),
                    child: Container(
                      color: Color.fromRGBO(250, 246, 229, 1),
                      child: Column(
                        children: [
                          SizedBox(height: 25 * textScaleFactor),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20 * textScaleFactor,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                //Humidity
                                SizedBox(
                                  width: 175 * textScaleFactor,
                                  height: 140 * textScaleFactor,
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(232, 225, 198, 1),
                                      borderRadius: BorderRadius.circular(25),
                                      //boxShadow: [BoxShadow(blurRadius: 1)]
                                    ),
                                    child: InkWell(
                                      onTap: () async {
                                        print("Humidity");
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    HTimeSeriesPage()));
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                          top: 15 * textScaleFactor,
                                          left: 15 * textScaleFactor,
                                          right: 15 * textScaleFactor,
                                        ),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 8 * textScaleFactor),
                                                  child: Text(
                                                    "Humidity",
                                                    style: TextStyle(
                                                        fontSize: 19 *
                                                            textScaleFactor,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                Image.asset(
                                                  "images/humidity.png",
                                                  height: 40 * textScaleFactor,
                                                  width: 40 * textScaleFactor,
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      bottom:
                                                          20 * textScaleFactor,
                                                      top: 6 * textScaleFactor),
                                                  child: StreamBuilder<
                                                      Map<String,
                                                          List<String>>>(
                                                    stream:
                                                        _dataController.stream,
                                                    builder:
                                                        (context, snapshot) {
                                                      if (snapshot.hasData) {
                                                        List<String> humidity =
                                                            snapshot.data![
                                                                    'Moisture'] ??
                                                                [];
                                                        return Text(
                                                          '${humidity[widget.index].isNotEmpty ? humidity[widget.index] : "N/A"}%',
                                                          style: TextStyle(
                                                            fontSize: 40 *
                                                                textScaleFactor,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                          ),
                                                        );
                                                      } else {
                                                        return Text(
                                                          'N/A%',
                                                          style: TextStyle(
                                                              fontSize: 40 *
                                                                  textScaleFactor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal),
                                                        );
                                                      }
                                                    },
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                //Temperature
                                SizedBox(
                                  width: 175 * textScaleFactor,
                                  height: 140 * textScaleFactor,
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(232, 225, 198, 1),
                                      borderRadius: BorderRadius.circular(25),
                                      //boxShadow: [BoxShadow(blurRadius: 1)]
                                    ),
                                    child: InkWell(
                                      onTap: () async {
                                        print("temp");
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    TemtimeSeriesPage()));
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                          top: 15 * textScaleFactor,
                                          left: 15 * textScaleFactor,
                                          right: 15 * textScaleFactor,
                                        ),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 8 * textScaleFactor),
                                                  child: Text(
                                                    "Temperature",
                                                    style: TextStyle(
                                                        fontSize: 15 *
                                                            textScaleFactor,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                Image.asset(
                                                  "images/temperature-sensor.png",
                                                  height: 40 * textScaleFactor,
                                                  width: 40 * textScaleFactor,
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      bottom:
                                                          20 * textScaleFactor,
                                                      top: 6 * textScaleFactor),
                                                  child: StreamBuilder<
                                                      Map<String,
                                                          List<String>>>(
                                                    stream:
                                                        _dataController.stream,
                                                    builder:
                                                        (context, snapshot) {
                                                      if (snapshot.hasData) {
                                                        List<
                                                            String> temp = snapshot
                                                                    .data![
                                                                'Temperature'] ??
                                                            [];
                                                        return Text(
                                                          '${temp[widget.index].isNotEmpty ? temp[widget.index] : "N/A"}°C',
                                                          style: TextStyle(
                                                              fontSize: 40 *
                                                                  textScaleFactor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal),
                                                        );
                                                      } else {
                                                        return Text(
                                                          'N/A°C',
                                                          style: TextStyle(
                                                              fontSize: 40 *
                                                                  textScaleFactor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal),
                                                        );
                                                      }
                                                    },
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20 * textScaleFactor,
                          ),
                          // water pump
                          SizedBox(
                            width: 360 * textScaleFactor,
                            height: 140 * textScaleFactor,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(232, 225, 198, 1),
                                borderRadius: BorderRadius.circular(25),
                                //boxShadow: [BoxShadow(blurRadius: 1)]
                              ),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 10 * textScaleFactor),
                                    child: Image.asset(
                                      "images/water-pump.png",
                                      height: 100 * textScaleFactor,
                                      width: 100 * textScaleFactor,
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      // Switch auto/manual
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: 13 * textScaleFactor,
                                                top: 30 * textScaleFactor),
                                            child: Row(
                                              children: [
                                                Text(
                                                  "Manual/Auto",
                                                  style: TextStyle(
                                                    fontSize:
                                                        20 * textScaleFactor,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey[800],
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left:
                                                          27 * textScaleFactor),
                                                  child: CupertinoSwitch(
                                                    value: New_mode,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        New_mode = value;
                                                        if (value) {
                                                          New_power = false;
                                                        }
                                                      });
                                                      _publishMQTT();
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      //Switch On/Off
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                              left: 14 * textScaleFactor,
                                              bottom: 25 * textScaleFactor,
                                            ),
                                            child: Row(
                                              children: [
                                                Text(
                                                  "Power off/ON",
                                                  style: TextStyle(
                                                    fontSize:
                                                        20 * textScaleFactor,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey[800],
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left:
                                                          18 * textScaleFactor),
                                                  child: CupertinoSwitch(
                                                      value: New_power,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          if (New_mode ==
                                                              false) {
                                                            New_power = value;
                                                          }
                                                        });
                                                        _publishMQTT();
                                                      }),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 20 * textScaleFactor),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20 * textScaleFactor),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                //Battery
                                SizedBox(
                                  width: 175 * textScaleFactor,
                                  height: 100 * textScaleFactor,
                                  child: DecoratedBox(
                                      decoration: BoxDecoration(
                                          color:
                                              Color.fromRGBO(232, 225, 198, 1),
                                          borderRadius:
                                              BorderRadius.circular(25)),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: 8 * textScaleFactor),
                                            child: Image.asset(
                                              "images/full-battery.png",
                                              height: 35 * textScaleFactor,
                                              width: 37 * textScaleFactor,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                //bottom: 20 * textScaleFactor,
                                                top: 1 * textScaleFactor),
                                            child: StreamBuilder<
                                                Map<String, List<String>>>(
                                              stream: _dataController.stream,
                                              builder: (context, snapshot) {
                                                if (snapshot.hasData) {
                                                  List<String> battery =
                                                      snapshot.data![
                                                              'Battery'] ??
                                                          [];
                                                  return Text(
                                                    '${battery[widget.index].isNotEmpty ? battery[widget.index] : "N/A"}%',
                                                    style: TextStyle(
                                                      fontSize:
                                                          30 * textScaleFactor,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                    ),
                                                  );
                                                } else {
                                                  return Text(
                                                    'N/A%',
                                                    style: TextStyle(
                                                        fontSize: 30 *
                                                            textScaleFactor,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  );
                                                }
                                              },
                                            ),
                                          ),
                                        ],
                                      )),
                                ),
                                //GPIO Port
                                SizedBox(
                                  width: 175 * textScaleFactor,
                                  height: 100 * textScaleFactor,
                                  child: DecoratedBox(
                                      decoration: BoxDecoration(
                                          color:
                                              Color.fromRGBO(232, 225, 198, 1),
                                          borderRadius:
                                              BorderRadius.circular(25)),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: 12 * textScaleFactor),
                                            child: Text(
                                              "GPIO Port",
                                              style: TextStyle(
                                                  fontSize:
                                                      25 * textScaleFactor,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                //bottom: 20 * textScaleFactor,
                                                top: 1 * textScaleFactor),
                                            child: Text(
                                              widget.GpioList,
                                              style: TextStyle(
                                                  fontSize:
                                                      30 * textScaleFactor,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                          ),
                                        ],
                                      )),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                // Back Bottom
                Positioned(
                    left: 40 * textScaleFactor,
                    bottom: 30 * textScaleFactor,
                    child: FloatingActionButton(
                      onPressed: () {
                        LodeDataToHomePage();
                      },
                      heroTag: 'uniqueTag1',
                      child: Icon(
                        Icons.home,
                        size: 30,
                        color: Colors.white,
                      ),
                      backgroundColor: Color(0xff0e4f55),
                    )),
                // Delete sensor Bottom
                Positioned(
                    right: 40 * textScaleFactor,
                    bottom: 30 * textScaleFactor,
                    child: FloatingActionButton(
                      onPressed: () => showDialog<String>(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) => AlertDialog(
                                title: Text(
                                  "Delete this Device",
                                  style:
                                      TextStyle(fontSize: 20 * textScaleFactor),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, 'Cancel'),
                                      child: Text(
                                        "Cancel",
                                        style: TextStyle(
                                          color: Color(0xff0e4f55),
                                        ),
                                      )),
                                  TextButton(
                                      onPressed: () {
                                        DeleteSensor();
                                      },
                                      child: Text(
                                        "Delete",
                                        style:
                                            TextStyle(color: Color(0xff0e4f55)),
                                      ))
                                ],
                              )),
                      heroTag: 'uniqueTag2',
                      child: Icon(
                        Icons.delete,
                        size: 30,
                        color: Colors.white,
                      ),
                      backgroundColor: Color.fromARGB(255, 143, 48, 48),
                    )),
              ],
            )),
      );
    });
  }
}
