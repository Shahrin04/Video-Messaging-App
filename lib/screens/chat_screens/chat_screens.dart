import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:skype_clone/model_class/message.dart';
import 'package:skype_clone/model_class/user_model.dart';
import 'package:skype_clone/resource/firebase_repository.dart';
import 'package:skype_clone/utils/universal_variables.dart';
import 'package:skype_clone/widgets/appBar.dart';
import 'package:skype_clone/widgets/customTile.dart';

class ChatScreen extends StatefulWidget {
  final UserModel receiver;

  ChatScreen(this.receiver);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  FirebaseRepository _repository = FirebaseRepository();

  String currentUser;
  UserModel sender;

  TextEditingController _textEditingController = TextEditingController();
  bool isWriting = false;

  @override
  void initState() {
    super.initState();

    _repository.getCurrentUser().then((UserModel user) {
      setState(() {
        currentUser = user.uid;
        print('microphone testing: ${currentUser.toString()}');
        print('microphone testing: ${widget.receiver.uid.toString()}');
        sender =
            UserModel(uid: user.uid, name: user.name, photoUrl: user.photoUrl);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      appBar: customAppBar(context),
      body: Column(
        children: [
          Flexible(child: messageList()),
          chatControls(),
        ],
      ),
    );
  }

// Chat Body Start
  Widget messageList() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('messages')
            .doc(currentUser)
            .collection(widget.receiver.uid)
            .orderBy('timeStamp', descending: false)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshots) {
          if(snapshots.data==null){
            return Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
              padding: EdgeInsets.all(10),
              itemCount: snapshots.data.docs.length,
              itemBuilder: (context, index) {
                return chatMessageItem(snapshots.data.docs[index]);
              });
        });
  }

  Widget chatMessageItem(DocumentSnapshot snapshot) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15), //distance between messages
      child: Container(
        child: Align(
            alignment: snapshot['senderId'] == currentUser ? Alignment.centerRight : Alignment.centerLeft,
            child: snapshot['senderId'] == currentUser ? senderLayout(snapshot) : receiverLayout(snapshot)
        ),
      ),
    );
  }

  Widget senderLayout(DocumentSnapshot snapshot) {
    Radius messageRadius = Radius.circular(10);

    return Container(
      margin: EdgeInsets.only(top: 12),
      constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width *
              0.65 //it will take maximum 65% width of the screen
          ),
      decoration: BoxDecoration(
        color: UniversalVariables.senderColor,
        borderRadius: BorderRadius.only(
          topLeft: messageRadius,
          topRight: messageRadius,
          bottomLeft: messageRadius,
        ),
      ),
      child: Padding(
          padding: EdgeInsets.all(10), //padding or space around text messages
          child: getMessage(snapshot)),
    );
  }

  Widget getMessage(DocumentSnapshot snapshot) {
    return Text(
      snapshot['message'],
      style: TextStyle(color: Colors.white, fontSize: 16),
    );
  }

  Widget receiverLayout(DocumentSnapshot snapshot) {
    Radius messageRadius = Radius.circular(10);

    return Container(
      margin: EdgeInsets.only(top: 12),
      constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width *
              0.65 //it will take maximum 65% width of the screen
          ),
      decoration: BoxDecoration(
          color: UniversalVariables.receiverColor,
          borderRadius: BorderRadius.only(
            topRight: messageRadius,
            bottomLeft: messageRadius,
            bottomRight: messageRadius,
          )),
      child: Padding(padding: EdgeInsets.all(10), child: getMessage(snapshot)),
    );
  }

// Chat Body End

  CustomAppBar customAppBar(BuildContext context) {
    return CustomAppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context)),
        title: Text(widget.receiver.name),
        actions: [
          IconButton(icon: Icon(Icons.video_call), onPressed: () {}),
          IconButton(icon: Icon(Icons.phone), onPressed: () {}),
        ],
        centerTitle: false);
  }

  Widget chatControls() {
    setWritingTo(bool value) {
      setState(() {
        isWriting = value;
      });
    }

    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => addMediaModal(context),
            child: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  gradient: UniversalVariables.fabGradient,
                  shape: BoxShape.circle),
              child: Icon(Icons.add),
            ),
          ),
          SizedBox(
            width: 5,
          ),
          Expanded(
              child: TextField(
            controller: _textEditingController,
            style: TextStyle(color: Colors.white),
            onChanged: (value) {
              (value.length > 0 && value.trim() != "")
                  ? setWritingTo(true)
                  : setWritingTo(false);
            },
            decoration: InputDecoration(
                hintText: 'Type a message',
                hintStyle: TextStyle(color: UniversalVariables.greyColor),
                contentPadding: EdgeInsets.symmetric(horizontal: 20),
                filled: true,
                fillColor: UniversalVariables.separatorColor,
                suffixIcon:
                    GestureDetector(onTap: () {}, child: Icon(Icons.face)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide.none,
                )),
          )),
          isWriting
              ? Container()
              : Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(Icons.record_voice_over)),
          isWriting ? Container() : Icon(Icons.camera_alt),
          isWriting
              ? Container(
                  margin: EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                    gradient: UniversalVariables.fabGradient,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                      icon: Icon(
                        Icons.send,
                        size: 15,
                      ),
                      onPressed: () => sendMessage()))
              : Container()
        ],
      ),
    );
  }

  sendMessage() {
    var text = _textEditingController.text;

    Message _message = Message(
        senderId: sender.uid,
        receiverId: widget.receiver.uid,
        type: 'text',
        message: text,
        timeStamp: FieldValue.serverTimestamp());

    setState(() {
      isWriting = false; //to make invisible the send button after pressing it
    });

    _repository.addMessageToDB(_message, sender, widget.receiver).whenComplete(
        () => _textEditingController
            .clear()); //clearing box text after sending the message
  }

  addMediaModal(BuildContext context) {
    showModalBottomSheet(
        elevation: 0,
        backgroundColor: UniversalVariables.blackColor,
        context: context,
        builder: (context) {
          return Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: Row(
                  children: [
                    IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () => Navigator.pop(context)),
                    Expanded(
                        child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Content and tools',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
                  ],
                ),
              ),
              Flexible(
                  child: ListView(
                children: [
                  ModalTile('Media', 'Share Photo and Video', Icons.image),
                  ModalTile('File', 'Share Files', Icons.tab),
                  ModalTile('Contact', 'Share Contacts', Icons.contacts),
                  ModalTile('Location', 'Share a Location', Icons.add_location),
                  ModalTile('Schedule Call',
                      'Arrange a skype call and get reminders', Icons.schedule),
                  ModalTile('Create Poll', 'Share polls', Icons.poll),
                ],
              )),
            ],
          );
        });
  }
}

class ModalTile extends StatelessWidget {
  final String title;
  final String subTitle;
  final IconData icon;

  ModalTile(this.title, this.subTitle, this.icon);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 15,
      ),
      child: CustomTile(
          mini: false,
          leading: Container(
            margin: EdgeInsets.only(right: 10),
            padding: EdgeInsets.all(10), //distance or space around icon
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: UniversalVariables.receiverColor),
            child: Icon(
              icon,
              color: UniversalVariables.greyColor,
              size: 38,
            ),
          ),
          title: Text(
            title,
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
          ),
          subtitle: Text(
            subTitle,
            style: TextStyle(color: UniversalVariables.greyColor, fontSize: 14),
          )),
    );
  }
}
