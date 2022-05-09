import 'package:flutter/material.dart';
import 'conexion.dart';
import 'control.dart';
import 'configuracion.dart';

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
    // _tabController = TabController(length: 3, vsync: this);
  }

  @override
  // Clean up the controller when the widget is disposed.
  void dispose() {
    // _tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _kTabPages = <Widget>[
      Configuracion(),
      Conexion(title: 'Conexion'),
      Control(title: 'Control'),
    ];

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        /* appBar: new PreferredSize(
          preferredSize: Size.fromHeight(40),
          child: new Container(
            color: Color(0xFF428DA3),
            child: new SafeArea(
              child:
            ),
          ),
        ),*/
        body: Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: Column(
            children: <Widget>[
              SizedBox(height: 20),
              new TabBar(
                indicatorColor: Colors.black,
                tabs: [
                  new Text(
                    "Un",
                    style: TextStyle(
                      fontSize: 17,
                      color: Color(0xFF43669E),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  new Text(
                    "Dos",
                    style: TextStyle(
                      fontSize: 15,
                      color: Color(0xFF43669E),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  new Text(
                    "Tres",
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
/*
    return Scaffold(
      appBar: AppBar(
        title: const Text('MQTT Control'),
        centerTitle: true,
        bottom: TabBar(controller: _tabController, tabs: [
          Tab(text: 'Configuracion'),
          Tab(text: 'Conexion'),
          Tab(text: 'Control'),
        ]),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Configuracion(),
          Conexion(title: 'Conexion'),
          Control(title: 'Control'),
        ],
      ),
    );*/
  }
}
