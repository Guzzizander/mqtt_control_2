import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Control MQTT 2',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Control mqtt 2'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String topic = 'prueba';
  String broker = '192.168.0.133';
  int port = 1883;
  //String username = 'your_username';
  //String password = 'your_password';
  String clientIdentifier = 'GuzziZander';
  String mensaje = 'DESCONECTADO';
  bool estado = false;
  MqttServerClient? client;
  Color _iconColor = Colors.redAccent;
  double _currentSliderValue = 0;
  final builder = MqttClientPayloadBuilder();

  void _publicaMensaje(String mensaje) {
    builder.clear();
    builder.addString(mensaje);
    //client.publishMessage(topic, qosLevel, builder.payload);
    client!.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
  }

  Future<MqttServerClient> brokerSetup() async {
    client = MqttServerClient.withPort(broker, clientIdentifier, port);
    client!.logging(on: true);
    client!.onConnected = onConnected;
    client!.onDisconnected = onDisconnected;
    client!.onSubscribed = onSubscribed;
    client!.onSubscribeFail = onSubscribeFail;
    client!.pongCallback = pong;
    client!.secure = false;

    final connMessage = MqttConnectMessage()
        //.authenticateAs(username, password)
        //.keepAliveFor(60)
        .startClean()
        .withWillQos(MqttQos.atLeastOnce)
        .withClientIdentifier(clientIdentifier);
    try {
      await client!.connect();
    } catch (e) {
      setState(() {
        mensaje = 'ERROR DE CONNEXION';
      });
      print('Exception: $e');
    }
    return client!;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MQTT Control 2'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            // Contenedor donde se ven los mensajes del broker
            Container(
                width: 200,
                child: Text(
                  mensaje,
                  textAlign: TextAlign.center,
                )),
            SizedBox(
              height: 40,
            ),
            IconButton(
              iconSize: 72,
              icon: const FaIcon(FontAwesomeIcons.circleUp),
              color: Colors.black,
              onPressed: estado
                  ? () {
                      print('Arriba');
                      _publicaMensaje('Arriba');
                    }
                  : null,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                IconButton(
                  iconSize: 72,
                  icon: const FaIcon(FontAwesomeIcons.circleLeft),
                  color: Colors.black,
                  onPressed: estado
                      ? () {
                          print('Izquierda');
                          _publicaMensaje('Izquierda');
                        }
                      : null,
                ),
                // Boton de conexion/desconexion
                IconButton(
                  iconSize: 72,
                  icon:
                      FaIcon((FontAwesomeIcons.circlePlay), color: _iconColor),
                  onPressed: () {
                    if (!estado) {
                      brokerSetup();
                    } else {
                      client!.disconnect();
                    }
                  },
                ),
                IconButton(
                  iconSize: 72,
                  icon: const FaIcon(FontAwesomeIcons.circleRight),
                  color: Colors.black,
                  onPressed: estado
                      ? () {
                          print('Derecha');
                          _publicaMensaje('Derecha');
                        }
                      : null,
                ),
              ],
            ),
            IconButton(
              iconSize: 72,
              icon: const FaIcon(FontAwesomeIcons.circleDown),
              color: Colors.black,
              onPressed: estado
                  ? () {
                      print('Abajo');
                      _publicaMensaje('Abajo');
                    }
                  : null,
            ),
            Slider(
                value: _currentSliderValue,
                max: 100,
                divisions: 5,
                label: _currentSliderValue.round().toString(),
                onChanged: (double newValue) {
                  setState() {
                    _currentSliderValue = newValue;
                    _publicaMensaje(_currentSliderValue.toString());
                  }
                }),
          ],
        ),
      ),
    );
  }

//actions
  void onConnected() {
    print('connected***********');
    setState(() {
      mensaje = 'CONECTADO';
      estado = true;
      _iconColor = Colors.greenAccent;
    });
  }

  void onDisconnected() {
    print('disconnected');
    setState(() {
      mensaje = 'DESCONECTADO';
      estado = false;
      _iconColor = Colors.redAccent;
    });
  }

  void onSubscribed(String topic) {
    print('subscribed to $topic');
  }

  void onSubscribeFail(String topic) {
    print('failed to subscribe to $topic');
  }

  void on() {
    print('disconnected');
  }

  void pong() {
    print('ping response arrived');
  }
}
