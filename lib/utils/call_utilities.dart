import 'dart:math';

import 'package:flutter/material.dart';
import 'package:skype_clone/constants/strings.dart';
import 'package:skype_clone/model_class/call.dart';
import 'package:skype_clone/model_class/log.dart';
import 'package:skype_clone/model_class/user_model.dart';
import 'package:skype_clone/resource/call_method.dart';
import 'package:skype_clone/resource/local_db/db/hive_methods.dart';
import 'package:skype_clone/resource/local_db/repository/log_repository.dart';
import 'package:skype_clone/screens/call_screen/call_screen.dart';

class CallUtils {
  static final CallMethod callMethod = CallMethod();

  static dial({UserModel from, UserModel to, context}) async {
    Call call = Call(
        callerId: from.uid,
        callerName: from.name,
        callerPhoto: from.photoUrl,
        receiverId: to.uid,
        receiverName: to.name,
        receiverPhoto: to.photoUrl,
        channelId: Random().nextInt(1000).toString());

    Log log = Log(
        callerName: from.name,
        callerPic: from.photoUrl,
        receiverName: to.name,
        receiverPic: to.photoUrl,
        timeStamp: DateTime.now().toString(),
        callStatus: CALL_STATUS_DIALED
    );

    bool callMade = await callMethod.makeCall(call: call);
    call.hasDialed = true;

    if (callMade) {
      //enter log
      LogRepository.addLogs(log);
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => CallScreen(call: call)));
    }
  }
}
