import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Sensor1Page extends StatelessWidget {
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
        backgroundColor: const Color.fromRGBO(250, 246, 229, 1),
        body: SafeArea(
          child: Container(
            child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back_ios_rounded,
                        size: 35,
                        color: Colors.grey[800],
                      ),
                    )
                  ],
                ),
              ),
              //SizedBox(height: 10 * textScaleFactor),
              
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: Container(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        //Humidity
                        SizedBox(
                          width: 350 * textScaleFactor,
                          height: 200 * textScaleFactor,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                            color: Color.fromRGBO(42, 62, 54, 190),
                            borderRadius: BorderRadius.circular(20)
                          ),
                          child: Column(children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                              child: InkWell(
                                child: Row(
                                  mainAxisAlignment: 
                                    MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(height: 25 * textScaleFactor,),
                                    Image.asset(
                                      "images/humidity.png",
                                      height: 50 * textScaleFactor,
                                      width: 50 * textScaleFactor,
                                    ),
                                    Text(
                                      "Hello world",
                                      style: TextStyle(
                                        fontSize: 30 
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ]),
                          ),
                        ),
                        SizedBox(height: 10 * textScaleFactor),

                        //Temperature
                        SizedBox(
                          width: 350 * textScaleFactor,
                          height: 200 * textScaleFactor,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                            color: Color.fromRGBO(42, 62, 54, 190),
                            borderRadius: BorderRadius.circular(20)
                          ),
                          ),
                        ),
                        SizedBox(height: 10 * textScaleFactor),

                        //Light
                        SizedBox(
                          width: 350 * textScaleFactor,
                          height: 200 * textScaleFactor,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                            color: Color.fromRGBO(42, 62, 54, 190),
                            borderRadius: BorderRadius.circular(20)
                          ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )

            ],
          ),
        ),
      ),
        ))
    );
    });
  }
}
