import 'package:flutter/material.dart';
import 'package:skype_clone/config/permissions.dart';
import 'package:skype_clone/model_class/call.dart';
import 'package:skype_clone/resource/call_method.dart';
import 'package:skype_clone/screens/call_screen/call_screen.dart';

class PickUpScreen extends StatelessWidget {
  final CallMethod _callMethod = CallMethod();
  final Call call;

  PickUpScreen({this.call});

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
              call.callerPhoto,
              height: 150,
              width: 150,
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              call.callerName,
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
                      await _callMethod.endCall(call: call);
                    }),
                SizedBox(
                  width: 25,
                ),
                IconButton(
                    icon: Icon(
                      Icons.call,
                      color: Colors.green,
                    ),
                    onPressed: () async => await Permissions
                            .cameraAndMicrophonePermissionsGranted()
                        ? Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CallScreen()))
                        : {}),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
