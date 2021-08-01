import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:skype_clone/enum/user_state.dart';
import 'package:intl/intl.dart';

class Utils {
  static String getUserName(String email) {
    return 'live:${email.split('@')[0]}';
  }

  static String getInitials(String name) {
    List<String> nameSplit = name.split(" ");
    String firstNameInitial = nameSplit[0][0];
    String secondNameInitial = nameSplit[1][0];

    return firstNameInitial + secondNameInitial;
  }

  static Future<File> pickImage({@required ImageSource source}) async {
    PickedFile file = await ImagePicker().getImage(
        source: source,
        maxWidth: 500,
        maxHeight: 500,
        preferredCameraDevice: CameraDevice.rear);
    File selectedImage = File(file.path);
    return selectedImage;
  }

// static Future<File> pickImage({@required ImageSource source}) async {
//   final tempDir = await getTemporaryDirectory();
//   final path = tempDir.path;
//   final rand = Random().nextInt(10000);
//
//   PickedFile file = await ImagePicker().getImage(
//       source: source,
//       maxHeight: 500,
//       maxWidth: 500,
//       preferredCameraDevice: CameraDevice.rear);
//
//   File selectedImage = File(file.path);
//
//   return selectedImage;
// }

  static int stateToNum(UserState userState) {
    switch (userState) {
      case UserState.offline:
        return 0;
      case UserState.online:
        return 1;
      default:
        return 2;
    }
  }

  static UserState numToState(int num){
    switch(num){
      case 0:
        return UserState.offline;
      case 1:
        return UserState.online;
      default:
        return UserState.waiting;
    }
  }

  static String formatDateString({String dateString}){
    DateTime dateTime = DateTime.parse(dateString);
    var formatter = DateFormat('dd/MM/yy');

    return formatter.format(dateTime);

  }
}
