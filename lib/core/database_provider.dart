import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  final int version = 2;
  String dbName = 'database';
  // This code here will help to make the database helper class singleton
  static final DatabaseHelper _instance = new DatabaseHelper.internal();
//
  factory DatabaseHelper() => _instance;
//
  static Database _db;
//
//
  DatabaseHelper.internal();
//  static DatabaseHelper instance;
//
//  factory DatabaseHelper({String dbName}) {
//    if (instance == null) {
//      instance = new DatabaseHelper._internal(dbName);
//    }
//    return instance;
//  }
//
//  DatabaseHelper._internal(this.dbName);

  void printdbName() {
  }

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  initDb() async {
    //Get application directory
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    //prepare a database path
    String path = join(documentDirectory.path, dbName + '.db');
    //open the database
    var ourDb = await openDatabase(path, version: version, onCreate: _onCreate);
    return ourDb;
  }

  Future deleteDbandRecreate({String dbName}) async {
    //Get application directory
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    //prepare a database path
    String path = join(documentDirectory.path, dbName + '.db');
    await close();
    await deleteDatabase(path);
    _db = null;
    return db;
  }

  Future deleteDb() async {
    //Get application directory
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    //prepare a database path
    String path = join(documentDirectory.path, dbName + '.db');
    return await deleteDatabase(path);
  }

  void _onCreate(Database db, int version) async {

  }

  Future create_table(String name, columnsArray) async {
    String columns = columnsArray.join(', ');
    columns = columns.replaceAll("MAP", "BLOB");
    final query = "CREATE TABLE IF NOT EXISTS $name ($columns)";
    var dbClient = await db;
    await dbClient.execute(query);
  }

  //Insertion
  Future<int> saveItem(String tableName, columns, values) async {
    var dbClient = await db;
    String query = "INSERT INTO $tableName(${columns.join(',')}) VALUES(${values.join(',')})";
    await dbClient.execute(query);
    return 1;
  }

  //Insertion
  Future<int> saveItemMap(String tableName, Map<String, dynamic> values) async {
    var dbClient = await db;
    return await dbClient.insert(tableName,values);
  }

  Future<int> updateItemMap(String tableName, criteria,values) async {
    var dbClient = await db;
    return await dbClient.update(tableName,values,where:criteria);
  }

  //Get Items
  Future<List<Map<String, dynamic>>> getAllItems(String tableName) async {
    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT * FROM $tableName");

    return result.toList();
  }

  //Get Items
  Future<List<Map<String, dynamic>>> getAllItemsByColumn(
      String tableName, String columName, dynamic value) async {
    var dbClient = await db;
    var result = await dbClient
        .rawQuery("SELECT * FROM $tableName WHERE $columName = '$value'");

    return result.toList();
  }

  //Get Items
  Future<List<Map<String, dynamic>>> getItemsByFieldsAndWhere(
      String tableName, List<String> fields, List<String> where) async {
    var dbClient = await db;
    String whereClause = "";
    if(where.length > 0){
      whereClause = "WHERE ${where.join(" AND ")}";
    }

    String selectClause = "*";
    if(fields.length > 0){
      selectClause = "${fields.join(", ")}";
    }
    var result = await dbClient
        .rawQuery("SELECT $selectClause FROM $tableName $whereClause");

    return result.toList();
  }

  Future printTableColumnes(String tablename)async {
    var dbClient = await db;
    return await dbClient
        .rawQuery("PRAGMA table_info($tablename);");
  }

  //Get Items
  Future<List<Map<String, dynamic>>> getOrderdItemsByColumn(String tableName,
      String columName, dynamic value, orderBy, orderType) async {
    var dbClient = await db;
    var result = await dbClient.rawQuery(
        "SELECT * FROM $tableName WHERE $columName = '$value' ORDER BY $orderBy $orderType");

    return result.toList();
  }

  //Get Items
  Future<List<Map<String, dynamic>>> getOrderdItems(
      String tableName, orderBy, orderType) async {
    var dbClient = await db;
    var result = await dbClient
        .rawQuery("SELECT * FROM $tableName ORDER BY $orderBy $orderType");

    return result.toList();
  }

  // Get Counts of all items
  Future<int> getCount(String tableName) async {
    var dbClient = await db;
    return Sqflite.firstIntValue(
        await dbClient.rawQuery("SELECT COUNT(*) FROM $tableName"));
  }

  // Get Counts of all single items
  Future<int> getSingleItemCount(String tableName, String id) async {
    var dbClient = await db;
    return Sqflite.firstIntValue(await dbClient
        .rawQuery("SELECT COUNT(*) FROM $tableName WHERE id = '$id'"));
  }

  // Get Counts of all single items
  Future<int> getSingleItemCountByColumn(
      String tableName, String columName, dynamic value) async {
    var dbClient = await db;
    return Sqflite.firstIntValue(await dbClient.rawQuery(
        "SELECT COUNT(*) FROM $tableName WHERE $columName = '$value'"));
  }

  // Get single item by id
  Future<dynamic> getItem(String tableName, String id) async {
    var dbClient = await db;

    var result =
    await dbClient.rawQuery("SELECT * FROM $tableName WHERE id = '$id'");
    if (result.length == 0) return null;
    return result;
  }

  // get item by specifying column
  Future<dynamic> getItemByColumn(
      String tableName, String columnName, dynamic value) async {
    var dbClient = await db;

    var result = await dbClient
        .rawQuery("SELECT * FROM $tableName WHERE $columnName = '$value'");
    if (result.length == 0) return null;
    return result;
  }

  // delete column in a database
  Future<int> deleteItem(String tableName, String id) async {
    var dbClient = await db;

    return await dbClient
        .delete(tableName, where: "id = ?", whereArgs: ["$id"]);
  }

  // delete column in a database using specified
  Future<int> deleteItemByColumn(
      String tableName, String column, dynamic value) async {
    var dbClient = await db;

    return await dbClient
        .delete(tableName, where: "$column = ?", whereArgs: [value]);
  }

  Future<int> deleteAll(String tableName) async {
    var dbClient = await db;

    return await dbClient
        .delete(tableName);
  }

  // update Item in database
  Future<int> updateItem(String tableName, dynamic item) async {
    var dbClient = await db;
    return await dbClient
        .update(tableName, item.toMap(), where: "id = ?", whereArgs: [item.id]);
  }

  // update Item in database
  Future<int> updateItemByColumn(
      String tableName, dynamic item, String column, dynamic value) async {
    var dbClient = await db;
    return await dbClient.update(tableName, item.toMap(),
        where: "$column = ?", whereArgs: [value]);
  }

  // Get single item by id
  Future<dynamic> getListOfTables() async {
    var dbClient = await db;

    var result = await dbClient
        .rawQuery("SELECT name FROM sqlite_master WHERE type='table'");
    if (result.length == 0) return null;
    return result;
  }

  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }

  void resetDb() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    //prepare a database path
    String path = join(documentDirectory.path, dbName + '.db');
    await deleteDatabase(path);
    _db = null;
  }
}
