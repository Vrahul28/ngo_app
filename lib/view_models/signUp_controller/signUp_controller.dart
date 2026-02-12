import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ngo_app/repo/signUp_repo/signUp_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ngo_app/utils/utils.dart';
import '../../res/routes_name/routes_name.dart';


class SignupController extends GetxController{

  final _api= SignUpRepo();
  RxBool isLoading= false.obs;

  final nameController = TextEditingController().obs;
  final emailController = TextEditingController().obs;
  final passwordController = TextEditingController().obs;
  final contactController = TextEditingController().obs;

  void clearController(){
    nameController.value.clear();
    emailController.value.clear();
    passwordController.value.clear();
    contactController.value.clear();
  }

  // Firebase method to save user details
  Future<String> registerUser(String name, String email, String password) async {
    UserCredential credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);

    final user = credential.user;
    if (user == null) {
      throw Exception("Firebase user creation failed");
    }

    String uid = credential.user!.uid;

    await FirebaseFirestore.instance.collection("users").doc(uid).set({
      "uid": uid,
      "name": name,
      "email": email,
      "role": "user",
    });

    return uid;
  }

  //Sing Up
  Future<void> singUp() async{
    isLoading.value= true;

    final firebaseUid = await registerUser(
        nameController.value.text,
        emailController.value.text,
        passwordController.value.text
    );

    Map data= {
      "name": nameController.value.text,
      "email": emailController.value.text,
      "password": passwordController.value.text,
      "contactNumber": contactController.value.text,
      "firebaseUid": firebaseUid,
    };

    debugPrint(data.toString());

    _api.signUp(data).then((value) async {
      debugPrint("API Response: $value");

      if(value['status'] == 200){
        isLoading.value= false;
        Utils.showSnackBar(value['message'], '',true);
        Get.toNamed(
            RoutesName.otpPage,
            arguments: {
              "email": emailController.value.text,
            }
        );
        clearController();
      }else if(value['status'] == 400){
        isLoading.value= false;
        Utils.showSnackBar(value['message'], '',true);
      }

    }).onError((error, stackTrace) {
      isLoading.value= false;
      debugPrint(error.toString());
    });
  }


}