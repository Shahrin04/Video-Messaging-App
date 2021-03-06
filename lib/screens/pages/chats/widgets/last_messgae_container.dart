import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skype_clone/model_class/message.dart';

class LastMessageContainer extends StatelessWidget {
  final stream;

  LastMessageContainer({@required this.stream});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: stream,
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            var docList = snapshot.data.docs;
            if (docList.isNotEmpty) {
              Message message = Message.fromMap(docList.last.data());
              return SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                child: Text(
                  message.message,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              );
            } else {
              return Text(
                'No Message',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              );
            }
          } else {
            return Text(
              '..',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            );
          }
        });
  }
}
