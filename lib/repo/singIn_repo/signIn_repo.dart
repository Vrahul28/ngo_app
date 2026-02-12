import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../data/network/network_api_service.dart';
import '../../res/URLs/URLs.dart';

class SignInRepo extends GetxController{
  final _api= NetworkApiService();

  Future<dynamic> signIn(var data) async{
    dynamic response= await _api.postAPI(data, Urls.signInAPI);
    debugPrint(response.toString());
    return response;
  }

  Future<dynamic> verifyEmail(var data,String token) async{
    dynamic response= await _api.postAPI(data, Urls.resendOTPAPI);
    debugPrint(response.toString());
    return response;
  }


}