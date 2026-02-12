import 'package:flutter/cupertino.dart';
import '../../data/network/network_api_service.dart';
import '../../model/payment_history_user.dart';
import '../../res/URLs/URLs.dart';

class ProfileRepo {
  final _api= NetworkApiService();

  Future<List<PaymentHistoryUser>> fetchPaymentHistoryForUser(String userID) async{
    String url= '${Urls.paymentHistoryForUserAPI}?userId=$userID';
    dynamic response= await _api.getAPIWithToken(url);
    debugPrint(response.toString());
    return (response as List)
        .map((e) => PaymentHistoryUser.fromJson(e))
        .toList();
  }

  Future<dynamic> logout(var data) async{
    dynamic response= await _api.postAPI(data, Urls.logoutAPI);
    debugPrint(response.toString());
    return response;
  }
}