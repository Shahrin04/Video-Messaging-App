import 'package:firebase_auth/firebase_auth.dart';
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

  //SignOut
  Future<void> signOut() => _firebaseMethod.signOut();
}