import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:path_provider/path_provider.dart';

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

class Configs {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/conexiones.json');
  }

  Future<String> readConfig() async {
    try {
      final file = await _localFile;
      // Read the file
      final JSON = await file.readAsString();
      return JSON;
    } catch (e) {
      // If encountering an error, return 0
      return 'ERROR';
    }
  }

  Future<File> writeConfig(String json) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString('$json');
  }
}

class Conexion {
  late final String cNombre;
  late final String cIP;
  late final String cTopic;
  late final String cPort;
  late final String cIdentificador;

  Conexion(
      this.cNombre, this.cIP, this.cTopic, this.cPort, this.cIdentificador);

  Conexion.fromJson(Map<String, dynamic> json)
      : cNombre = json['Nombre'],
        cIP = json['IP'],
        cTopic = json['Topic'],
        cPort = json['Port'],
        cIdentificador = json['Identificacion'];

  Map<String, dynamic> toJson() => {
        'Nombre': cNombre,
        'IP': cIP,
        'Topic': cTopic,
        'Port': cPort,
        'Identificador': cIdentificador
      };
}
