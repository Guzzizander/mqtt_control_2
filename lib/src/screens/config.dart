import 'package:flutter/material.dart';
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

// Insert a new journal to the database
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

  // Update an existing journal
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

  // Delete an item
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
          : ListView.builder(
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
                      /*
                      setState(() {
                        vars.cardColor = Colors.greenAccent;
                      });
                      */
                      vars.id = _conexiones[index]['id'];
                      vars.nombre = _conexiones[index]['nombre'];
                      vars.broker = _conexiones[index]['ip'];
                      vars.topic = _conexiones[index]['topic'];
                      vars.port = _conexiones[index]['port'];
                      vars.identificador = _conexiones[index]['identificador'];
                      DefaultTabController.of(context)!.animateTo(1);
                    },
                    trailing: SizedBox(
                      width: 100,
                      child: Row(
                        children: [
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
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showForm(null),
      ),
    );
  }
}
