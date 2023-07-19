import 'package:earthworms/FirstP/LoginPage.dart';
import 'package:earthworms/MainFunc/ChangePassPage.dart';
import 'package:earthworms/MainFunc/MyprofilePage.dart';
import 'package:earthworms/MainFunc/WebViewPage.dart';
//import 'package:earthworms/MainFunc/WebViewPage.dart';
//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:url_launcher/url_launcher_string.dart';

class homepage extends StatelessWidget {
  homepage({super.key});

  final NameDD = 'Demo Test';
  final EmailDD = 'Demo@email.com';

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: const Color.fromRGBO(250, 246, 229, 1),

          //navigation drawer
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(239, 165, 38, 1),
                    ),
                    child: UserAccountsDrawerHeader(
                      decoration: const BoxDecoration(
                          color: Color.fromRGBO(239, 165, 38, 1)),
                      // Name Header
                      accountName: Text(
                        NameDD,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      // Email Header
                      accountEmail: Text(
                        EmailDD,
                        style: TextStyle(fontSize: 15, color: Colors.white),
                      ),
                    )),
                ListTile(
                  title: const Text(
                    'Change password',
                    style: TextStyle(fontSize: 18),
                  ),
                  onTap: () {
                    print('change password');
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChangePassPage()));
                    //Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Text(
                    'Log out',
                    style: TextStyle(fontSize: 18),
                  ),
                  onTap: () {
                    print("Log out");
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                ),
              ],
            ),
          ),

          body: SafeArea(
              child: Column(
            children: [
              //appBar
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // icon Menu
                    IconButton(
                        onPressed: () {
                          _scaffoldKey.currentState?.openDrawer();
                          print('Menu');
                        },
                        icon: Icon(
                          Icons.menu,
                          size: 35,
                          color: Colors.grey[800],
                        )),

                    // icon profile
                    IconButton(
                        onPressed: () {
                          print('Person');
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyprofilePage()));
                        },
                        icon: Icon(Icons.person,
                            size: 35, color: Colors.grey[800])),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              // text Header
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 35),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome Back To",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.grey[800],
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "The Earthworm's SmartFarm", //Name of user
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800]),
                      )
                    ],
                  )),
              const SizedBox(height: 10),

              // Function Button
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //Sensor 1
                    SizedBox(
                      width: 150,
                      height: 200,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(42, 62, 54, 1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(children: [
                          InkWell(
                            onTap: () {
                              print('Sensor1');
                              //other Function
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(height: 25),
                                Image.asset(
                                  "images/sensor-1-1.png",
                                  height: 100,
                                  width: 100,
                                ),
                                SizedBox(height: 20),
                                Text(
                                  'Sensor1',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ]),
                      ),
                    ),

                    //Sensor 2
                    SizedBox(
                      width: 150,
                      height: 200,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(42, 62, 54, 1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(children: [
                          InkWell(
                            onTap: () {
                              print('Sensor2');
                              //other Function
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  height: 25,
                                ),
                                Image.asset(
                                  "images/sensor-1-1.png",
                                  height: 100,
                                  width: 100,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  'Sensor2',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //Water Pump
                    SizedBox(
                      width: 150,
                      height: 200,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(42, 62, 54, 1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(children: [
                          InkWell(
                            onTap: () async {
                              print('Water Pump');
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  height: 25,
                                ),
                                Image.asset(
                                  "images/water-pump-1.png",
                                  width: 100,
                                  height: 100,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  'Water Pump',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ]),
                      ),
                    ),

                    //Stats Page
                    SizedBox(
                      width: 150,
                      height: 200,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(42, 62, 54, 1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            InkWell(
                              onTap: () {
                                print('Stats Web');
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => WebViewPage()));
                              },
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    height: 25,
                                  ),
                                  Image.asset(
                                    "images/StatsIcons.png",
                                    height: 100,
                                    width: 100,
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    'Statistics View',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          )),
        ));
  }
}
