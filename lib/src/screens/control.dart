import 'dart:async';
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

  bool _buttonPressed = false;
  bool _loopActive = false;

  void _pulsado(String accion) async {
    if (_loopActive) return;

    _loopActive = true;

    while (_buttonPressed) {
      _publicaMensaje(accion);
      setState(() {
        //ToDo
      });

      // wait a second
      await Future.delayed(Duration(milliseconds: 100));
    }
    _loopActive = false;
  }

  void _publicaMensaje(String mensaje) {
    builder.clear();
    builder.addString(mensaje);
    vars.client!
        .publishMessage(vars.topic, MqttQos.atLeastOnce, builder.payload!);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            // Contenedor donde se ven los mensajes del broker
            Container(
              width: 200,
            ),
            SizedBox(
              height: 40,
            ),
            Listener(
              onPointerDown: (details) {
                _buttonPressed = true;
                _pulsado('Arriba');
              },
              onPointerUp: (details) {
                _buttonPressed = false;
              },
              child: Container(
                child: IconButton(
                  iconSize: 72,
                  icon: const FaIcon(FontAwesomeIcons.circleUp),
                  color: Colors.black,
                  onPressed: vars.estado
                      ? () {
                          _publicaMensaje('Arriba');
                        }
                      : null,
                ),
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Listener(
                  onPointerDown: (details) {
                    _buttonPressed = true;
                    _pulsado('Izquierda');
                  },
                  onPointerUp: (details) {
                    _buttonPressed = false;
                  },
                  child: Container(
                    child: IconButton(
                      iconSize: 72,
                      icon: const FaIcon(FontAwesomeIcons.circleLeft),
                      color: Colors.black,
                      onPressed: vars.estado
                          ? () {
                              _publicaMensaje('Izquierda');
                            }
                          : null,
                    ),
                  ),
                ),
                Listener(
                  onPointerDown: (details) {
                    _buttonPressed = true;
                    _pulsado('Stop');
                  },
                  onPointerUp: (details) {
                    _buttonPressed = false;
                  },
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.redAccent,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          spreadRadius: 2,
                          blurRadius: 3,
                          offset: Offset(0, 3),
                        )
                      ],
                    ),
                  ),
                ),
                Listener(
                  onPointerDown: (details) {
                    _buttonPressed = true;
                    _pulsado('Derecha');
                  },
                  onPointerUp: (details) {
                    _buttonPressed = false;
                  },
                  child: Container(
                    child: IconButton(
                      iconSize: 72,
                      icon: const FaIcon(FontAwesomeIcons.circleRight),
                      color: Colors.black,
                      onPressed: vars.estado
                          ? () {
                              _publicaMensaje('Derecha');
                            }
                          : null,
                    ),
                  ),
                ),
              ],
            ),
            Listener(
              onPointerDown: (details) {
                _buttonPressed = true;
                _pulsado('Abajo');
              },
              onPointerUp: (details) {
                _buttonPressed = false;
              },
              child: Container(
                child: IconButton(
                  iconSize: 72,
                  icon: const FaIcon(FontAwesomeIcons.circleDown),
                  color: Colors.black,
                  onPressed: vars.estado
                      ? () {
                          _publicaMensaje('Abajo');
                        }
                      : null,
                ),
              ),
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
