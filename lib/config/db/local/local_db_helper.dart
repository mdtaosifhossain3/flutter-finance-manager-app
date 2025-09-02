import 'dart:io';

import 'package:finance_manager_app/models/expense_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class LocalDBHelper{
  LocalDBHelper._();

  static final LocalDBHelper getInstance = LocalDBHelper._();

  Database?myDB;

  // Table Data
  final String tableName = 'fn_manager';
  final String sno = 'sno';
  final String title = 'title';
  final String date = 'date';
  final String amount = 'amount';
  final String icon = 'icon';
  final String month = 'month';
  final String time = 'time';
  final String categoryName = 'category_name';
  final String message = 'message';

  Future<Database> getDB() async {
    myDB ??= await openDB();
    return myDB!;
  }

  Future<Database> openDB() async {
    Directory appDir = await getApplicationDocumentsDirectory();
    String dbPath = join(appDir.path,'fn_manager.db');
    
    return await openDatabase(dbPath,onCreate: (db,version){
      db.execute("create table $tableName ($sno integer primary key autoincrement,$title text, $date text not null,$amount real,$icon text, $month text, $time text, $categoryName text, $message text)");
    },version: 1);
  }

  ///insertion
  Future<bool> addItem( Expense ex) async {
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