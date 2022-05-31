import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import '../sql_helper.dart';
import '../variables.dart' as vars;

class Config extends StatefulWidget {
  const Config({Key? key}) : super(key: key);

  @override
  _Config createState() => _Config();
}

class _Config extends State<Config> {
  // Lista donde se guardan todos los registros
  List<Map<String, dynamic>> _conexiones = [];

  bool _isLoading = true;
  // This function is used to fetch all data from the database
  void _refreshConexiones() async {
    final data = await SQLHelper.getItems();
    setState(() {
      _conexiones = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshConexiones(); // Loading the diary when the app starts
  }

  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _ipController = TextEditingController();
  final TextEditingController _topicController = TextEditingController();
  final TextEditingController _portController = TextEditingController();
  final TextEditingController _identificadorController =
      TextEditingController();
  final TextEditingController _usuarioController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();

  // This function will be triggered when the floating button is pressed
  // It will also be triggered when you want to update an item
  void _showForm(int? id) async {
    if (id != null) {
      // id == null -> create new item
      // id != null -> update an existing item
      final existingConexion =
          _conexiones.firstWhere((element) => element['id'] == id);
      _nombreController.text = existingConexion['nombre'];
      _ipController.text = existingConexion['ip'];
      _topicController.text = existingConexion['topic'];
      _portController.text = existingConexion['port'];
      _identificadorController.text = existingConexion['identificador'];
      _usuarioController.text = existingConexion['usuario'];
      _pwdController.text = existingConexion['pwd'];
    }

    showModalBottomSheet(
        context: context,
        elevation: 5,
        isScrollControlled: true,
        builder: (_) => Container(
              padding: EdgeInsets.only(
                top: 15,
                left: 15,
                right: 15,
                // this will prevent the soft keyboard from covering the text fields
                bottom: MediaQuery.of(context).viewInsets.bottom + 120,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextField(
                    controller: _nombreController,
                    decoration: const InputDecoration(hintText: 'Nombre'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: _ipController,
                    decoration: const InputDecoration(hintText: 'IP'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: _topicController,
                    decoration: const InputDecoration(hintText: 'Topic'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: _portController,
                    decoration: const InputDecoration(hintText: 'Port'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: _identificadorController,
                    decoration:
                        const InputDecoration(hintText: 'Identificador'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: _usuarioController,
                    decoration: const InputDecoration(hintText: 'Usuario'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: _pwdController,
                    decoration: const InputDecoration(hintText: 'Password'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      // Save new journal
                      if (id == null) {
                        await _addItem();
                      }

                      if (id != null) {
                        await _updateItem(id);
                      }

                      // Clear the text fields
                      _nombreController.text = '';
                      _ipController.text = '';
                      _topicController.text = '';
                      _portController.text = '';
                      _identificadorController.text = '';
                      _usuarioController.text = '';
                      _pwdController.text = '';
                      // Close the bottom sheet
                      Navigator.of(context).pop();
                    },
                    child: Text(id == null ? 'Crear Nuevo' : 'Actualizar'),
                  )
                ],
              ),
            ));
  }

// Inserta un nuevo registro en la BD
  Future<void> _addItem() async {
    await SQLHelper.createItem(
        _nombreController.text,
        _ipController.text,
        _topicController.text,
        _portController.text,
        _identificadorController.text,
        _usuarioController.text,
        _pwdController.text);
    _refreshConexiones();
  }

  // Modifica un registro existente por id
  Future<void> _updateItem(int id) async {
    await SQLHelper.updateItem(
        id,
        _nombreController.text,
        _ipController.text,
        _topicController.text,
        _portController.text,
        _identificadorController.text,
        _usuarioController.text,
        _pwdController.text);
    _refreshConexiones();
  }

  // Borra un registro
  void _deleteItem(int id) async {
    await SQLHelper.deleteItem(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Registro borrado!'),
    ));
    _refreshConexiones();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Center(
              child: Container(
                child: Column(
                  children: [
                    Container(
                      color: Colors.blueAccent,
                      height: 40,
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          vars.textoMensajes,
                          style: TextStyle(
                            fontFamily: 'Verdana',
                            fontSize: 10,
                            color: Colors.white,
                            height: 1,
                          ),
                          maxLines: 5,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _conexiones.length,
                        itemBuilder: (context, index) => Card(
                          color: vars.cardColor,
                          margin: const EdgeInsets.all(15),
                          child: ListTile(
                              tileColor: (_conexiones[index]['id'] == vars.id)
                                  ? Colors.greenAccent
                                  : vars.cardColor,
                              title: Text(
                                _conexiones[index]['nombre'],
                              ),
                              subtitle: Text(_conexiones[index]['ip'] +
                                  '/' +
                                  _conexiones[index]['topic']),
                              onTap: () {
                                vars.id = _conexiones[index]['id'];
                                vars.nombre = _conexiones[index]['nombre'];
                                vars.broker = _conexiones[index]['ip'];
                                vars.topic = _conexiones[index]['topic'];
                                vars.port = _conexiones[index]['port'];
                                vars.identificador =
                                    _conexiones[index]['identificador'];
                                // Cambia a la Pantalla de conexion
                                //DefaultTabController.of(context)!.animateTo(1);
                              },
                              trailing: SizedBox(
                                width: 150,
                                child: Row(
                                  children: [
                                    IconButton(
                                      icon: ((vars.estado) &&
                                              (_conexiones[index]['id'] ==
                                                  vars.id))
                                          ? FaIcon((FontAwesomeIcons.link),
                                              //color: vars.iconColor)
                                              color: Colors.blueAccent)
                                          : FaIcon((FontAwesomeIcons.linkSlash),
                                              //color: vars.iconColor),
                                              color: Colors.redAccent),
                                      onPressed: () {
                                        if (!vars.estado) {
                                          vars.id = _conexiones[index]['id'];
                                          vars.nombre =
                                              _conexiones[index]['nombre'];
                                          vars.broker =
                                              _conexiones[index]['ip'];
                                          vars.topic =
                                              _conexiones[index]['topic'];
                                          vars.port =
                                              _conexiones[index]['port'];
                                          vars.identificador =
                                              _conexiones[index]
                                                  ['identificador'];
                                          brokerSetup();
                                        } else {
                                          setState(() {
                                            vars.mensaje = 'DESCONECTADO';
                                            vars.estado = false;
                                            vars.client!.disconnect();
                                            vars.iconColor = Colors.redAccent;
                                            vars.id = 0;
                                            vars.textoMensajes = 'DESCONECTADO';
                                          });
                                          // En principio no hace falta
                                          //estadoConexion();
                                        }
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () =>
                                          _showForm(_conexiones[index]['id']),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () =>
                                          _deleteItem(_conexiones[index]['id']),
                                    ),
                                  ],
                                ),
                              )),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showForm(null),
      ),
    );
  }

  Future<MqttServerClient> brokerSetup() async {
    vars.client = MqttServerClient.withPort(
        vars.broker, vars.identificador, int.parse(vars.port));

    vars.client!.logging(on: true);
    //vars.client!.setProtocolV311();
    vars.client!.autoReconnect = true;
    vars.client!.onAutoReconnect = onAutoReconnect;
    vars.client!.onAutoReconnected = onAutoReconnected;
    vars.client!.keepAlivePeriod = 20;
    vars.client!.onConnected = onConnected;
    vars.client!.onDisconnected = onDisconnected;
    vars.client!.onSubscribed = onSubscribed;
    vars.client!.onSubscribeFail = onSubscribeFail;
    vars.client!.pongCallback = pong;
    vars.client!.secure = false;

    try {
      await vars.client!.connect();
    } catch (e) {
      setState(() {
        vars.mensaje = 'ERROR DE CONNEXION';
        vars.iconColor = Colors.redAccent;
        vars.textoMensajes = 'ERROR DE CONNEXION \n $e';
      });
      //print('Exception: $e');
    }
    return vars.client!;
  }

//actions
  void onConnected() {
    estadoConexion();
    setState(() {
      vars.mensaje = 'CONECTADO';
      vars.estado = true;
      vars.iconColor = Colors.blueAccent;
      vars.textoMensajes = 'CONECTADO';
    });
    DefaultTabController.of(context)!.animateTo(1);
  }

  void onDisconnected() {
    //estadoConexion();
  }

  void onSubscribed(String topic) {
    //print('subscribed to $topic');
    /*
    // No estoy suscrito ya que no tengo que recibir mensajes
    setState(() {
      vars.mensaje = 'SUBSCRITO A ' + topic.toUpperCase();
    });
    */
  }

  void onSubscribeFail(String topic) {
    //print('failed to subscribe to $topic');
  }

  void on() {
    //print('disconnected');
  }

  void pong() {
    //print('ping response arrived');
    setState(() {
      vars.textoMensajes = 'EXAMPLE::Ping response client callback invoked';
    });
  }

  void estadoConexion() {
    String estado = '';
    if (vars.client!.connectionStatus!.state == MqttConnectionState.connected) {
      //print('EXAMPLE::Mosquitto client connected');
      estado = 'EXAMPLE::Mosquitto client connected';
    } else {
      /// Use status here rather than state if you also want the broker return code.
      //print(
      //    'EXAMPLE::ERROR Mosquitto client connection failed - disconnecting, status is ${vars.client!.connectionStatus}');
      vars.client!.disconnect();
      estado =
          'EXAMPLE::ERROR Mosquitto client connection failed - disconnecting, status is ${vars.client!.connectionStatus}';
    }
    setState(() {
      vars.textoMensajes = estado;
    });
  }

  /// The pre auto re connect callback
  void onAutoReconnect() {
    //print(
    //    'EXAMPLE::onAutoReconnect client callback - Client auto reconnection sequence will start');
    setState(() {
      vars.textoMensajes =
          'EXAMPLE::onAutoReconnect client callback - Client auto reconnection sequence will start';
    });
  }

  void onAutoReconnected() {
    //print(
    //    'EXAMPLE::onAutoReconnected client callback - Client auto reconnection sequence has completed');

    setState(() {
      vars.textoMensajes =
          'EXAMPLE::onAutoReconnected client callback - Client auto reconnection sequence has completed';
    });
  }
}
