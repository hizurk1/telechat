import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:telechat/core/config/app_log.dart';

class UtilsFunction {
  static void unfocusTextField([void Function()? task]) {
    FocusManager.instance.primaryFocus?.unfocus();
    task?.call();
  }

  static Future<File?> pickImageFromGallery() async {
    File? image;
    try {
      final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        image = File(pickedImage.path);
      }
    } catch (e) {
      logger.e("pickImageFromGallery: $e");
    }
    return image;
  }

  static Future<File?> captureImageFromCamera() async {
    File? image;
    try {
      final pickedImage = await ImagePicker().pickImage(source: ImageSource.camera);
      if (pickedImage != null) {
        image = File(pickedImage.path);
      }
    } catch (e) {
      logger.e("captureImageFromCamera: $e");
    }
    return image;
  }
}
