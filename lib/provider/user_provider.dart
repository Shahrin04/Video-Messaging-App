import 'package:flutter/material.dart';
import 'package:skype_clone/model_class/user_model.dart';
import 'package:skype_clone/resource/firebase_repository.dart';

class UserProvider with ChangeNotifier{
  UserModel _user;
  UserModel get getUser => _user;
  FirebaseRepository _firebaseRepository = FirebaseRepository();

  void refreshUser()async{
    UserModel userModel = await _firebaseRepository.getUserDetails();
    _user = userModel;
    notifyListeners();
  }

}