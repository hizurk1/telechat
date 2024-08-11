import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:telechat/app/configs/remote_config.dart';
import 'package:telechat/core/config/app_log.dart';

class UtilsFunction {
  static final ImagePicker _imagePicker = ImagePicker();

  static void unfocusTextField([void Function()? task]) {
    FocusManager.instance.primaryFocus?.unfocus();
    task?.call();
  }

  static Future<File?> pickImageFromGallery() async {
    try {
      final file = await _imagePicker.pickImage(source: ImageSource.gallery);
      return file != null ? File(file.path) : null;
    } catch (e) {
      logger.e(e.toString());
      return null;
    }
  }

  static Future<File?> pickVideoFromGallery() async {
    try {
      final file = await _imagePicker.pickVideo(
        source: ImageSource.gallery,
        maxDuration: Duration(minutes: RemoteConfig.maxVideoLengthInMins),
      );
      return file != null ? File(file.path) : null;
    } catch (e) {
      logger.e(e.toString());
      return null;
    }
  }
}
