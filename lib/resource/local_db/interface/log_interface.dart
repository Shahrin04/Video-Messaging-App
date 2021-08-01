import 'package:skype_clone/model_class/log.dart';

abstract class LogInterface{
  openDb(String dbName);

  init();

  addLogs(Log log);

  Future<List<Log>> getLogs();

  //updateLogs(Log log);

  deleteLogs(int logId);

  close();

}