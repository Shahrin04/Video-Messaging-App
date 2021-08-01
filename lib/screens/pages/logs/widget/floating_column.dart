import 'package:flutter/material.dart';
import 'package:skype_clone/utils/universal_variables.dart';

class FloatingColumn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: UniversalVariables.fabGradient,
          ),
          child: Icon(
            Icons.dialpad,
            color: Colors.white,
            size: 25,
          ),
        ),
        SizedBox(height: 15,),
        Container(
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: UniversalVariables.blackColor,
            shape: BoxShape.circle,
            border: Border.all(
              width: 2,
              color: UniversalVariables.gradientColorEnd
            )
          ),
          child: Icon(
            Icons.add_call,
            color: UniversalVariables.gradientColorEnd,
            size: 25,
          ),
        ),
      ],
    );
  }
}
