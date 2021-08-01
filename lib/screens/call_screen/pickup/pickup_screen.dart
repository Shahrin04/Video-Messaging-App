import 'package:flutter/material.dart';
import 'package:skype_clone/config/permissions.dart';
import 'package:skype_clone/constants/strings.dart';
import 'package:skype_clone/model_class/call.dart';
import 'package:skype_clone/model_class/log.dart';
import 'package:skype_clone/resource/call_method.dart';
import 'package:skype_clone/resource/local_db/db/hive_methods.dart';
import 'package:skype_clone/resource/local_db/repository/log_repository.dart';
import 'package:skype_clone/screens/call_screen/call_screen.dart';
import 'package:skype_clone/screens/wrapper.dart';

class PickUpScreen extends StatefulWidget {
  final Call call;

  PickUpScreen({this.call});

  @override
  _PickUpScreenState createState() => _PickUpScreenState();
}

class _PickUpScreenState extends State<PickUpScreen> {
  final CallMethod _callMethod = CallMethod();
  bool isCallMissed = true;

  addToLocalStorage({@required String callStatus}) {
    Log log = Log(
        callerName: widget.call.callerName,
        callerPic: widget.call.callerPhoto,
        receiverName: widget.call.receiverName,
        receiverPic: widget.call.receiverPhoto,
        timeStamp: DateTime.now().toString(),
        callStatus: callStatus);

    LogRepository.addLogs(log);
  }

  @override
  void dispose() {
    if (isCallMissed) {
      addToLocalStorage(callStatus: CALL_STATUS_MISSED);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Wrapper()),
          (Route<dynamic> route) => false);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 100),
        child: Column(
          children: [
            Text(
              'Incoming',
              style: TextStyle(fontSize: 30),
            ),
            SizedBox(
              height: 50,
            ),
            Image.network(
              widget.call.callerPhoto,
              height: 150,
              width: 150,
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              widget.call.callerName,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(
              height: 75,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    icon: Icon(
                      Icons.call_end,
                      color: Colors.red,
                    ),
                    onPressed: () async {
                      isCallMissed = false;
                      addToLocalStorage(callStatus: CALL_STATUS_RECEIVED);
                      await _callMethod.endCall(call: widget.call);
                    }),
                SizedBox(
                  width: 25,
                ),
                IconButton(
                    icon: Icon(
                      Icons.call,
                      color: Colors.green,
                    ),
                    onPressed: () async {
                      isCallMissed = false;
                      addToLocalStorage(callStatus: CALL_STATUS_RECEIVED);
                      await Permissions.cameraAndMicrophonePermissionsGranted()
                          ? Navigator.push(context, MaterialPageRoute(
                          builder: (context) => CallScreen(call: widget.call,)))
                          : {};
                    }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
