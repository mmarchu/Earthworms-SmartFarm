import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePageNo2 extends StatefulWidget {
  const HomePageNo2({super.key});

  @override
  State<HomePageNo2> createState() => _HomePageNo2State();
}

class _HomePageNo2State extends State<HomePageNo2> {
  @override
  Widget build(BuildContext context) {
    final currentWidtd = MediaQuery.of(context).size.width;
    final currentHeight = MediaQuery.of(context).size.height;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
              children: [
                Text(currentWidtd.toString()),
                Text(currentHeight.toString())
              ],)),
          
        ),
      ),
    );
  }
}
