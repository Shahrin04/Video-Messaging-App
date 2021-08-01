import 'dart:io';

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:skype_clone/model_class/log.dart';
import 'package:skype_clone/resource/local_db/interface/log_interface.dart';

class HiveMethods implements LogInterface {
  String hiveBox = '';

  @override
  openDb(String dbName) => hiveBox = dbName;

  @override
  init() async {
    Directory dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
  }

  @override
  addLogs(Log log) async {
    var box = await Hive.openBox(hiveBox);
    var logMap = log.toMap(log);

    int idOfInput = await box.add(logMap);
    print('log added with id ${idOfInput.toString()} in Hive db');
    //var idOfInput = await box.put('id', logMap);
    close();

    return idOfInput;
  }


  updateLogs(int i ,Log log) async {
    var box = await Hive.openBox(hiveBox);
    var logMap = log.toMap(log);
    await box.putAt(i, logMap);
    close();

  }

  @override
  Future<List<Log>> getLogs() async {
    try {
      var box = await Hive.openBox(hiveBox);

      List<Log> logList = [];
      for(int i = 0; i<box.length; i++){
        var logMap = box.getAt(i);
        //var logMap = box.get('id');
        logList.add(Log.fromMap(logMap));
      }

      return logList;
    } on Exception catch (e) {
      print('data read exception : ${e.toString()}');
      return null;
    }
  }

  @override
  deleteLogs(int logId) async {
    var box = await Hive.openBox(hiveBox);
    await box.deleteAt(logId);
    //await box.delete(logId);
  }

  @override
  close() => Hive.close();

}
