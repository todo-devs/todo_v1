import 'package:sqflite/sqflite.dart';
import 'package:todo/services/database.dart';

class User {
  int id;
  String username = '';
  String password = '';

  Future<Database> _database;

  User({this.id, this.username, this.password}) {
    _database = getDataBase();
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'username': username, 'password': password};
  }

  Future<void> save() async {
    final Database db = await _database;

    final result = await db
        .query('users', where: "username = ?", whereArgs: [this.username]);

    if (result.length > 0) {
      this.update();
    } else {
      await db.insert(
        'users',
        this.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<void> update() async {
    final db = await _database;

    await db.update(
      'users',
      this.toMap(),
      where: "id = ?",
      whereArgs: [this.id],
    );
  }

  static Future<User> findByName(String uname) async {
    final db = await getDataBase();

    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: "username = ?",
      whereArgs: [uname],
    );

    final ll = List.generate(maps.length, (i) {
      return User(
        id: maps[i]['id'],
        username: maps[i]['username'],
        password: maps[i]['password'],
      );
    });

    return ll.length != 0 ? ll.first : null;
  }

  Future<void> delete() async {
    final db = await _database;

    await db.delete(
      'users',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  static Future<List<User>> getAll() async {
    final Database db = await getDataBase();

    final List<Map<String, dynamic>> maps = await db.query('users');

    return List.generate(maps.length, (i) {
      return User(
        id: maps[i]['id'],
        username: maps[i]['username'],
        password: maps[i]['password'],
      );
    });
  }
}
