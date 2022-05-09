import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import '../variables.dart' as vars;
import 'welcome.dart';

class Configuracion extends StatefulWidget {
  const Configuracion({Key? key}) : super(key: key);

  @override
  State<Configuracion> createState() => _Configuracion();
}

class _Configuracion extends State<Configuracion> {
  late List data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: FutureBuilder(
        future: DefaultAssetBundle.of(context)
            .loadString('assets/loadjson/conexiones.json'),
        builder: (context, snapshot) {
          // Decode the JSON
          var newData = json.decode(snapshot.data.toString());
          return ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return Card(
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 32, bottom: 32, left: 16, right: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              print(newData[index]);
                              vars.id = index;
                              vars.nombre = newData[index]['Nombre'];
                              vars.broker = newData[index]['IP'];
                              vars.topic = newData[index]['Topic'];
                              vars.port = newData[index]['Port'];
                              vars.identificador =
                                  newData[index]['Identificador'];
                              DefaultTabController.of(context)!.animateTo(1);
                            },
                            child: Text(
                              newData[index]['Nombre'],
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 22),
                            ),
                          ),
                          Text(
                            newData[index]['IP'] +
                                '/' +
                                newData[index]['Topic'],
                            //'Note Text',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                      SizedBox(width: 20),
                      Container(
                        height: 25,
                        width: 40,
                        child: Icon(Icons.delete,
                            color: Colors.redAccent, size: 40.0),
                      ),
                    ],
                  ),
                ),
              );
            },
            itemCount: newData == null ? 0 : newData.length,
          );
        },
      ),
    ));
  }
}
