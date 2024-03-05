import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttManager {
  late MqttServerClient client;

  MqttManager() {
    client = MqttServerClient('e076141ea6a943a5b775dae136735d83.s1.eu.hivemq.cloud', '');
    client.logging(on: true);
    client.keepAlivePeriod = 20;
    client.onDisconnected = onDisconnected;
    client.onConnected = onConnected;
  }

  Future<void> connect() async {
    try {
      await client.connect('march', 'Third0804151646');
      print('Connected to the broker');
      // Subscribe to topics or publish messages here if needed
    } catch (e) {
      print('Connection failed: $e');
    }
  }

  void onConnected() {
    print('Connected');
    // Subscribe to topics or publish messages here if needed
  }

  void onDisconnected() {
    print('Disconnected');
    // Handle reconnection or other logic here
  }

  void subscribeToTopic(String topic) {
    client.subscribe(topic, MqttQos.atLeastOnce);
  }

  void publishMessage(String topic, String message) {
    // final builder = MqttClientPayloadBuilder();
    // builder.addString(message);

    // client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload);
  }

  void disconnect() {
    client.disconnect();
  }
}
