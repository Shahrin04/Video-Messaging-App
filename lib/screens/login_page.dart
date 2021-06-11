import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:skype_clone/model_class/user_model.dart';
import 'package:skype_clone/resource/firebase_repository.dart';
import 'package:skype_clone/utils/universal_variables.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  FirebaseRepository _repository = FirebaseRepository();
  bool isLoading = false;

  // UserModel userModel = UserModel();

  @override
  Widget build(BuildContext context) {
    //_repository.signOut();
    return Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      body: Shimmer.fromColors(
        baseColor: Colors.white,
        highlightColor: UniversalVariables.senderColor,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                padding: EdgeInsets.all(35),
                onPressed: () async {
                  try {
                    setState(() {
                      isLoading = true;
                    });

                    _repository.signIn().then((value) => isLoading=false);
                    
                  } catch (e) {
                    print('Login Button error: ${e.toString()}');
                  }
                },
                child: Text(
                  'Login',
                  style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 25,
                      letterSpacing: 1.2),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              isLoading ? CircularProgressIndicator() : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
