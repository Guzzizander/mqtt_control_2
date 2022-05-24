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
                _pulsado('N');
              },
              onPointerUp: (details) {
                _buttonPressed = false;
              },
              child: Container(
                child: IconButton(
                  iconSize: 72,
                  icon: FaIcon(FontAwesomeIcons.circleUp),
                  color: Colors.black,
                  onPressed: vars.estado
                      ? () {
                          _publicaMensaje('N');
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
                    _pulsado('O');
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
                              _publicaMensaje('O');
                            }
                          : null,
                    ),
                  ),
                ),
                // Boton Paro / Marcha
                IconButton(
                  iconSize: 72,
                  icon: vars.iconMarcha,
                  color: vars.iconMarchaColor,
                  onPressed: vars.estado
                      ? () {
                          if (vars.marcha) {
                            _publicaMensaje('0');
                            setState(() {
                              vars.marcha = false;
                              vars.iconMarcha =
                                  FaIcon(FontAwesomeIcons.solidCirclePlay);
                              vars.iconMarchaColor = Colors.redAccent;
                            });
                          } else {
                            _publicaMensaje('1');
                            setState(() {
                              vars.marcha = true;
                              vars.iconMarcha =
                                  FaIcon(FontAwesomeIcons.solidCircleStop);
                              vars.iconMarchaColor = Colors.blueAccent;
                            });
                          }
                        }
                      : null,
                ),
                Listener(
                  onPointerDown: (details) {
                    _buttonPressed = true;
                    _pulsado('E');
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
                              _publicaMensaje('E');
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
                _pulsado('S');
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
                          _publicaMensaje('S');
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
