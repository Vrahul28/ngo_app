import 'package:ngo_app/data/network/network_api_service.dart';
import 'package:flutter/material.dart';
import 'package:ngo_app/res/URLs/URLs.dart';

class SignUpRepo {
  final _api= NetworkApiService();

  Future<dynamic> signUp(var data) async{
    dynamic response= await _api.postAPI(data, Urls.signUpAPI);
    debugPrint(response.toString());
    return response;
  }

}