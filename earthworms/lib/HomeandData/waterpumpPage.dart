import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:earthworms/mqtt/mqttmanage.dart';

class waterpumpPage extends StatefulWidget {
  @override
  State<waterpumpPage> createState() => _waterpumpPageState();
}

class _waterpumpPageState extends State<waterpumpPage> {
  //final bool PowerOn;
  bool M_A = true;
  bool power = false;

  @override
  void initState() {
    super.initState();
    _publishMQTT();
  }

  void _publishMQTT() {
    final builder = MqttClientPayloadBuilder();
    builder.addString('$M_A,$power');
    //print('$M_A,$power');

    const topic = 'waterpump';
    client.publishMessage(topic, MqttQos.atMostOnce, builder.payload!);
  }

  @override
  Widget build(BuildContext context) {
    //final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
          backgroundColor: const Color.fromRGBO(250, 246, 229, 1),
          body: SafeArea(
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
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
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 35),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Manual/Auto",
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),
                          CupertinoSwitch(
                            value: M_A,
                            onChanged: (value) {
                              setState(() {
                                M_A = value;
                                if (value) {
                                  power = false;
                                }
                              });
                              _publishMQTT();
                            },
                          )
                        ]),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Power off/ON",
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),
                          CupertinoSwitch(
                              value: power,
                              onChanged: (value) {
                                setState(() {
                                  if (!M_A) {
                                    power = value;
                                  }
                                });
                                _publishMQTT();
                              })
                        ]),
                  ),
                ],
              ),
            ]),
          )),
    );
  }
}
