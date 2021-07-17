import 'package:flutter/material.dart';
import 'package:skype_clone/utils/universal_variables.dart';

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