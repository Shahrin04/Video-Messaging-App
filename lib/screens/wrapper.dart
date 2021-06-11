import 'package:flutter/material.dart';
import 'package:skype_clone/model_class/user_model.dart';
import 'package:skype_clone/resource/firebase_repository.dart';
import 'package:skype_clone/screens/login_page.dart';
import 'package:provider/provider.dart';

import 'home_page.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel>(context);

    if(user==null){
      return LoginPage();
    }else{
      return Home();
    }
  }
}
