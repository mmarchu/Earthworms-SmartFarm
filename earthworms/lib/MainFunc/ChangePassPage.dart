import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChangePassPage extends StatelessWidget {
  const ChangePassPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Scaffold(
          appBar: AppBar(
            title: Column(
              children: [
                Text("Update Password",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20
                  ),),
                  Text("Demo Test",
                    style: TextStyle(
                      fontSize: 15
                    ),)
              ],
            ),
            backgroundColor: Color(0xff0e4f55),
          ),
          body: SafeArea(
            child: Container(
              child: SingleChildScrollView(
                child: Row(
                  children: [
                    Text("Current Password"),
                    // TextFormField(
                    //   obscureText: true,
                    //   style: TextStyle(
                    //     fontWeight: FontWeight.bold,
                    //     color: Colors.white
                    //   ),
                    //   decoration: InputDecoration(
                    //     enabledBorder: OutlineInputBorder(
                    //       borderSide: BorderSide(color: Color.fromRGBO(42, 62, 54, 1))),
                    //     focusedBorder: OutlineInputBorder(
                    //       borderSide: BorderSide(color: Colors.white)),
                    //       fillColor:Color.fromRGBO(42, 62, 54, 1),
                    //       filled: true,
                    //   ),
                    // )
                    ],
                )
              ),
            )),
        ));
  }
}
