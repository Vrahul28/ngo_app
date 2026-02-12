import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:ngo_app/repo/OTP_repo/OTP_repo.dart';

import '../../res/routes_name/routes_name.dart';

class OtpController extends GetxController{
  final _api= OtpRepo();
  RxBool isLoading= false.obs;

  final codeController = TextEditingController().obs;

  //Sing Up
  void verifyEmail(String email){
    isLoading.value= true;

    Map data= {
      "email": email,
      "code": codeController.value.text,
    };

    debugPrint(data.toString());

    _api.verifyEmail(data).then((value) {
      isLoading.value= false;
      debugPrint(value.toString());
      Get.toNamed(RoutesName.signInPage);
    }).onError((error, stackTrace) {
      isLoading.value= false;
      debugPrint(error.toString());
    });
  }
}