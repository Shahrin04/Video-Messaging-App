import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skype_clone/model_class/user_model.dart';
import 'package:skype_clone/utils/universal_variables.dart';
import 'package:skype_clone/widgets/appBar.dart';

class ChatScreen extends StatefulWidget {
  final UserModel receiver;

  ChatScreen(this.receiver);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController _textEditingController = TextEditingController();
  bool isWriting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      appBar: customAppBar(context),
      body: Column(
        children: [
          chatControls(),
        ],
      ),
    );
  }

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
          Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
                gradient: UniversalVariables.fabGradient,
                shape: BoxShape.circle),
            child: Icon(Icons.add),
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
                      onPressed: () {}))
              : Container()
        ],
      ),
    );
  }
}
