import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ngo_app/view_models/auth_service/auth_service.dart';
import '../../res/routes_name/routes_name.dart';
import '../notification_service/app_startUp_service.dart';
import '../user_prefernce/user_preference.dart';

class SplashService {
  final UserPreference user = UserPreference();
  // final auth= AuthService();
  // void login() {
  //   user.getEmail().then((value) {
  //     if (value.isEmpty) {
  //       Timer(
  //         Duration(seconds: 4),
  //             () => Get.toNamed(RoutesName.signInPage),
  //       );
  //     } else {
  //       // auth.refreshToken();
  //       Timer(
  //         Duration(seconds: 4),
  //             () => Get.toNamed(RoutesName.mainDashBoardPage),
  //       );
  //     }
  //   }).onError((error, stackTrace) {
  //     debugPrint('Error in splash service: ${error.toString()}');
  //   });
  // }

  void login() async {

    String email = await user.getEmail();
    String firebaseUid = await user.getFirebaseId();

    if (email.isEmpty) {
      Get.offAllNamed(RoutesName.signInPage);
      return;
    }

    // 🔥 restore firebase session
    // User? firebaseUser = FirebaseAuth.instance.currentUser;

    // if (firebaseUser == null) {
    //   // silently sign in again
    //   await AuthService().firebaseLoginWithStoredUid(firebaseUid);
    // }

    // 🔥 attach token on auto login
    await AppStartupService.afterLogin(firebaseUid);

    Get.offAllNamed(RoutesName.mainDashBoardPage);
  }

}