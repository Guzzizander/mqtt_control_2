import 'package:flutter/material.dart';
//import 'conexion.dart';
import 'control.dart';
import 'config.dart';

class Menu extends StatefulWidget {
  const Menu({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<Menu> createState() => _Menu();
}

class _Menu extends State<Menu> with SingleTickerProviderStateMixin {
  // TabController? _tabController;

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
    final _kTabPages = <Widget>[
      const Config(),
      const Control(title: 'Control'),
    ];

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('MQTT Control'),
          centerTitle: true,
          shadowColor: Colors.blueAccent,
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 20),
              const TabBar(
                indicatorColor: Colors.black,
                tabs: [
                  Text(
                    "Configs.",
                    style: TextStyle(
                      fontSize: 17,
                      color: Color(0xFF43669E),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "Control",
                    style: TextStyle(
                      fontSize: 15,
                      color: Color(0xFF43669E),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: _kTabPages,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
