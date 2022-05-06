import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import '../variables.dart' as vars;

class Conexion extends StatefulWidget {
  const Conexion({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<Conexion> createState() => _Conexion();
}

class _Conexion extends State<Conexion> {
  @override
  void initState() {
    super.initState();
  }

  @override
  // Clean up the controller when the widget is disposed.
  void dispose() {
    tConfig.dispose();
    tBroker.dispose();
    tTopic.dispose();
    tPort.dispose();
    tIdentificador.dispose();
    super.dispose();
  }

  final tConfig = TextEditingController();
  final tBroker = TextEditingController();
  final tTopic = TextEditingController();
  final tPort = TextEditingController();
  final tIdentificador = TextEditingController();

  void cargaDatos() {
    tBroker.text = vars.broker;
    tTopic.text = vars.topic;
    tPort.text = vars.port.toString();
    tIdentificador.text = vars.clientIdentifier;
  }

  Future<String> get _localPath async {
    final directorio = await getApplicationDocumentsDirectory();
    return directorio.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/config.json');
  }

  @override
  Widget build(BuildContext context) {
    // Carga los datos del fichero variables en los textfield
    cargaDatos();
    return Scaffold(
      appBar: AppBar(
        title: const Text('MQTT Control'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            SizedBox(
              height: 110,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text(
                    vars.mensaje,
                    textAlign: TextAlign.center,
                  ),
                  // Boton de conexion/desconexion
                  IconButton(
                    iconSize: 72,
                    icon: vars.estado
                        ? FaIcon((FontAwesomeIcons.link), color: vars.iconColor)
                        : FaIcon((FontAwesomeIcons.linkSlash),
                            color: vars.iconColor),
                    onPressed: () {
                      if (!vars.estado) {
                        brokerSetup();
                      } else {
                        setState(() {
                          vars.mensaje = 'DESCONECTADO';
                          vars.estado = false;
                          vars.client!.disconnect();
                          vars.iconColor = Colors.redAccent;
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Column(
                  //mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    TextField(
                      controller: tConfig,
                      decoration:
                          InputDecoration(hintText: 'Nombre configuracion'),
                    ),
                    TextField(
                      controller: tBroker,
                      decoration: InputDecoration(
                          hintText: 'Broker (IP:xxx.xxx.xxx.xxx)'),
                    ),
                    TextField(
                      controller: tTopic,
                      decoration: InputDecoration(hintText: 'Topic'),
                    ),
                    TextField(
                      controller: tPort,
                      decoration: InputDecoration(hintText: 'Puerto (1883)'),
                    ),
                    TextField(
                      controller: tIdentificador,
                      decoration: InputDecoration(hintText: 'Identificador'),
                    ),
                    IconButton(
                      onPressed: () {
                        // Guardar la configuracion en el fichero
                        print('AÑADIDO');
                      },
                      icon: FaIcon(FontAwesomeIcons.circleCheck),
                      iconSize: 40,
                      color: Colors.blueAccent,
                    ),
                  ]),
            ),
          ],
        ),
      ),
    );
  }

  Future<MqttServerClient> brokerSetup() async {
    vars.client = MqttServerClient.withPort(
        tBroker.text, tIdentificador.text, int.parse(tPort.text));

    vars.client!.logging(on: true);
    vars.client!.onConnected = onConnected;
    vars.client!.onDisconnected = onDisconnected;
    vars.client!.onSubscribed = onSubscribed;
    vars.client!.onSubscribeFail = onSubscribeFail;
    vars.client!.pongCallback = pong;
    vars.client!.secure = false;

    vars.topic = tTopic.text;

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
      //print('Exception: $e');
    }
    return vars.client!;
  }

//actions
  void onConnected() {
    //print('Conectado');
    setState(() {
      vars.mensaje = 'CONECTADO';
      vars.estado = true;
      vars.iconColor = Colors.greenAccent;
    });
  }

  void onDisconnected() {
    //print('desconectado');
  }

  void onSubscribed(String topic) {
    //print('subscribed to $topic');
    /*
    // No estoy suscrito ya que no tengo que recibir mensajes
    setState(() {
      vars.mensaje = 'SUBSCRITO A ' + topic.toUpperCase();
    });
    */
  }

  void onSubscribeFail(String topic) {
    //print('failed to subscribe to $topic');
  }

  void on() {
    //print('disconnected');
  }

  void pong() {
    //print('ping response arrived');
  }
}
