import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper{
  static const _databaseName = "StudentDetailsDB.db";
  static const _databaseVersion = 2; // _onUpgrade - increment

  // Student Details table
  static const studentDetailsTable = 'StudentTable';

  static const colId = '_id';

  // Student Details table column
  static const colStudentName = '_studentName';
  static const colMobileNo = '_mobileNo';
  static const colEmailID = '_emailId';

  late Database _db;

  Future<void> initialization() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _databaseName);

    _db = await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future _onCreate(Database database, int version) async {
    await database.execute('''
          CREATE TABLE $studentDetailsTable (
            $colId INTEGER PRIMARY KEY,
            $colStudentName TEXT,   
            $colMobileNo TEXT,     
            $colEmailID TEXT            
          )
          ''');
  }

  _onUpgrade(Database database, int oldVersion, int newVersion) async{
    await database.execute('drop table $studentDetailsTable');
    _onCreate(database, newVersion);
  }

  Future<int> insertStudentDetails(Map<String, dynamic> row, String tableName) async {
    return await _db.insert(tableName, row);
  }

  Future<List<Map<String, dynamic>>> queryAllRows(String tableName) async {
    return await _db.query(tableName);
  }

  Future<int> updateStudentDetails(Map<String, dynamic> row, String tableName) async {
    int id = row[colId];
    return await _db.update(
      tableName,
      row,
      where: '$colId = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteStudentDetails(int id, String tableName) async{
    return await _db.delete(
      tableName,
    where: '$colId = ?',
      whereArgs: [id],
    );
  }
}

