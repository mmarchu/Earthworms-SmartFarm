import 'dart:async';
import 'dart:io';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:flutter/services.dart' show rootBundle;

final client = MqttServerClient(
    'e076141ea6a943a5b775dae136735d83.s1.eu.hivemq.cloud', '8883');

Future<int> ConMqtt(String email) async {
  client.port = 8883;
  client.logging(on: false);
  client.keepAlivePeriod = 60;
  client.onDisconnected = onDisconnected;
  client.onConnected = onConnected;
  client.onSubscribed = onSubscribed;
  client.pongCallback = pong;

  final context = SecurityContext.defaultContext;
  final clientAuthorities =
      await rootBundle.load('images/certificate-copy.pem');
  context.setClientAuthoritiesBytes(clientAuthorities.buffer.asUint8List());

  client.secure = true;
  client.securityContext = context;

  final connMess = MqttConnectMessage()
      .authenticateAs('march', 'Third0804151646')
      .withClientIdentifier('dart_client')
      .withWillTopic('flora_detail')
      .withWillMessage('My Will message')
      .startClean()
      .withWillQos(MqttQos.atLeastOnce);
  print('Client connecting....');
  client.connectionMessage = connMess;

  try {
    await client.connect();
  } on NoConnectionException catch (e) {
    print('Client exception: $e');
    client.disconnect();
  } on SocketException catch (e) {
    print('Socket exception: $e');
    client.disconnect();
  } catch (e) {
    client.disconnect();
    print('can not connect MQTT');
  }

  if (client.connectionStatus!.state == MqttConnectionState.connected) {
    print('Client connected');
  } else {
    print(
        'Client connection failed - disconnecting, status is ${client.connectionStatus}');
    client.disconnect();
    exit(-1);
  }

  // Subscribe Sensor Topic
  const subTopicSensor = 'flora_detail';
  print('Subscribing to $subTopicSensor topic');
  client.subscribe(subTopicSensor, MqttQos.atMostOnce);

  final subTopicEmailSensor = '$email/flora';
  print('Subscribing to $subTopicEmailSensor topic');
  client.subscribe(subTopicEmailSensor, MqttQos.atMostOnce);

  return 0;
}

/// The subscribed callback
void onSubscribed(String topic) {
  print('Subscription confirmed for topic $topic');
}

/// The unsolicited disconnect callback
void onDisconnected() {
  print('OnDisconnected client callback - Client disconnection');
  if (client.connectionStatus!.disconnectionOrigin ==
      MqttDisconnectionOrigin.solicited) {
    print('OnDisconnected callback is solicited, this is correct');
  }
  exit(-1);
}

/// The successful connect callback
void onConnected() {
  print('OnConnected client callback - Client connection was sucessful');
}

/// Pong callback
void pong() {
  print('Ping response client callback invoked');
}

void disconnect() {
  client.disconnect();
}
