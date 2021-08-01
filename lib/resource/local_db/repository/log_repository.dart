import 'package:meta/meta.dart';
import 'package:skype_clone/model_class/log.dart';
import 'package:skype_clone/resource/local_db/db/hive_methods.dart';
import 'package:skype_clone/resource/local_db/db/sqlite_methods.dart';

// class LogRepository{
//   static var dbObject;
//   static bool isHive;
//
//   static init({@required bool isHive}){
//     dbObject = isHive ? HiveMethods() : SqliteMethod();
//     dbObject.init();
//
//   }
//
//   static addLogs(Log log) => dbObject.addLogs(log);
//
//   static getLogs() => dbObject.getLogs();
//
//   static deleteLogs(int logId) => dbObject(logId);
//
//   static close() => dbObject.close();
//
// }

class LogRepository {
  static var dbObject;
  static bool isHive;

  static init({@required bool isHive, @required String dbName}) {
    dbObject = isHive ? HiveMethods() : SqliteMethod();
    dbObject.openDb(dbName);
    dbObject.init();
  }

  static addLogs(Log log) => dbObject.addLogs(log);

  static deleteLogs(int logId) => dbObject.deleteLogs(logId);

  static getLogs() => dbObject.getLogs();

  static close() => dbObject.close();
}