import 'package:flutter/material.dart';
import 'screens/menu.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Control MQTT 2',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Menu(title: 'Menu'),
    );
  }
}
