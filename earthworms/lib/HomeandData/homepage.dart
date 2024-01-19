import 'package:earthworms/TestFunc/DropDown.dart';
import 'package:earthworms/HomeandData/Sensor2Page.dart';
import 'package:earthworms/MainFunction/LoginPage.dart';
import 'package:earthworms/MainFunction/ChangePassPage.dart';
import 'package:earthworms/HomeandData/Sensor1Page.dart';
import 'package:earthworms/HomeandData/statisPage.dart';
import 'package:earthworms/HomeandData/waterpumpPage.dart';
import 'package:earthworms/MainFunction/SessionToken.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class homepage extends StatelessWidget {
  final String email;
  final String name;
  final String lastname;

  homepage({required this.email, required this.name, required this.lastname});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
            key: _scaffoldKey,
            backgroundColor: Color.fromRGBO(250, 246, 229, 1),

            //navigation drawer
            drawer: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  DrawerHeader(
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(42, 62, 54, 1),
                      ),
                      child: UserAccountsDrawerHeader(
                        decoration: const BoxDecoration(
                            color: Color.fromRGBO(42, 62, 54, 1)),
                        // Name Header
                        accountName: Text(
                          name + " " + lastname,
                          style: TextStyle(
                            fontSize: 18 * textScaleFactor,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),

                        // Email Header
                        accountEmail: Text(
                          email,
                          style: TextStyle(
                            fontSize: 16 * textScaleFactor, 
                            color: Colors.white),
                        ),
                      )),
                  ListTile(
                    title: Text(
                      'Change password',
                      style: TextStyle(fontSize: 18 * textScaleFactor),
                    ),
                    onTap: () {
                      print('change password');
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChangePassPage(
                                  name: name, lastname: lastname)));
                    },
                  ),
                  ListTile(
                    title: Text(
                      'Log out',
                      style: TextStyle(fontSize: 18 * textScaleFactor),
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

                      // icon profile **** อาจจะไม่เอา ****
                      // IconButton(
                      //     onPressed: () {
                      //       print('Person');
                      //       Navigator.push(
                      //           context,
                      //           MaterialPageRoute(
                      //               builder: (context) => MyprofilePage()));
                      //     },
                      //     icon: Icon(Icons.person,
                      //         size: 35, color: Colors.grey[800])),
                    ],
                  ),
                ),
                const SizedBox(height: 15),

                // text Header
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 35 * textScaleFactor),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Welcome Back To",
                          style: TextStyle(
                            fontSize: 20 * textScaleFactor,
                            color: Colors.grey[800],
                          ), 
                        ),
                        SizedBox(
                          height: 10 * textScaleFactor,
                        ),
                        Text(
                          "The Earthworm's SmartFarm", //Name of user
                          style: TextStyle(
                              fontSize: 30 * textScaleFactor,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800]),
                        )
                      ],
                    )),
                const SizedBox(height: 15),

                // Function Button
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30 * textScaleFactor, vertical: 10 * textScaleFactor),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //Sensor 1
                      SizedBox(
                        width: 150 * textScaleFactor,
                        height: 200 * textScaleFactor,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(42, 62, 54, 1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(children: [
                            InkWell(
                              onTap: () {
                                print('Sensor1');
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Sensor1Page()));
                              },
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(height: 25 * textScaleFactor),
                                  Image.asset(
                                    "images/sensor-1-1.png",
                                    height: 100 * textScaleFactor,
                                    width: 100 * textScaleFactor,
                                  ),
                                  SizedBox(height: 20 * textScaleFactor),
                                  Text(
                                    'Sensor1',
                                    style: TextStyle(
                                      fontSize: 20 * textScaleFactor,
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
                        width: 150 * textScaleFactor,
                        height: 200 * textScaleFactor,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(42, 62, 54, 1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(children: [
                            InkWell(
                              onTap: () {
                                print('Sensor2');
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Sensor2Page()));
                              },
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    height: 25 * textScaleFactor,
                                  ),
                                  Image.asset(
                                    "images/sensor-1-1.png",
                                    height: 100 * textScaleFactor,
                                    width: 100 * textScaleFactor,
                                  ),
                                  SizedBox(
                                    height: 20 * textScaleFactor,
                                  ),
                                  Text(
                                    'Sensor2',
                                    style: TextStyle(
                                      fontSize: 20 * textScaleFactor,
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
                  padding: EdgeInsets.symmetric(horizontal: 30 * textScaleFactor, vertical: 10 * textScaleFactor),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //Water Pump
                      SizedBox(
                        width: 150 * textScaleFactor,
                        height: 200 * textScaleFactor,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(42, 62, 54, 1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(children: [
                            InkWell(
                              onTap: () {
                                print('Water Pump');
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SessionToken()));
                              },
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    height: 25 * textScaleFactor,
                                  ),
                                  Image.asset(
                                    "images/water-pump-1.png",
                                    width: 100 * textScaleFactor,
                                    height: 100 * textScaleFactor,
                                  ),
                                  SizedBox(
                                    height: 20 * textScaleFactor,
                                  ),
                                  Text(
                                    'Water Pump',
                                    style: TextStyle(
                                      fontSize: 20 * textScaleFactor,
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
                        width: 150 * textScaleFactor,
                        height: 200 * textScaleFactor,
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
                                          builder: (context) => statisPage()));
                                },
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      height: 20 * textScaleFactor,
                                    ),
                                    Image.asset(
                                      "images/StatsIcons.png",
                                      height: 100 * textScaleFactor,
                                      width: 100 * textScaleFactor,
                                    ),
                                    SizedBox(
                                      height: 15 * textScaleFactor,
                                    ),
                                    Text(
                                      'Summary',
                                      style: TextStyle(
                                          fontSize: 20 * textScaleFactor,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                    Text(
                                      'Report',
                                      style: TextStyle(
                                          fontSize: 20 * textScaleFactor,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
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
    });
  }
}
