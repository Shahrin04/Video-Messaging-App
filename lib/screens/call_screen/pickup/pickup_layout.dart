import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:skype_clone/model_class/call.dart';
import 'package:skype_clone/model_class/user_model.dart';
import 'package:skype_clone/provider/user_provider.dart';
import 'package:skype_clone/resource/call_method.dart';
import 'package:provider/provider.dart';
import 'package:skype_clone/screens/call_screen/pickup/pickup_screen.dart';

class PickupLayout extends StatelessWidget {
  final Widget scaffold;
  final CallMethod callMethod = CallMethod();

  PickupLayout({@required this.scaffold});

  @override
  Widget build(BuildContext context) {
    //final UserProvider user = Provider.of<UserProvider>(context);
    final user = Provider.of<UserModel>(context);

    return user!=null
      //(user != null && user.getUser != null)
        ? StreamBuilder<DocumentSnapshot>(
            stream: callMethod.callStream(uid: user.uid),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data.data() != null) {
                Call call = Call.fromMap(snapshot.data.data());
                if (!call.hasDialed) {
                  return PickUpScreen(call: call,);
                } else {
                  return scaffold;
                }
              } else {
                return scaffold;
              }
            })
        : Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
  }
}