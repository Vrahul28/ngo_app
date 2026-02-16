import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ngo_app/view_models/user_prefernce/user_preference.dart';

import '../notification_service/notification_service.dart';


class DashboardController extends GetxController{
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  RxInt currentIndex= 0.obs;
  RxString role= ''.obs;
  RxString userId= ''.obs;
  RxString name= ''.obs;

//for chat
  RxString adminFirebaseUid = ''.obs;
  RxString adminName = ''.obs;
  RxString adminEmail = ''.obs;
  PageController pageController = PageController(initialPage: 0);
  final user= UserPreference();

  @override
  void onInit() {
    super.onInit();
    getRoleForDash();
  }

  Future<void> getRoleForDash() async{
    role.value= await user.getRole();
    await fetchAdminFirebaseUid();
    getIdForDash();
    getNameForDash();
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

  //fetch admin firebase uid from firestore
  Future<void> fetchAdminFirebaseUid() async {
  final doc = await FirebaseFirestore.instance
      .collection('app_config')
      .doc('admin')
      .get();

  if (doc.exists) {
    adminFirebaseUid.value = doc.data()!['adminUid'];
    adminName.value = doc.data()!['userName'];
    adminEmail.value = doc.data()!['adminEmail'];
  }
}
//
// Future<void> initNotificationSystem() async {
//   await getRoleForDash();
//
//   // wait until firebase id available
//   await Future.delayed(const Duration(milliseconds: 500));
//
//   if(userId.value.isNotEmpty){
//     await NotificationService.init(userId.value);              // get FCM token & save
//     await NotificationService.initialize(userId.value); // listeners
//   }
// }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }


}