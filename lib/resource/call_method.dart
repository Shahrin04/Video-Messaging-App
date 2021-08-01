import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:skype_clone/constants/strings.dart';
import 'package:skype_clone/model_class/call.dart';

class CallMethod {
  final CollectionReference callReference =
      FirebaseFirestore.instance.collection(Call_Collection);

  Stream<DocumentSnapshot> callStream({String uid}) =>
      callReference.doc(uid).snapshots();

  Future<bool> makeCall({Call call}) async {
    try {
      call.hasDialed = true;
      Map<String, dynamic> hasDialledMap = call.toMap(call);

      call.hasDialed = false;
      Map<String, dynamic> hasNotDialledMap = call.toMap(call);

      await callReference.doc(call.callerId).set(hasDialledMap);
      await callReference.doc(call.receiverId).set(hasNotDialledMap);

      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> endCall({Call call}) async {
    try {
      await callReference.doc(call.receiverId).delete();
      await callReference.doc(call.callerId).delete();

      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }
}
