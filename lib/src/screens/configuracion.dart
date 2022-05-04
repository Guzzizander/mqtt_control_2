import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../main.dart';
import 'control.dart';
import '../variables.dart' as vars;

class Configuracion extends StatefulWidget {
  const Configuracion({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<Configuracion> createState() => _Configuracion();
}

class _Configuracion extends State<Configuracion> {
  Color _iconColor = Colors.redAccent;

  final tConfig = TextEditingController();
  final tBroker = TextEditingController();
  final tTopic = TextEditingController();
  final tPort = TextEditingController();
  final tIdentificador = TextEditingController();

  // Clean up the controller when the widget is disposed.
  void dispose() {
    tConfig.dispose();
    tBroker.dispose();
    tTopic.dispose();
    tPort.dispose();
    tIdentificador.dispose();
    super.dispose();
  }

  void cargaDatos() {
    tBroker.text = vars.broker;
    tTopic.text = vars.topic;
    tPort.text = vars.port.toString();
    tIdentificador.text = vars.clientIdentifier;
  }

  @override
  Widget build(BuildContext context) {
    // Carga los datos del fichero variables en los textfield
    cargaDatos();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuracion'),
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
                        ? FaIcon((FontAwesomeIcons.link), color: _iconColor)
                        : FaIcon((FontAwesomeIcons.linkSlash),
                            color: _iconColor),
                    onPressed: () {
                      if (!vars.estado) {
                        brokerSetup();
                      } else {
                        vars.client!.disconnect();
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
                  ]),
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
        //    vars.broker, vars.clientIdentifier, vars.port);
        tBroker.text,
        tIdentificador.text,
        int.parse(tPort.text));

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
    // Abre la pagina de Control
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const Control(title: 'Control')));
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
