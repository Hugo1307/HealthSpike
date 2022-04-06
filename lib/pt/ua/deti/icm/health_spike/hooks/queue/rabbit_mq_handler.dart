import 'package:dart_amqp/dart_amqp.dart';

class RabbitMQHandler {
  final String address;
  final int port;
  final String user;
  final String password;

  Client? client;
  Channel? channel;

  RabbitMQHandler(this.address, this.user, this.password, {this.port = 5672});

  Future<void> connect() async {
    ConnectionSettings settings = ConnectionSettings(
        host: address,
        authProvider: PlainAuthenticator(user, password),
        port: port);

    client = Client(settings: settings);
    channel = await client!.channel();
  }

  void publishMessage(String message) {
    channel?.queue('hs_heart_rate').then((queue) => queue.publish(message));
  }

  Future<Consumer>? consumeMessage() {
    return channel?.queue('hs_heart_rate').then((queue) => queue.consume());
  }

  void disconnect() {
    channel?.close();
    client?.close();
  }
}
