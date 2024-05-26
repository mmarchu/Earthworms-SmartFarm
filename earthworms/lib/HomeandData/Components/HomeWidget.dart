import 'package:flutter/material.dart';

class HomeWidget extends StatelessWidget {
  final String NumSensor;

  const HomeWidget({required this.NumSensor, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, Constraints) {
      final screenWidth = MediaQuery.of(context).size.width;
      final screenHeight = MediaQuery.of(context).size.height;
      final smallestDimension =
          screenWidth < screenHeight ? screenWidth : screenHeight;
      final textScaleFactor = smallestDimension / 400;
      return Column(
        children: [
          SizedBox(
            width: 360 * textScaleFactor,
            height: 190 * textScaleFactor,
            child: DecoratedBox(
              decoration: BoxDecoration(
                  color: Color.fromRGBO(232, 225, 198, 1),
                  borderRadius: BorderRadius.circular(27)),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      NumSensor,
                      style: TextStyle(
                          fontSize: 20 * textScaleFactor,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10 * textScaleFactor,
          )
        ],
      );
    });
  }
}
