import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skype_clone/model_class/contact.dart';
import 'package:skype_clone/model_class/user_model.dart';
import 'package:skype_clone/resource/firebase_repository.dart';
import 'package:skype_clone/screens/call_screen/pickup/pickup_layout.dart';
import 'package:skype_clone/screens/pages/widgets/contact_view.dart';
import 'package:skype_clone/screens/pages/widgets/new_chat_button.dart';
import 'package:skype_clone/screens/pages/widgets/quiet_box.dart';
import 'package:skype_clone/screens/pages/widgets/user_circle.dart';
import 'package:skype_clone/utils/Utils.dart';
import 'package:skype_clone/utils/universal_variables.dart';
import 'package:skype_clone/widgets/appBar.dart';
import 'package:skype_clone/widgets/customTile.dart';

class ChatListScreen extends StatelessWidget {
  CustomAppBar customAppBar(BuildContext context) {
    return CustomAppBar(
      leading: IconButton(
          icon: Icon(
            Icons.notifications,
            color: Colors.white,
          ),
          onPressed: () {}),
      title: UserCircle(),
      centerTitle: true,
      actions: [
        IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: () => Navigator.pushNamed(context, '/search_screen')),
        IconButton(
            icon: Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
            onPressed: () {}),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return PickupLayout(
      scaffold: Scaffold(
        backgroundColor: UniversalVariables.blackColor,
        appBar: customAppBar(context),
        floatingActionButton: NewChatButton(),
        body: ChatListContainer(),
      ),
    );
  }
}

class ChatListContainer extends StatelessWidget {
  final FirebaseRepository _firebaseRepository = FirebaseRepository();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel>(context);

    return Container(
      child: StreamBuilder<QuerySnapshot>(
          stream: _firebaseRepository.fetchContacts(userId: user.uid),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var docList = snapshot.data.docs;
              if (docList.isEmpty) {
                return QuietBox();
              }
              return ListView.builder(
                  padding: EdgeInsets.all(10),
                  itemCount: docList.length,
                  itemBuilder: (context, index) {
                    Contact contact = Contact.fromMap(docList[index].data());
                    return ContactView(contact);
                  });
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
