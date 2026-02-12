import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ngo_app/view_models/user_prefernce/user_preference.dart';


class DashboardController extends GetxController{
  RxInt currentIndex= 0.obs;
  RxString role= ''.obs;
  RxString userId= ''.obs;
  RxString name= ''.obs;
  PageController pageController = PageController(initialPage: 0);
  final user= UserPreference();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getRoleForDash();
    getIdForDash();
    getNameForDash();
  }

  void getRoleForDash() async{
    role.value= await user.getRole();
  }

  void getIdForDash() async{
    userId.value= await user.getFirebaseId();
  }

  void getNameForDash() async{
    name.value= await user.getUserName();
  }

  void onPageChangedWithOutAnimation(int index) {
      currentIndex.value = index;
  }

  void updateTabSelection(int index) {
    currentIndex.value = index;
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
    pageController.jumpToPage(index);
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }


}