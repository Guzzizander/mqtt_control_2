import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Carga los datos del fichero variables en los textfield
    // cargaDatos();
    return Scaffold(
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
                          vars.id = 0;
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<MqttServerClient> brokerSetup() async {
    vars.client = MqttServerClient.withPort(
        vars.broker, vars.identificador, int.parse(vars.port));

    vars.client!.logging(on: true);
    vars.client!.onConnected = onConnected;
    vars.client!.onDisconnected = onDisconnected;
    vars.client!.onSubscribed = onSubscribed;
    vars.client!.onSubscribeFail = onSubscribeFail;
    vars.client!.pongCallback = pong;
    vars.client!.secure = false;

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
    DefaultTabController.of(context)!.animateTo(2);
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
