import 'package:flutter/cupertino.dart';
import '../../data/network/network_api_service.dart';
import '../../res/URLs/URLs.dart';

class ForgetPasswordRepo {
  final _api= NetworkApiService();

  Future<dynamic> forgetPass(var data) async{
    dynamic response= await _api.postAPI(data, Urls.forgetPassAPI);
    debugPrint(response.toString());
    return response;
  }

  Future<dynamic> resetOTP(var data) async{
    dynamic response= await _api.postAPI(data, Urls.resetOTPAPI);
    debugPrint(response.toString());
    return response;
  }

  Future<dynamic> resetPassword(var data) async{
    dynamic response= await _api.postAPI(data, Urls.resetPasswordAPI);
    debugPrint(response.toString());
    return response;
  }

}