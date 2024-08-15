import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SessionToken extends StatefulWidget {
  const SessionToken({super.key});

  @override
  State<SessionToken> createState() => _SessionTokenState();
}

class _SessionTokenState extends State<SessionToken> {
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
              backgroundColor: Color.fromRGBO(250, 246, 229, 1),
              body: SafeArea(
                child: Center(
                  child: Image.asset(
                    "images/EarthwormIcon.png",
                    height: 250 * textScaleFactor,
                    width: 250 * textScaleFactor,
                  ),
                ),
              )));
    });
  }
}
