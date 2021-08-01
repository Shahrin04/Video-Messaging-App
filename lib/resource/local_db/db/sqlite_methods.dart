import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:skype_clone/model_class/log.dart';
import 'package:skype_clone/resource/local_db/interface/log_interface.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqliteMethod implements LogInterface {
  Database _db;

  String databaseName = '';
  String tableName = 'Call_Logs';

  //columns
  String id = 'logId';
  String callerName = 'callerName';
  String callerPic = 'callerPic';
  String receiverName = 'receiverName';
  String receiverPic = 'receiverPic';
  String callStatus = 'callStatus';
  String timeStamp = 'timeStamp';

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    } else {
      print('db was null, now awaiting it');
      _db = await init();
      return _db;
    }
  }

  @override
  openDb(String dbName) async => databaseName = dbName;

  @override
  init() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = join(dir.path, databaseName);

    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    String createTableQuery =
        'CREATE TABLE $tableName($id INTEGER PRIMARY KEY, $callerName TEXT, $callerPic TEXT, $receiverName TEXT, $receiverPic TEXT, $callStatus TEXT, $timeStamp TEXT)';
    await db.execute(createTableQuery);
    print('table created');
  }

  @override
  addLogs(Log log) async {
    var dbClient = await db;
    print('This log has been added in sqlite db');
    await dbClient.insert(tableName, log.toMap(log));
  }

  @override
  Future<List<Log>> getLogs() async {
    try {
      var dbClient = await db;
      List<Map> maps = await dbClient.query(tableName, columns: [
        id,
        callerName,
        callerPic,
        receiverName,
        receiverPic,
        callStatus,
        timeStamp,
      ]);

      List<Log> logList = [];

      if (maps.isNotEmpty) {
        for (Map map in maps) {
          logList.add(Log.fromMap(map));
        }
      }

      return logList;
    } on Exception catch (e) {
      print('data read exception : ${e.toString()}');
      return null;
    }
  }

  updateLogs(Log log) async {
    var dbClient = await db;
    await dbClient.update(tableName, log.toMap(log),
        where: '$id = ?', whereArgs: [log.logId + 1]);
  }

  @override
  deleteLogs(int logId) async {
    var dbClient = await db;
    await dbClient.delete(tableName, where: '$id = ?', whereArgs: [
      logId + 1
    ]); //incoming value of logId could be 0 and table index starts from 1
  }

  @override
  close() async {
    var dbClient = await db;
    await dbClient.close();
  }
}
