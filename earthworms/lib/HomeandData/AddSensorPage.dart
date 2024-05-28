import 'package:earthworms/MainFunction/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddSensorPage extends StatefulWidget {
  const AddSensorPage({super.key});

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
  print("Log out");
}

class _AddSensorPageState extends State<AddSensorPage> {
  List<String> ListSensor = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      DialogScanSenser(context);
    });
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
                      child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Color(0xff0e4f55))),
                    ),
                  )
                ],
              ));
        });
  }

  //Dialog Add Sensor
  // void DialodAddSensor(BuildContext context){
  //   showDialog(context: context, builder: builder)
  // }

  //Conditions BottomBar
  void _OnTapBottomBar(int index) {
    switch (index) {
      case 0:
        Navigator.pop(context);
        break;
      case 1:
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
                  Icons.add,
                  size: 29 * textScaleFactor,
                ),
                label: 'Add Sensor',
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
                                      onTap: () {
                                        print(index + 1);
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
