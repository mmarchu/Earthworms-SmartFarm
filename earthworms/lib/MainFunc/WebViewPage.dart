import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WebViewPage extends StatelessWidget {
  WebViewPage({super.key});
  @override
  Widget build(BuildContext context) {
    //final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(250, 246, 229, 1),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [],
              ),
            )),)
      ),
    );
  }
}
