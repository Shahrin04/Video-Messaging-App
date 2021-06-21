import 'package:flutter/material.dart';
import 'package:skype_clone/model_class/call.dart';
import 'package:skype_clone/resource/call_method.dart';

class CallScreen extends StatefulWidget {
  final Call call;

  CallScreen({@required this.call});

  @override
  _CallScreenState createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  final CallMethod _callMethod = CallMethod();

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
