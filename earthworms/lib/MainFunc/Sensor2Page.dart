import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Sensor2Page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(250, 246, 229, 1),
        body: SafeArea(
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
              //const SizedBox(height: 10),
              
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: Container(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        //Humidity
                        SizedBox(
                          width: 350,
                          height: 200,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                            color: Color.fromRGBO(42, 62, 54, 190),
                            borderRadius: BorderRadius.circular(20)
                          ),
                          ),
                        ),
                        SizedBox(height: 10),

                        //Temperature
                        SizedBox(
                          width: 350,
                          height: 200,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                            color: Color.fromRGBO(42, 62, 54, 190),
                            borderRadius: BorderRadius.circular(20)
                          ),
                          ),
                        ),
                        SizedBox(height: 10),

                        //Light
                        SizedBox(
                          width: 350,
                          height: 200,
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
    );
  }
}
