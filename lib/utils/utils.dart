import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../res/app_colors/app_colors.dart';

class Utils {
  static  showSnackBar(String title, String message, bool success){
    Get.snackbar(
        title,
        message,
      backgroundColor:  success ? AppColors.primary : AppColors.redError,
      duration: const Duration(seconds: 2),
      titleText: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      messageText: Text(message, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
    );
  }
}