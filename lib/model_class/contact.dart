import 'package:cloud_firestore/cloud_firestore.dart';

class Contact {
  String uid;
  Timestamp addedOn;

  Contact({this.uid, this.addedOn});

  Map toMap(Contact contact) {
    var map = Map<String, dynamic>();
    map['uid'] = contact.uid;
    map['added_On'] = contact.addedOn;

    return map;
  }

  Contact.fromMap(Map<String, dynamic> map) {
    this.uid = map['uid'];
    this.addedOn = map['added_On'];
  }
}
