import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

MqttServerClient? client;
int id = 0;
String nombre = 'Casa';
String topic = 'prueba';
String broker = '192.168.0.133';
String port = '1883';
//String username = 'your_username';
//String password = 'your_password';
String identificador = 'GuzziZander';
String mensaje = 'DESCONECTADO';
bool estado = false;
Color iconColor = Colors.redAccent;
Color cardColor = const Color.fromARGB(255, 194, 191, 191);
