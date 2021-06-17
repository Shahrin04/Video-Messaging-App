import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

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
}
