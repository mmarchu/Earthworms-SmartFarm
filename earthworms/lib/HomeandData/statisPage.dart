import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class statisPage extends StatefulWidget {
  statisPage({super.key});

  @override
  State<statisPage> createState() => _statisPageState();
}

class _statisPageState extends State<statisPage> {
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
            backgroundColor: const Color.fromRGBO(250, 246, 229, 1),
            body: SafeArea(
              child: Container(
                  child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
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
                    ),
                    const SizedBox(height: 15),
                    
                    //Text Header
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 35 * textScaleFactor),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children:[
                          Text(
                            "Summary",
                            style: TextStyle(
                              fontSize: 40 * textScaleFactor,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 35 * textScaleFactor),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Report",
                            style: TextStyle(
                              fontSize: 40 * textScaleFactor,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            )
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10,),
                    
                    //Category
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30 * textScaleFactor, vertical: 10 * textScaleFactor),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [],
                      ),
                    )
                  ],
                ),
              )),
            )),
      );
    });
  }
}
