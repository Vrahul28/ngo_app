import 'package:flutter/cupertino.dart';
import 'package:ngo_app/data/network/network_api_service.dart';
import 'package:ngo_app/res/URLs/URLs.dart';

class PaymentRepo {
  final _api= NetworkApiService();

  Future<dynamic> createOrder(var data) async {
    final response= await _api.postAPI(data, Urls.createOrderAPI);
    debugPrint('Payment Repo response : ${response.toString()}');
    return response;
  }

  Future<dynamic> verifyPayment(var data) async {
    final response= await _api.postAPI(data, Urls.verifyPaymentAPI);
    debugPrint('Payment Repo verify response : ${response.toString()}');
    return response;
  }

}