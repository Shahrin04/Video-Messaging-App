import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skype_clone/enum/user_state.dart';
import 'package:skype_clone/model_class/user_model.dart';
import 'package:skype_clone/resource/firebase_repository.dart';
import 'package:skype_clone/screens/chat_screens/widget/cached_image.dart';
import 'package:skype_clone/screens/pages/chats/widgets/shimmering_logo.dart';
import 'package:skype_clone/screens/wrapper.dart';
import 'package:skype_clone/widgets/appBar.dart';

class UserDetailContainer extends StatelessWidget {
  final FirebaseRepository _firebaseRepository = FirebaseRepository();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    signOut() async {
      bool isLoggedOut = await _firebaseRepository.signOut();
      if (isLoggedOut) {
        // set userState to offline as the user logs out'
        _firebaseRepository.setUserState(
            uid: _auth.currentUser.uid, userState: UserState.offline);
        // move the user to login screen
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => Wrapper()),
            (Route<dynamic> route) => false);
      }
    }

    return Container(
      margin: EdgeInsets.only(top: 25),
      child: Column(
        children: [
          CustomAppBar(
              leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  onPressed: () => Navigator.maybePop(context)),
              title: ShimmeringLogo(),
              actions: [
                FlatButton(
                    onPressed: () => signOut(),
                    child: Text(
                      'Sign Out',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ))
              ],
              centerTitle: true),
          UserDetailsBody()
        ],
      ),
    );
  }
}

class UserDetailsBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel>(context);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Row(
        children: [
          CachedImage(
            user?.photoUrl ?? '',
            isRound: true,
            radius: 50,
          ),
          SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user?.name ?? '',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                user?.email ?? '',
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
            ],
          )
        ],
      ),
    );
  }
}
