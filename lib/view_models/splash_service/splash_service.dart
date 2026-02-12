import 'dart:async';
import 'package:get/get.dart';
import 'package:ngo_app/view_models/auth_service/auth_service.dart';
import '../../res/routes_name/routes_name.dart';
import '../user_prefernce/user_preference.dart';

class SplashService {
  final UserPreference user = UserPreference();
  final auth= AuthService();
  void login() {
    user.getEmail().then((value) {
      if (value.isEmpty) {
        Timer(
          Duration(seconds: 4),
              () => Get.toNamed(RoutesName.signInPage),
        );
      } else {
        // auth.refreshToken();
        Timer(
          Duration(seconds: 4),
              () => Get.toNamed(RoutesName.mainDashBoardPage),
        );
      }
    }).onError((error, stackTrace) {
      print('Error in splash service: ${error.toString()}');
    });
  }
}