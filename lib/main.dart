import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
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
  Widget build(BuildContext context) {
    Color iconColor = Colors.red;
    return Scaffold(
      appBar: AppBar(
        title: const Text('MQTT Control 2'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            /* 
            // Contenedor donde se ven los mensajes del broker
            Container(
                width: 200,
                child: Text(
                  messageFromBroker,
                  textAlign: TextAlign.center,
                )),
                */
            SizedBox(
              height: 40,
            ),
            IconButton(
              iconSize: 72,
              icon: const FaIcon(FontAwesomeIcons.circleUp),
              color: Colors.black,
              onPressed: () {
                print('Arriba');
                //_publicaMensaje('Arriba');
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                IconButton(
                  iconSize: 72,
                  icon: const FaIcon(FontAwesomeIcons.circleLeft),
                  color: Colors.black,
                  onPressed: () {
                    print('Izquierda');
                  },
                ),
                IconButton(
                  iconSize: 72,
                  icon: FaIcon((FontAwesomeIcons.circlePlay), color: iconColor),
                  onPressed: () {
                    /*
                    mqtt.Broker().brokerSetup();
                    print('+++++++++++++++++++++++++++++++++++++++++++++++');
                    String mensaje =
                        mqtt.Broker().client!.connectionStatus.toString();
                    print(mensaje);
                    print('+++++++++++++++++++++++++++++++++++++++++++++++');
                    setState(() {
                      variables.iconColor = Colors.green;
                      messageFromBroker = 'con';
                      //variables.messageFromBroker = "Co";
                      //variables.messageFromBroker =
                      //cliente.connectionStatus.toString();
                    });
                    */
                  },
                ),
                IconButton(
                  iconSize: 72,
                  icon: const FaIcon(FontAwesomeIcons.circleRight),
                  color: Colors.black,
                  onPressed: () {
                    print('Derecha');
                    //_publicaMensaje('Derecha');
                  },
                ),
              ],
            ),
            IconButton(
              iconSize: 72,
              icon: const FaIcon(FontAwesomeIcons.circleDown),
              color: Colors.black,
              onPressed: () {
                print('Abajo');
                //_publicaMensaje('Abajo');
              },
            ),
          ],
        ),
      ),
    );
  }
}
