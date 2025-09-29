import 'dart:io';

import 'package:finance_manager_app/models/expense_model.dart';
import 'package:finance_manager_app/models/tempm/categoryModel/custom_category_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../../../../models/tempm/categoryModel/transaction_model.dart';

class CustomCategoryDbHelper{
  CustomCategoryDbHelper._();

  static final CustomCategoryDbHelper getInstance = CustomCategoryDbHelper._();

  Database?myDB;

  // Table Data
  final String tableName = 'custom_category';
  final String id = 'id';
  final String isExpense = 'isExpense';
  final String name = 'name';
  final String colorValue = 'colorValue';
  final String groupName = 'groupName';
  final String iconCodePoint = 'iconCodePoint';
  final String iconFontFamily = 'iconFontFamily';

  Future<Database> getDB() async {
    myDB ??= await openDB();
    return myDB!;
  }

  Future<Database> openDB() async {
    Directory appDir = await getApplicationDocumentsDirectory();
    String dbPath = join(appDir.path,'custom_category.db');

    return await openDatabase(dbPath,onCreate: (db,version){
      db.execute("CREATE TABLE categories ($id INTEGER PRIMARY KEY AUTOINCREMENT,$isExpense INTEGER NOT NULL,$name TEXT NOT NULL,$iconCodePoint INTEGER NOT NULL,$iconFontFamily TEXT NOT NULL,$colorValue INTEGER NOT NULL,$groupName TEXT");
    },version: 1);
  }

  ///insertion
  Future<bool> addItem( CustomCategoryModel ex) async {
    var db = await getDB();
    int rowsEffected = await db.insert(tableName, ex.toMap() );
    return rowsEffected > 0;
  }

  //Fetch All Data
  Future<List<Map<String, dynamic>>> getAllNotes() async {
    var db = await getDB();
    List<Map<String, dynamic>> mData = await db.query(tableName);

    return mData;
  }
// Update Table Data
// Future<bool> updateNote(
//     {required int s_no, required String title, required String desc}) async {
//   var db = await getDB();
//
//   int rowEffected = await db.update(
//       TABLE_NOTE, {COLUMN_NOTE_TITLE: title, COLUMN_NOTE_DESC: desc},
//       where: "$COLUMN_NOTE_SNO = $s_no");
//
//   return rowEffected > 0;
// }

//Delete Data
// Future<bool> deleteNote({required String sNo}) async {
//   print(sNo);
//   var db = await getDB();
//
//   int rowEffected =
//   await db.delete(TABLE_NOTE, where: "$COLUMN_NOTE_SNO = $sNo");
//   print(rowEffected);
//   return rowEffected > 0;
// }

}