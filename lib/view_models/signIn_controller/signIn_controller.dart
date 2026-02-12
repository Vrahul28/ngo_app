import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ngo_app/view_models/device_utils/device_utils.dart';
import '../../repo/singIn_repo/signIn_repo.dart';
import '../../res/routes_name/routes_name.dart';
import '../../utils/utils.dart';
import '../user_prefernce/user_preference.dart';

class SignInController extends GetxController{

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final emailController = TextEditingController().obs;
  final passwordController = TextEditingController().obs;

  final UserPreference user = UserPreference();
  final DeviceUtils du = DeviceUtils();

  final userId= ''.obs;
  final userName= ''.obs;
  final userRole= ''.obs;
  final firebaseUid = ''.obs;

  final _api= SignInRepo();
  RxBool isLoading= false.obs;

  void clearController(){
    emailController.value.clear();
    passwordController.value.clear();
    du.getDeviceInfo();
  }


  Future<void> firebaseLogin() async{
    /// 2️⃣ Firebase login
    final firebaseUser = await FirebaseAuth.instance
        .signInWithEmailAndPassword(
      email: emailController.value.text,
      password: passwordController.value.text,
    );

    firebaseUid.value = firebaseUser.user!.uid;

    /// 3️⃣ Ensure Firestore user exists
    final doc = await firestore
        .collection("users")
        .doc(firebaseUid.value)
        .get();

    if (!doc.exists) {
      await firestore.collection("users").doc(firebaseUid.value).set({
        "uid": firebaseUid.value,
        "name": userName.value,
        "email": emailController.value.text,
        "role": userRole.value,
      });
    }
  }

  //Sing In
  Future<void> singIn(String deviceName, String deviceID) async{
    isLoading.value= true;

    Map data= {
      "email": emailController.value.text,
      "password": passwordController.value.text,
      "deviceId": deviceID,
      "deviceName": deviceName
    };

    debugPrint(data.toString());

    _api.signIn(data).then((value) async{
      isLoading.value= false;
      // debugPrint(value['accessToken']);
      // debugPrint( userId.value );

      if(value['message'] == 'Email not Verified'){
        Utils.showSnackBar('Email not verified', 'Check Your Email For OTP',true);
        verifyEmail(emailController.value.text);
        Get.toNamed(
            RoutesName.otpPage,
            arguments: {
              "email": emailController.value.text,
            }
        );
        clearController();
      }

      debugPrint(value['id'].toString());
      debugPrint(value['name'].toString());
      debugPrint(value['role'].toString());
      debugPrint(value['firebaseUid'].toString());
      debugPrint(value['accessToken'].toString());
      debugPrint(value['refreshToken'].toString());

        userId.value = value['id'].toString();
        userName.value = value['name'].toString();
        userRole.value = value['role'].toString();

      user.saveUser(
        emailController.value.text,
        value['accessToken'],
        value['id'],
        value['name'],
        value['role'],
        value['refreshToken'],
        value['firebaseUid'],
      );

        Utils.showSnackBar('Login Successfully', '',true);
        Get.toNamed(
            RoutesName.mainDashBoardPage,
        );

        clearController();

      await firebaseLogin();
    }).onError((error, stackTrace) {
      isLoading.value= false;
      debugPrint(error.toString());
    });
  }

  //Fetch Firebase Users
  Stream<QuerySnapshot> getAllUsers() {
    return  firestore.collection("users").snapshots();
  }

  void verifyEmail(String email){
    isLoading.value= true;

    Map data= {
      "email": email,
    };

    debugPrint(data.toString());

    _api.verifyEmail(data,'').then((value) {
      isLoading.value= false;
      debugPrint(value.toString());
    }).onError((error, stackTrace) {
      isLoading.value= false;
      debugPrint(error.toString());
    });
  }


}