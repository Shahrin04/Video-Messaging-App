import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:skype_clone/enum/user_state.dart';
import 'package:skype_clone/model_class/user_model.dart';
import 'package:skype_clone/resource/firebase_repository.dart';
import 'package:skype_clone/utils/Utils.dart';
import 'package:skype_clone/utils/universal_variables.dart';

class DotColorIndicator extends StatelessWidget {
  final FirebaseRepository _firebaseRepository = FirebaseRepository();
  final String uid;

  DotColorIndicator({@required this.uid});

  @override
  Widget build(BuildContext context) {
    getColor(int state) {
      switch (Utils.numToState(state)) {
        case UserState.offline:
          return Colors.red;
        case UserState.online:
          return Colors.green;
        default:
          return Colors.orange;
      }
    }

    return Align(
      alignment: Alignment.bottomRight,
      child: StreamBuilder<DocumentSnapshot>(
          stream: _firebaseRepository.gerUserStream(id: uid),
          builder: (context, snapshot) {
            UserModel userModel;

            if (snapshot.hasData && snapshot.data.data() != null) {
              userModel = UserModel.fromMap(snapshot.data.data());
            }

            return Container(
              height: 10,
              width: 10,
              margin: EdgeInsets.only(right: 5, top: 5),
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: getColor(userModel?.state)),
            );
          }),
    );
  }
}
