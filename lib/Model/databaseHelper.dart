import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class databaseHelper {
  static final _databasename = "user1.db";
  static final _databaseversions = 1;

  static final table = "users_table";

  static final columnId = 'id';
  static final columnFirstName = 'first_name';
  static final columnLastName = 'last_name';
  static final columnEmailId = 'email';
  static final columnDOB = 'dob';
  static final columnInsertedDate = 'inserted_date';

  static Database _database;
  databaseHelper._privateConstructor();
  static final databaseHelper instance =
      databaseHelper._privateConstructor(); //crate only single instance

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    Directory documentsdirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsdirectory.path, _databasename);
    return await openDatabase(path,
        version: _databaseversions, onCreate: _oncreate);
  }

  Future _oncreate(Database db, int version) async {
    await db.execute(''' 
        CREATE TABLE $table(
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnFirstName TEXT NOT NULL,
        $columnLastName TEXT NOT NULL,
        $columnEmailId TEXT NOT NULL,
        $columnDOB TEXT NOT NULL,
        $columnInsertedDate TEXT NOT NULL)
      ''');
  }

  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  Future<List<Map<String, dynamic>>> queryall() async {
    Database db = await instance.database;
    return await db.query(table);
  }

  Future<List<Map<String, dynamic>>> querySpecific(String name) async {
    Database db = await instance.database;
    var res = await db.query(table, where: "user = ?", whereArgs: [name]);
    return res;
  }
}
