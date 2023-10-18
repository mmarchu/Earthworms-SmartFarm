import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ignore: must_be_immutable
class ChangePassPage extends StatelessWidget {
  TextEditingController CurrentP = TextEditingController();
  final String name;
  final String lastname;

  ChangePassPage({required this.name, required this.lastname});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Scaffold(
          backgroundColor: Color.fromRGBO(250, 246, 229, 1),
          appBar: AppBar(
            title: Column(
              children: [
                Text(
                  "Update Password",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Text(
                  name + " " + lastname,
                  style: TextStyle(fontSize: 15),
                )
              ],
            ),
            backgroundColor: Color(0xff0e4f55),
          ),
          body: SafeArea(
              child: Container(
            child: SingleChildScrollView(child: Row()),
          )),
        ));
  }
}
