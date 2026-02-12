import '../../data/network/network_api_service.dart';
import 'package:flutter/material.dart';
import '../../res/URLs/URLs.dart';

class OtpRepo {
  final _api= NetworkApiService();

  Future<dynamic> verifyEmail(var data) async{
    dynamic response= await _api.postAPI(data, Urls.verifyEmailAPI);
    debugPrint(response.toString());
    return response;
  }
}