import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class statisPage extends StatelessWidget {
  statisPage({super.key});
  @override
  Widget build(BuildContext context) {
    //final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
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
                    padding: EdgeInsets.symmetric(horizontal: 25),
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
                            ))
                      ],
                    ),
                  )
                ],
              ),
            )),
          )),
    );
  }
}
