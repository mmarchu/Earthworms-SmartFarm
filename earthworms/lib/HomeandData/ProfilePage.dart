import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Profilepage extends StatefulWidget {
  final String id;
  final String name;
  final String lastname;
  final String email;
  Profilepage(
      {required this.id,
      required this.name,
      required this.lastname,
      required this.email,
      super.key});

  @override
  State<Profilepage> createState() => _ProfilepageState();
}

class _ProfilepageState extends State<Profilepage> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, Constraints) {
      final ScreenWidth = MediaQuery.of(context).size.width;
      final ScreenHeight = MediaQuery.of(context).size.height;
      final smallestDimension =
          ScreenWidth < ScreenHeight ? ScreenWidth : ScreenHeight;
      final TextScaleFacetor = smallestDimension / 400;
      return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: Scaffold(
            //backgroundColor: Color.fromRGBO(250, 246, 229, 1),
            body: Container(
              child: SingleChildScrollView(
                child: Stack(
                  children: [
                    Container(
                      height: ScreenHeight,
                      color: Color(0xff0e4f55),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 70 * TextScaleFacetor,
                            left: 10 * TextScaleFacetor,
                            child: IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: Icon(
                                  Icons.arrow_back_ios_rounded,
                                  size: 35 * TextScaleFacetor,
                                  color: Color.fromRGBO(250, 246, 229, 1),
                                )),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                  top: 73 * TextScaleFacetor,
                                ),
                                child: Text(
                                  "Profile",
                                  style: TextStyle(
                                      color: Color.fromRGBO(250, 246, 229, 1),
                                      fontSize: 30 * TextScaleFacetor,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    Positioned(
                        top: ScreenHeight * 0.15,
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(27),
                            topRight: Radius.circular(27),
                          ),
                          child: Container(
                            color: Color.fromRGBO(250, 246, 229, 1),
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: 20 * TextScaleFacetor,
                                  ),
                                  child: SizedBox(
                                    width: ScreenWidth - 25,
                                    height: 60 * TextScaleFacetor,
                                    child: Center(
                                      child: AutoSizeText(
                                        widget.name,
                                        style: TextStyle(
                                            fontSize: 35 * TextScaleFacetor,
                                            fontWeight: FontWeight.bold),
                                        maxLines: 1,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: ScreenWidth - 25,
                                  height: 60 * TextScaleFacetor,
                                  child: Center(
                                    child: AutoSizeText(
                                      widget.lastname,
                                      style: TextStyle(
                                          fontSize: 35 * TextScaleFacetor,
                                          fontWeight: FontWeight.bold),
                                      maxLines: 1,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                        top: 5 * TextScaleFacetor,
                                        left: 40 * TextScaleFacetor,
                                        bottom: 2 * TextScaleFacetor,
                                      ),
                                      child: Text(
                                        "Email",
                                        style: TextStyle(
                                            fontSize: 15 * TextScaleFacetor,
                                            color: const Color.fromARGB(
                                                255, 51, 51, 51),
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: ScreenWidth - 50,
                                  height: 60 * TextScaleFacetor,
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                            color: Color(0xff0e4f55),
                                            width: 2)),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 10 * TextScaleFacetor),
                                          child: SizedBox(
                                            width: ScreenWidth - 120,
                                            height: 60 * TextScaleFacetor,
                                            child: Center(
                                              child: AutoSizeText(
                                                widget.email,
                                                style: TextStyle(
                                                  fontSize:
                                                      17 * TextScaleFacetor,
                                                  color: Colors.black,
                                                ),
                                                maxLines: 1,
                                                textAlign: TextAlign.left,
                                              ),
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            Icons.edit,
                                            color: Color(0xff0e4f55),
                                          ),
                                          onPressed: () {
                                            print("Edit Email");
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ))
                  ],
                ),
              ),
            ),
          ));
    });
  }
}
