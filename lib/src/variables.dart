import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:path_provider/path_provider.dart';

MqttServerClient? client;
String topic = 'prueba';
String broker = '192.168.0.133';
int port = 1883;
//String username = 'your_username';
//String password = 'your_password';
String clientIdentifier = 'GuzziZander';
String mensaje = 'DESCONECTADO';
bool estado = false;
Color iconColor = Colors.redAccent;

//class 