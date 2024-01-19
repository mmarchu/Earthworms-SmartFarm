import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Sensor2PageNO2 extends StatelessWidget {
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

              Expanded(
                child: CustomScrollView(
                  slivers: [
                    SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                            child: Column(
                              children: [
                                SizedBox(
                                  width: 350,
                                  height: 200,
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(42, 62, 54, 150),
                                      borderRadius: BorderRadius.circular(20)
                                    )),
                                ),
                                SizedBox(height: 10),

                                SizedBox(
                                  width: 350,
                                  height: 200,
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(42, 62, 54, 150),
                                      borderRadius: BorderRadius.circular(20)
                                    )),
                                ),
                                SizedBox(height: 10),

                                SizedBox(
                                  width: 350,
                                  height: 200,
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(42, 62, 54, 150),
                                      borderRadius: BorderRadius.circular(20)
                                    )),
                                ),
                              ],
                            ),
                          )
                        ]))
                ],))
            ],
          )),
      ),
    );
  }
}
