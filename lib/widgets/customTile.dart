import 'package:flutter/material.dart';
import 'package:skype_clone/utils/universal_variables.dart';

class CustomTile extends StatelessWidget {
  final Widget leading;
  final Widget title;
  final Widget subtitle;
  final Widget icon;
  final Widget trailing;
  final bool mini;
  final EdgeInsets margin;
  final GestureTapCallback onTap;
  final GestureLongPressCallback onLongPress;

  const CustomTile(
      {Key key,
      @required this.leading,
      @required this.title,
      @required this.subtitle,
      this.icon,
      this.trailing,
      this.mini = false,
      this.margin = const EdgeInsets.all(0),
      this.onTap,
      this.onLongPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        margin: margin,
        padding: EdgeInsets.symmetric(horizontal: mini ? 10 : 0),
        child: Row(
          children: [
            leading ?? Container(),
            Expanded(
                child: Container(
              margin: EdgeInsets.only(left: mini ? 10 : 15),
              padding: EdgeInsets.symmetric(vertical: mini ? 3 : 20),
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                color: UniversalVariables.separatorColor,
                width: 1,
                //style: BorderStyle.solid
              ))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      title,
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [icon ?? Container(), subtitle],
                      )
                    ],
                  ),
                  trailing ?? Container(),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}
