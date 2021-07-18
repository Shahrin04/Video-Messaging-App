import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:path_provider/path_provider.dart';
import 'package:skype_clone/constants/strings.dart';
import 'package:skype_clone/enum/user_state.dart';
import 'package:skype_clone/model_class/contact.dart';
import 'package:skype_clone/model_class/message.dart';
import 'package:skype_clone/model_class/user_model.dart';
import 'package:skype_clone/provider/image_upload_provider.dart';
import 'package:skype_clone/utils/Utils.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseMethod {
  static final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  static final CollectionReference _userCollections =
      fireStore.collection(Users_Collection);
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();

  Reference _storageReference;

  //create user object based on User Credential
  UserModel _userFromUserCredential(User user) {
    return user != null
        ? UserModel(
            uid: user.uid,
            email: user.email,
            name: user.displayName,
            photoUrl: user.photoURL,
            phoneNumber: user.phoneNumber)
        : null;
  }

  //auth change user stream
  Stream<UserModel> get user {
    return _auth.authStateChanges().map(_userFromUserCredential);
  }

  ////////////// auth methods starts ///////////////////////
  Future<UserModel> getCurrentUser() async {
    User user;
    user = _auth.currentUser;
    return _userFromUserCredential(user);
  }

  Future<UserModel> getUserDetails() async {
    User user = _auth.currentUser;
    DocumentSnapshot documentSnapshot =
        await _userCollections.doc(user.uid).get();
    return UserModel.fromMap(documentSnapshot.data());
  }

  //signIn with Google Account
  Future signIn() async {
    try {
      GoogleSignInAccount _signInAccount = await _googleSignIn.signIn();
      GoogleSignInAuthentication _signInAuthentication =
          await _signInAccount.authentication;

      AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: _signInAuthentication.accessToken,
          idToken: _signInAuthentication.idToken);

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      User user = userCredential.user;

      //add User Data in FireStore
      if (user != null) {
        String userName = Utils.getUserName(user.email);

        fireStore.collection(Users_Collection).doc(user.uid).set({
          'uid': user.uid,
          'email': user.email,
          'name': user.displayName,
          'userName': userName,
          'photoUrl': user.photoURL,
          'phoneNumber': user.phoneNumber,
        });
      }

      return _userFromUserCredential(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //signOut
  Future<bool> signOut() async {
    try {
      _googleSignIn.disconnect();
      _googleSignIn.signOut();
      _auth.signOut();
      return true;
    } on Exception catch (e) {
      print(e.toString());
      return false;
    }
  }

  //fetch all user
  Future<List<UserModel>> fetchAllUsers(UserModel currentUser) async {
    try {
      List<UserModel> userList = List<UserModel>();
      QuerySnapshot snapshot =
          await fireStore.collection(Users_Collection).get();
      for (var i = 0; i < snapshot.docs.length; i++) {
        if (snapshot.docs[i].id != currentUser.uid) {
          userList.add(UserModel.fromMap(snapshot.docs[i].data()));
        }
      }
      return userList;
    } catch (e) {
      print(e.toString());
    }
  }

  //set user state
  void setUserState({@required String uid, @required UserState userState}) {
    int stateNum = Utils.stateToNum(userState);

    fireStore.collection(Users_Collection).doc(uid).update({'state': stateNum});
  }

  Stream<DocumentSnapshot> gerUserStream({@required String id}) =>
      fireStore.collection(Users_Collection).doc(id).snapshots();

  ////////////// auth methods ends ///////////////////////

  Future<UserModel> getUserDetailsById(id) async {
    try {
      DocumentSnapshot documentSnapshot =
          await fireStore.collection(Users_Collection).doc(id).get();
      return UserModel.fromMap(documentSnapshot.data());
    } on Exception catch (e) {
      print(e.toString());
      return null;
    }
  }

  /////////////chat Methods////////////////////////
  Future<void> addMessageToDB(
      Message message, UserModel sender, UserModel receiver) async {
    try {
      var map = message.toMap();

      await fireStore
          .collection(Messages_Collection)
          .doc(message.senderId)
          .collection(message.receiverId)
          .add(map);

      addToContacts(senderId: message.senderId, receiverId: message.receiverId);

      await fireStore
          .collection(Messages_Collection)
          .doc(message.receiverId)
          .collection(message.senderId)
          .add(map);
    } catch (e) {
      print(e.toString());
    }
  }

  DocumentReference getContactsDocument({String of, String forContact}) =>
      fireStore
          .collection(Users_Collection)
          .doc(of)
          .collection(Contacts_Collection)
          .doc(forContact);

  addToContacts({String senderId, String receiverId}) async {
    Timestamp currentTime = Timestamp.now();

    await addToSenderContacts(senderId, receiverId, currentTime);
    await addToReceiverContacts(senderId, receiverId, currentTime);
  }

  Future<void> addToSenderContacts(
      String senderId, String receiverId, currentTime) async {
    DocumentSnapshot senderSnapShot =
        await getContactsDocument(of: senderId, forContact: receiverId).get();

    if (!senderSnapShot.exists) {
      //if contact not exist
      Contact receiverContact = Contact(uid: receiverId, addedOn: currentTime);
      var receiverMap = receiverContact.toMap(receiverContact);
      await getContactsDocument(of: senderId, forContact: receiverId)
          .set(receiverMap);
    }
  }

  Future<void> addToReceiverContacts(
      String senderId, String receiverId, currentTime) async {
    DocumentSnapshot receiverSnapShot =
        await getContactsDocument(of: receiverId, forContact: senderId).get();

    if (!receiverSnapShot.exists) {
      //if contact not exist
      Contact senderContact = Contact(uid: senderId, addedOn: currentTime);
      var senderMap = senderContact.toMap(senderContact);
      await getContactsDocument(of: receiverId, forContact: senderId)
          .set(senderMap);
    }
  }

  void setImageMsg(String url, String receiverId, String senderId) async {
    Message _message;

    _message = Message.imageMessage(
        senderId, receiverId, 'image', 'IMAGE', Timestamp.now(), url);

    var map = _message.toImageMap();

    await fireStore
        .collection(Messages_Collection)
        .doc(_message.senderId)
        .collection(_message.receiverId)
        .add(map);
    await fireStore
        .collection(Messages_Collection)
        .doc(_message.receiverId)
        .collection(_message.senderId)
        .add(map);
  }

  Stream<QuerySnapshot> fetchContacts({String userId}) => fireStore
      .collection(Users_Collection)
      .doc(userId)
      .collection(Contacts_Collection)
      .snapshots();

  Stream<QuerySnapshot> fetchLastMessageBetween(
          {String senderId, String receiverId}) =>
      fireStore
          .collection(Messages_Collection)
          .doc(senderId)
          .collection(receiverId)
          .orderBy('timeStamp')
          .snapshots();

  /////////////chat Methods////////////////////////

  //upload Image and sending Image
  Future<String> uploadToStorage(File imageFile) async {
    try {
      _storageReference = FirebaseStorage.instance
          .ref()
          .child('${DateTime.now().millisecondsSinceEpoch}');

      UploadTask storageUploadTask = _storageReference.putFile(imageFile);
      var url =
          await storageUploadTask.then((image) => image.ref.getDownloadURL());
      return url;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  void uploadImage(File image, String receiverId, String senderId,
      ImageUploadProvider imageUploadProvider) async {
    imageUploadProvider.setToLoading();

    String url = await uploadToStorage(image);

    imageUploadProvider.setToIdle();

    setImageMsg(url, receiverId, senderId);
  }

//upload Image and sending Image
}
