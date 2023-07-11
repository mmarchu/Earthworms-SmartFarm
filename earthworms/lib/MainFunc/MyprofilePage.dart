import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyprofilePage extends StatelessWidget {
  const MyprofilePage({super.key});

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
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back_ios_rounded,
                      size: 35,
                      color: Colors.grey[800],
                    )),
              )
            ],
          )),
        ));
  }
}
