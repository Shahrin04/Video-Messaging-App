import 'package:flutter/material.dart';
import 'package:skype_clone/resource/firebase_repository.dart';
import 'package:skype_clone/utils/Utils.dart';
import 'package:skype_clone/utils/universal_variables.dart';
import 'package:skype_clone/widgets/appBar.dart';
import 'package:skype_clone/widgets/customTile.dart';

class ChatListScreen extends StatefulWidget {
  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

final FirebaseRepository _repository = FirebaseRepository();

class _ChatListScreenState extends State<ChatListScreen> {
  String userId;
  String initials;
  String image;

  @override
  void initState() {
    _repository.getCurrentUser().then((user) {
      setState(() {
        userId = user.uid;
        image = user.photoUrl;
        initials = Utils.getInitials(user.name);
      });
    });
  }

  CustomAppBar customAppBar(BuildContext context) {
    return CustomAppBar(
      leading: IconButton(
          icon: Icon(
            Icons.notifications,
            color: Colors.white,
          ),
          onPressed: () {}),
      title: UserCircle(initials),
      centerTitle: true,
      actions: [
        IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: ()=> Navigator.pushNamed(context, '/search_screen')),
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
    return userId == null || initials == null
        ? Container()
        : Scaffold(
            backgroundColor: UniversalVariables.blackColor,
            appBar: customAppBar(context),
            floatingActionButton: NewChatButton(),
            body: ChatListContainer(userId, image),
          );
  }
}

class ChatListContainer extends StatefulWidget {
  final String userId;
  final String image;

  ChatListContainer(this.userId, this.image);

  @override
  _ChatListContainerState createState() => _ChatListContainerState();
}

class _ChatListContainerState extends State<ChatListContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
          padding: EdgeInsets.all(10),
          itemCount: 2,
          itemBuilder: (context, index) {
            return CustomTile(
              mini: false,
              onTap: () {},
              title: Text(
                'Shahrin Hasan',
                style: TextStyle(color: Colors.white, fontSize: 19),
              ),
              subtitle: Text(
                'Hello',
                style: TextStyle(
                    color: UniversalVariables.greyColor, fontSize: 19),
              ),
              leading: Container(
                constraints: BoxConstraints(maxHeight: 60, maxWidth: 60),
                child: Stack(
                  children: [
                    CircleAvatar(
                      backgroundColor: UniversalVariables.greyColor,
                      maxRadius: 30,
                      backgroundImage: NetworkImage(widget.image),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        height: 13,
                        width: 13,
                        decoration: BoxDecoration(
                            color: UniversalVariables.onlineDotColor,
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: UniversalVariables.blackColor,
                                width: 2)),
                      ),
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }
}

class UserCircle extends StatelessWidget {
  String name;

  UserCircle(this.name);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: UniversalVariables.separatorColor,
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Text(
              name.toUpperCase(),
              style: TextStyle(
                  color: UniversalVariables.lightBlueColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 13),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              height: 12,
              width: 12,
              decoration: BoxDecoration(
                  color: UniversalVariables.onlineDotColor,
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: UniversalVariables.blackColor, width: 2)),
            ),
          )
        ],
      ),
    );
  }
}

class NewChatButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
          gradient: UniversalVariables.fabGradient, shape: BoxShape.circle),
      child: Icon(
        Icons.edit,
        color: Colors.white,
        size: 25,
      ),
    );
  }
}
