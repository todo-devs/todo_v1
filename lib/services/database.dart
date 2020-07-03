import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Future<Database> getDataBase() async {
  final Future<Database> database = openDatabase(
    // Establece la ruta a la base de datos.
    join(await getDatabasesPath(), 'todoapp.db'),
    // Cuando la base de datos se crea por primera vez, crea las tablas de almacenamiento
    onCreate: (db, version) {
      // Ejecuta la sentencia CREATE TABLE en la base de datos
      return db.execute(
        "CREATE TABLE users(id INTEGER PRIMARY KEY, username TEXT, password TEXT)",
      );
    },
    // Establece la versión. Esto ejecuta la función onCreate y proporciona una
    // ruta para realizar actualizacones y defradaciones en la base de datos.
    version: 1,
  );

  return database;
}
