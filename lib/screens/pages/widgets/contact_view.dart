import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skype_clone/model_class/contact.dart';
import 'package:skype_clone/model_class/user_model.dart';
import 'package:skype_clone/resource/firebase_repository.dart';
import 'package:skype_clone/screens/chat_screens/chat_screens.dart';
import 'package:skype_clone/screens/chat_screens/widget/cached_image.dart';
import 'package:skype_clone/screens/pages/widgets/dot_color_indicator.dart';
import 'package:skype_clone/screens/pages/widgets/last_messgae_container.dart';
import 'package:skype_clone/utils/universal_variables.dart';
import 'package:skype_clone/widgets/customTile.dart';

class ContactView extends StatelessWidget {
  final Contact contact;
  final FirebaseRepository _firebaseRepository = FirebaseRepository();

  ContactView(this.contact);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModel>(
        future: _firebaseRepository.getUserDetailsById(contact.uid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserModel user = snapshot.data;
            return ViewLayout(
              contact: user,
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }
}

class ViewLayout extends StatelessWidget {
  final UserModel contact;
  final FirebaseRepository _firebaseRepository = FirebaseRepository();

  ViewLayout({@required this.contact});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel>(context);

    return CustomTile(
      mini: false,
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (context) => ChatScreen(contact))),
      title: Text(
        contact?.name ?? '..',
        //(contact != null ? contact.name:null) != null ? contact.name:'..'
        style: TextStyle(color: Colors.white, fontSize: 19),
      ),
      subtitle: LastMessageContainer(
          stream: _firebaseRepository.fetchLastMessageBetween(
              senderId: user.uid, receiverId: contact.uid)),
      leading: Container(
        constraints: BoxConstraints(maxHeight: 60, maxWidth: 60),
        child: Stack(
          children: [
            CachedImage(
              contact.photoUrl,
              radius: 80,
              isRound: true,
            ),
            DotColorIndicator(uid: contact.uid)
          ],
        ),
      ),
    );
  }
}
