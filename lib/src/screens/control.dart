import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../variables.dart' as vars;

class Control extends StatefulWidget {
  const Control({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<Control> createState() => _Control();
}

class _Control extends State<Control> {
  double _valorSlider = 0;
  final builder = MqttClientPayloadBuilder();

  void _publicaMensaje(String mensaje) {
    builder.clear();
    builder.addString(mensaje);
    vars.client!
        .publishMessage(vars.topic, MqttQos.atLeastOnce, builder.payload!);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      /*
      appBar: AppBar(
        title: const Text('MQTT Control 2'),
        centerTitle: true,
      ),
      */
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            // Contenedor donde se ven los mensajes del broker
            Container(
                width: 200,
                child: Text(
                  vars.mensaje,
                  textAlign: TextAlign.center,
                )),
            SizedBox(
              height: 40,
            ),
            IconButton(
              iconSize: 72,
              icon: const FaIcon(FontAwesomeIcons.circleUp),
              color: Colors.black,
              onPressed: vars.estado
                  ? () {
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
                  onPressed: vars.estado
                      ? () {
                          _publicaMensaje('Izquierda');
                        }
                      : null,
                ),
                IconButton(
                  iconSize: 72,
                  icon: const FaIcon(FontAwesomeIcons.circleRight),
                  color: Colors.black,
                  onPressed: vars.estado
                      ? () {
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
              onPressed: vars.estado
                  ? () {
                      print('Abajo');
                      _publicaMensaje('Abajo');
                    }
                  : null,
            ),
            Slider(
                value: _valorSlider,
                min: 0,
                max: 100,
                divisions: 50,
                label: _valorSlider.round().toString(),
                activeColor: Colors.redAccent,
                inactiveColor: Colors.blueAccent,
                onChanged: (nuevoValor) {
                  vars.estado
                      ? {
                          setState(() {
                            _publicaMensaje(_valorSlider.round().toString());
                            _valorSlider = nuevoValor;
                          })
                        }
                      : null;
                }),
          ],
        ),
      ),
    );
  }
}
