import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../variables.dart';

class Configuracion extends StatelessWidget {
  @override

  /*
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          // the number of items in the list
          //itemCount: myProducts.length,
          itemCount: 50,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
                leading: Icon(
                  FontAwesomeIcons.connectdevelop,
                  color: Colors.blueAccent,
                  /*
                  onTap: () {
                    print('Hola Radiola');
                  },
                  */
                ),
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
  */
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Card(
            child: ListTile(
              //leading: FlutterLogo(),
              title: Text('One-line with both widgets'),
              subtitle: Text('Here is a second line'),
              trailing: IconButton(
                //iconSize: 40,
                icon: FaIcon(FontAwesomeIcons.trash),
                color: Colors.redAccent,
                onPressed: () {
                  print('ddd');
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
