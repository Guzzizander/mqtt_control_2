import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE conexiones(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        nombre TEXT,
        ip TEXT,
        topic TEXT,
        port TEXT,
        identificador TEXT,
        usuario TEXT,
        pwd TEXT
      )
      """);
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'conexiones.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  // Crea un nuevo registro
  static Future<int> createItem(String nombre, String ip, String topic,
      String port, String identificador, String? usuario, String? pwd) async {
    final db = await SQLHelper.db();

    final data = {
      'nombre': nombre,
      'ip': ip,
      'topic': topic,
      'port': port,
      'identificador': identificador,
      'usuario': usuario,
      'pwd': pwd
    };
    final id = await db.insert('conexiones', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  // Lee todas las conexiones
  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await SQLHelper.db();
    return db.query('conexiones', orderBy: "id");
  }

  // Lee un solo registro
  // No se utiliza en la aplicacion
  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await SQLHelper.db();
    return db.query('conexiones', where: "id = ?", whereArgs: [id], limit: 1);
  }

  // Modifica un registro por id
  static Future<int> updateItem(int id, String nombre, String ip, String topic,
      String port, String identificador, String? usuario, String? pwd) async {
    final db = await SQLHelper.db();

    final data = {
      'nombre': nombre,
      'ip': ip,
      'topic': topic,
      'port': port,
      'identificador': identificador,
      'usuario': usuario,
      'pwd': pwd
    };

    final result =
        await db.update('conexiones', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  // Borra un registro por id
  static Future<void> deleteItem(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("conexiones", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}
