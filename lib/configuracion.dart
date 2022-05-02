import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'main.dart';
import 'variables.dart' as vars;

class Configuracion extends StatefulWidget {
  const Configuracion({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<Configuracion> createState() => _Configuracion();
}

class _Configuracion extends State<Configuracion> {
  Color _iconColor = Colors.redAccent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuracion'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Column(
                  //mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    TextField(
                      decoration: InputDecoration(
                          hintText: 'Broker (IP:xxx.xxx.xxx.xxx)'),
                    ),
                    TextField(
                      decoration: InputDecoration(hintText: 'Topic'),
                    ),
                    TextField(
                      decoration: InputDecoration(hintText: 'Puerto (1883)'),
                    ),
                    TextField(
                      decoration: InputDecoration(hintText: 'Identificador'),
                    ),
                  ]),
            ),
            SizedBox(
              height: 40,
            ),
            // Boton de conexion/desconexion
            IconButton(
              iconSize: 72,
              icon: vars.estado
                  ? FaIcon((FontAwesomeIcons.link), color: _iconColor)
                  : FaIcon((FontAwesomeIcons.linkSlash), color: _iconColor),
              onPressed: () {
                if (!vars.estado) {
                  brokerSetup();
                } else {
                  vars.client!.disconnect();
                }
              },
            ),
            Text(
              vars.mensaje,
              textAlign: TextAlign.center,
            ),
            ElevatedButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const Control(title: 'Control')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<MqttServerClient> brokerSetup() async {
    vars.client = MqttServerClient.withPort(
        vars.broker, vars.clientIdentifier, vars.port);
    vars.client!.logging(on: true);
    vars.client!.onConnected = onConnected;
    vars.client!.onDisconnected = onDisconnected;
    vars.client!.onSubscribed = onSubscribed;
    vars.client!.onSubscribeFail = onSubscribeFail;
    vars.client!.pongCallback = pong;
    vars.client!.secure = false;

    /*
    final connMessage = MqttConnectMessage()
        //.authenticateAs(username, password)
        //.keepAliveFor(60)
        .startClean()
        .withWillQos(MqttQos.atLeastOnce)
        .withClientIdentifier(clientIdentifier);
    */

    try {
      await vars.client!.connect();
    } catch (e) {
      setState(() {
        vars.mensaje = 'ERROR DE CONNEXION';
      });
      print('Exception: $e');
    }
    return vars.client!;
  }

//actions
  void onConnected() {
    //print('Conectado');
    setState(() {
      vars.mensaje = 'CONECTADO';
      vars.estado = true;
      _iconColor = Colors.greenAccent;
    });
  }

  void onDisconnected() {
    print('disconnected');
    setState(() {
      vars.mensaje = 'DESCONECTADO';
      vars.estado = false;
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
