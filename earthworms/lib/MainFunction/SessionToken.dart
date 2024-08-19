import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(90.0),
                        child: Image.asset(
                          "images/EarthwormIcon.png",
                          height: 250 * textScaleFactor,
                          width: 250 * textScaleFactor,
                        ),
                      ),
                      LoadingAnimationWidget.halfTriangleDot(
                        color: Color(0xff0e4f55),
                        size: 70,
                      ),
                    ],
                  ),
                ),
              )));
    });
  }
}
