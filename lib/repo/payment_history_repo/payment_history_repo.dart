import 'package:ngo_app/data/network/network_api_service.dart';
import '../../model/payment_history.dart';
import '../../res/URLs/URLs.dart';

class PaymentHistoryRepo {
  final _api= NetworkApiService();

  Future<PaymentHistoryModel> searchPaymentHistoryByFilter(String name, String fromDate, String toDate) async{
    String url= '${Urls.paymentHistoryForAdminAPI}?page=1&pageSize=10&search=$name&fromDate=$fromDate&toDate=$toDate';
    final response= await _api.getAPIWithToken(url);
    return PaymentHistoryModel.fromJson(response);
  }

}