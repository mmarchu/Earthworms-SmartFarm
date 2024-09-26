import 'package:flutter/material.dart';

class testtest extends StatefulWidget {
  const testtest({super.key});

  @override
  State<testtest> createState() => _testtestState();
}

class _testtestState extends State<testtest> {
  List<String> AAAA = ["A", "B", "C", "D"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("testtest"),
          backgroundColor: Colors.amberAccent,
        ),
        body: ListView.builder(
            itemCount: AAAA.length,
            itemBuilder: (context, Index) {
              return Column(
                children: [
                  SizedBox(
                    child: Text("data"),
                  )
                ],
              );
            }));
  }
}
