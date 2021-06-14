import 'package:firebase_auth/firebase_auth.dart';
import 'package:skype_clone/model_class/message.dart';
import 'package:skype_clone/model_class/user_model.dart';
import 'package:skype_clone/resource/firebase_methods.dart';

class FirebaseRepository {
  FirebaseMethod _firebaseMethod = FirebaseMethod();

  //getting current user
  //Future<UserModel> getCurrentUser() => _firebaseMethod.getCurrentUser();
  Future<UserModel> getCurrentUser() => _firebaseMethod.getCurrentUser();

  //SignIn and create database in firestore
  Future signIn() => _firebaseMethod.signIn();

  //fetch all user
  Future<List<UserModel>> fetchAllUsers (UserModel currentUser) => _firebaseMethod.fetchAllUsers(currentUser);

  //Update Message to DB
  Future<void> addMessageToDB(Message message, UserModel sender, UserModel receiver) => _firebaseMethod.addMessageToDB(
      message, sender, receiver);

  //SignOut
  Future<void> signOut() => _firebaseMethod.signOut();
}