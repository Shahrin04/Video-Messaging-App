import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:skype_clone/constants/strings.dart';
import 'package:skype_clone/enum/view_state.dart';
import 'package:skype_clone/model_class/message.dart';
import 'package:skype_clone/model_class/user_model.dart';
import 'package:skype_clone/provider/image_upload_provider.dart';
import 'package:skype_clone/resource/firebase_repository.dart';
import 'package:skype_clone/screens/call_screen/call_screen.dart';
import 'package:skype_clone/screens/chat_screens/widget/cached_image.dart';
import 'package:skype_clone/utils/Utils.dart';
import 'package:skype_clone/utils/call_utilities.dart';
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
  ImageUploadProvider _imageUploadProvider;
  FirebaseRepository _repository = FirebaseRepository();

  String currentUser;
  UserModel sender;

  TextEditingController _textEditingController = TextEditingController();
  ScrollController _listScrollController = ScrollController();
  FocusNode textFieldFocus = FocusNode();

  bool isWriting = false;
  bool showEmojiPicker = false;

  showKeyboard() => textFieldFocus.requestFocus();

  hideKeyboard() => textFieldFocus.unfocus();

  showEmojiContainer() {
    setState(() {
      showEmojiPicker = true;
    });
  }

  hideEmojiContainer() {
    setState(() {
      showEmojiPicker = false;
    });
  }

  @override
  void initState() {
    super.initState();

    _repository.getCurrentUser().then((UserModel user) {
      setState(() {
        currentUser = user.uid;
        sender =
            UserModel(uid: user.uid, name: user.name, photoUrl: user.photoUrl);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _imageUploadProvider = Provider.of<ImageUploadProvider>(context);
    return Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      appBar: customAppBar(context),
      body: Column(
        children: [
          Flexible(child: messageList()),
          _imageUploadProvider.getViewState == ViewState.LOADING
              ? Container(
                  alignment: Alignment.centerRight,
                  margin: EdgeInsets.only(right: 15),
                  child: CircularProgressIndicator())
              : Container(),
          chatControls(),
          showEmojiPicker
              ? Container(
                  child: emojiContainer(),
                )
              : Container()
        ],
      ),
    );
  }

  emojiContainer() {
    return EmojiPicker(
      bgColor: UniversalVariables.separatorColor,
      indicatorColor: UniversalVariables.blueColor,
      columns: 7,
      rows: 3,
      onEmojiSelected: (emoji, category) {
        setState(() {
          isWriting = true;
        });
        _textEditingController.text = _textEditingController.text + emoji.emoji;
      },
      recommendKeywords: ['happy', 'sad', 'face', 'party'],
      numRecommended: 50,
    );
  }

// Chat Body Start

  Widget messageList() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection(Messages_Collection)
            .doc(currentUser)
            .collection(widget.receiver.uid)
            .orderBy(TimeStamp_Field, descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshots) {
          if (snapshots.data == null) {
            return Center(child: CircularProgressIndicator());
          }

          // SchedulerBinding.instance.addPostFrameCallback((_) {
          //   _listScrollController.animateTo(
          //       _listScrollController.position.minScrollExtent,   //minScrollExtent = it will force to go down
          //       duration: Duration(milliseconds: 250),
          //       curve: Curves.easeInOut);
          // });

          return ListView.builder(
              controller: _listScrollController,
              padding: EdgeInsets.all(10),
              reverse: true,
              itemCount: snapshots.data.docs.length,
              itemBuilder: (context, index) {
                return chatMessageItem(snapshots.data.docs[index]);
              });
        });
  }

  Widget chatMessageItem(DocumentSnapshot snapshot) {
    Message _message = Message.fromMap(snapshot.data());

    return Container(
      margin: EdgeInsets.symmetric(vertical: 15), //distance between messages
      child: Container(
        child: Align(
            alignment: _message.senderId == currentUser
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: _message.senderId == currentUser
                ? senderLayout(_message)
                : receiverLayout(_message)),
      ),
    );
  }

  Widget senderLayout(Message message) {
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
          child: getMessage(message)),
    );
  }

  Widget getMessage(Message message) {
    return message.type != Message_Type_Image
        ? Text(
            message.message,
            style: TextStyle(color: Colors.white, fontSize: 16),
          )
        : message.photoUrl != null
            ? CachedImage(
                url: message.photoUrl,
              )
            : Text('Image is rendering...');
  }

  Widget receiverLayout(Message message) {
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
      child: Padding(padding: EdgeInsets.all(10), child: getMessage(message)),
    );
  }

// Chat Body End

  void pickImage({@required ImageSource source}) async {
    File selectedImage = await Utils.pickImage(source: source);
    _repository.uploadImage(
        image: selectedImage,
        receiverId: widget.receiver.uid,
        senderId: currentUser,
        imageUploadProvider: _imageUploadProvider);
  }

  CustomAppBar customAppBar(BuildContext context) {
    return CustomAppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context)),
        title: Text(widget.receiver.name),
        actions: [
          IconButton(icon: Icon(Icons.video_call), onPressed: () {
            CallUtils.dial(from: sender, to: widget.receiver, context: context);
          }),
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
              child: Stack(alignment: Alignment.centerRight, children: [
            TextField(
              onTap: hideEmojiContainer,
              controller: _textEditingController,
              focusNode: textFieldFocus,
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
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide.none,
                  )),
            ),
            IconButton(
                onPressed: () {
                  if (!showEmojiPicker) {
                    //showing emoji container and hiding keyboard after pressing emoji button
                    showEmojiContainer();
                    hideKeyboard();
                  } else {
                    //otherwise keyboard will show
                    hideEmojiContainer();
                    showKeyboard();
                  }
                },
                icon: Icon(Icons.face)),
          ])),
          isWriting
              ? Container()
              : Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(Icons.record_voice_over)),
          isWriting
              ? Container()
              : GestureDetector(
                  child: Icon(Icons.camera_alt),
                  onTap: () => pickImage(source: ImageSource.camera),
                ),
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
        timeStamp: Timestamp.now());

    setState(() {
      isWriting = false; //to make invisible the send button after pressing it
    });

    _textEditingController.text =
        ""; //clearing box text after sending the message

    _repository.addMessageToDB(_message, sender, widget.receiver);

    //hiding keyboard and emoji container after pressing send Button
    if (showEmojiPicker) {
      hideEmojiContainer();
    }
    hideKeyboard();
    //hiding keyboard and emoji container after pressing send Button
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
                  ModalTile(
                      title: 'Media',
                      subTitle: 'Share Photo and Video',
                      icon: Icons.image,
                    onTap: ()=> pickImage(source: ImageSource.gallery),
                  ),
                  ModalTile(
                      title: 'File', subTitle: 'Share Files', icon: Icons.tab),
                  ModalTile(
                      title: 'Contact',
                      subTitle: 'Share Contacts',
                      icon: Icons.contacts),
                  ModalTile(
                      title: 'Location',
                      subTitle: 'Share a Location',
                      icon: Icons.add_location),
                  ModalTile(
                      title: 'Schedule Call',
                      subTitle: 'Arrange a skype call and get reminders',
                      icon: Icons.schedule),
                  ModalTile(
                      title: 'Create Poll',
                      subTitle: 'Share polls',
                      icon: Icons.poll),
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
  final Function onTap;

  ModalTile(
      {@required this.title,
      @required this.subTitle,
      @required this.icon,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 15,
      ),
      child: CustomTile(
          onTap: onTap,
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
