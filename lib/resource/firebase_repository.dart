import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:skype_clone/enum/user_state.dart';
import 'package:skype_clone/model_class/message.dart';
import 'package:skype_clone/model_class/user_model.dart';
import 'package:skype_clone/provider/image_upload_provider.dart';
import 'package:skype_clone/resource/firebase_methods.dart';

class FirebaseRepository {
  FirebaseMethod _firebaseMethod = FirebaseMethod();

  //getting current user
  //Future<UserModel> getCurrentUser() => _firebaseMethod.getCurrentUser();
  Future<UserModel> getCurrentUser() => _firebaseMethod.getCurrentUser();

  //getting all user by their id
  Future<UserModel> getUserDetailsById(id) => _firebaseMethod.getUserDetailsById(id);

  //SignIn and create database in firestore
  Future signIn() => _firebaseMethod.signIn();

  //fetch all user
  Future<List<UserModel>> fetchAllUsers(UserModel currentUser) =>
      _firebaseMethod.fetchAllUsers(currentUser);

  //get User Details for call purpose
  Future<UserModel> getUserDetails() => _firebaseMethod.getUserDetails();

  //Update Message to DB
  Future<void> addMessageToDB(
          Message message, UserModel sender, UserModel receiver) =>
      _firebaseMethod.addMessageToDB(message, sender, receiver);

  //SignOut
  Future<void> signOut() => _firebaseMethod.signOut();

  //upload Image
  void uploadImage(
          {@required File image,
          @required String receiverId,
          @required String senderId,
          @required ImageUploadProvider imageUploadProvider}) =>
      _firebaseMethod.uploadImage(
          image, receiverId, senderId, imageUploadProvider);

  //fetch contact list as Stream
  Stream<QuerySnapshot> fetchContacts({String userId}) => _firebaseMethod.fetchContacts(userId: userId);

  //fetch last message between sender and receiver
  Stream<QuerySnapshot> fetchLastMessageBetween(
      {String senderId, String receiverId}) => _firebaseMethod.fetchLastMessageBetween(senderId: senderId, receiverId: receiverId);

  //set user state
  void setUserState({@required String uid, @required UserState userState}) => _firebaseMethod.setUserState(uid: uid, userState: userState);

  Stream<DocumentSnapshot> gerUserStream({@required String id}) => _firebaseMethod.gerUserStream(id: id);
}
