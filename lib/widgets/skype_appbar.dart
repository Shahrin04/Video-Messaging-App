import 'package:flutter/material.dart';
import 'package:skype_clone/widgets/appBar.dart';

class SkypeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final dynamic title;
  final List<Widget> actions;

  const SkypeAppBar({Key key, @required this.title, @required this.actions})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomAppBar(
        leading: IconButton(
            icon: Icon(
              Icons.notifications,
              color: Colors.white,
            ),
            onPressed: () {}),
        title: title is String
            ? Text(
                title,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              )
            : title,
        actions: actions,
        centerTitle: true);
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + 10);
}
