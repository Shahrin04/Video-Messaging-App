import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:skype_clone/model_class/call.dart';
import 'package:skype_clone/model_class/user_model.dart';
import 'package:skype_clone/resource/call_method.dart';

class CallScreen extends StatefulWidget {
  final Call call;

  CallScreen({@required this.call});

  @override
  _CallScreenState createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  final CallMethod _callMethod = CallMethod();
  StreamSubscription callStreamSubscription;

  @override
  void initState() {
    super.initState();
    addPostFrameCallBack();
  }

  addPostFrameCallBack() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      UserModel user = Provider.of<UserModel>(context, listen: false);

      callStreamSubscription = _callMethod.callStream(uid: user.uid).listen((DocumentSnapshot ds) {
        switch(ds.data()){
          case null:
            //snapshot is null which means that call is hanged and documents are deleted
            Navigator.pop(context);
            break;
          default:
            break;
        }
      });
    });
  }

  @override
  void dispose() {
    callStreamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Call has been made'),
            MaterialButton(
                color: Colors.red,
                child: Icon(
                  Icons.call_end,
                  color: Colors.white,
                ),
                onPressed: () {
                  _callMethod.endCall(call: widget.call);
                  Navigator.pop(context);
                }),
          ],
        ),
      ),
    );
  }
}
