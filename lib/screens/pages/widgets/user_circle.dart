import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skype_clone/model_class/user_model.dart';
import 'package:skype_clone/utils/universal_variables.dart';


class UserCircle extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel>(context);
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
              user.name.toUpperCase(),
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