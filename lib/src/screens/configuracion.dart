import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Configuracion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          // the number of items in the list
          //itemCount: myProducts.length,
          itemCount: 50,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
                leading: Icon(FontAwesomeIcons.connectdevelop,
                    color: Colors.blueAccent),
                /*
                trailing: Text(
                  "GFG",
                  style: TextStyle(color: Colors.green, fontSize: 15),
                ),
                */
                trailing: Icon(FontAwesomeIcons.trash, color: Colors.grey),
                title: Text("List item $index"));
          }),
    );
  }
}
