import 'package:flutter/material.dart';
//import 'conexion.dart';
import 'control.dart';
import 'config.dart';
import '../variables.dart' as vars;

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
      Config(notifyParent: refresh),
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
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                child: Container(
                  color: Colors.blueAccent,
                  height: 40,
                  child: Center(
                    child: Text(
                      vars.textoMensajes,
                      style: TextStyle(
                        fontFamily: 'Verdana',
                        fontSize: 10,
                        color: Colors.white,
                        height: 1,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
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

  refresh() {
    setState(() {});
  }
}
