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
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  // Clean up the controller when the widget is disposed.
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
    );
  }
}
