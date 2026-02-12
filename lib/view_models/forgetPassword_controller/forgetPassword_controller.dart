import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../repo/forgetPassword_repo/forgetPassword_repo.dart';
import '../../res/routes_name/routes_name.dart';
import '../../utils/utils.dart';

class ForgetPasswordController extends GetxController{
  final _api= ForgetPasswordRepo();
  RxBool isLoading= false.obs;

  final emailController = TextEditingController().obs;
  final codeController = TextEditingController().obs;
  final passwordController = TextEditingController().obs;
  final confirmPasswordController = TextEditingController().obs;

  void clearController(){
    emailController.value.clear();
    codeController.value.clear();
    passwordController.value.clear();
    confirmPasswordController.value.clear();
  }

  //Reset OTP
  void forgetPass(){
    isLoading.value= true;

    Map data= {
      "email": emailController.value.text.trim(),
    };

    debugPrint(data.toString());
    _api.forgetPass(data).then((value) {
      isLoading.value= false;
      debugPrint("API Response: $value");
      Utils.showSnackBar("OTP Send Successfully", '',true);
      Get.toNamed(RoutesName.resetOtpPage);
    }).onError((error, stackTrace) {
      isLoading.value= false;
      debugPrint(error.toString());
    });
  }

  //Reset OTP
  void resetOTP(){
    isLoading.value= true;

    Map data= {
      "email": emailController.value.text.trim(),
      "code": codeController.value.text.trim(),
    };

    debugPrint(data.toString());

    _api.resetOTP(data).then((value) {
      isLoading.value= false;
      debugPrint("API Response: $value");
      Get.toNamed(RoutesName.forgetPassPage);
    }).onError((error, stackTrace) {
      isLoading.value= false;
      debugPrint(error.toString());
    });
  }

  //Reset Password
  void resetPassword(){
    isLoading.value= true;

    Map data= {
      "email": emailController.value.text.trim(),
      "newPassword": passwordController.value.text.trim(),
    };

    debugPrint(data.toString());
    _api.resetPassword(data).then((value) {
      isLoading.value= false;
      debugPrint("API Response: $value");
      Get.toNamed(RoutesName.signInPage);
      clearController();
    }).onError((error, stackTrace) {
      isLoading.value= false;
      debugPrint(error.toString());
    });
  }
}