import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:skype_clone/model_class/user_model.dart';
import 'package:skype_clone/utils/Utils.dart';

class FirebaseMethod {
  static final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();

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

  //getting current user
  // Future<User> getCurrentUser() async {
  //   User user;
  //   user = _auth.currentUser;
  //   return user;
  // }
  Future<UserModel> getCurrentUser() async {
    User user;
    user = _auth.currentUser;
    return _userFromUserCredential(user);
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

        fireStore.collection('users').doc(user.uid).set({
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

  //fetch all user
  Future<List<UserModel>> fetchAllUsers(UserModel currentUser) async {
    try {
      List<UserModel> userList = List<UserModel>();
      QuerySnapshot snapshot = await fireStore.collection('users').get();
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

  // Future<List<UserModel>> fetchAllUsers (UserModel currentUser) async {
  //   try {
  //     List<UserModel> userList = List<UserModel>();
  //     QuerySnapshot querySnapshot = await fireStore.collection('users').get();
  //
  //     for (var i = 0; i < querySnapshot.docs.length; i++) {
  //       if (querySnapshot.docs[i].id != currentUser.uid) {
  //         userList.add(UserModel.fromMap(querySnapshot.docs[i].data()));
  //       }
  //     }
  //     return userList;
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }

  //signOut
  Future<void> signOut() async {
    _googleSignIn.disconnect();
    _googleSignIn.signOut();
    _auth.signOut();
  }
}
