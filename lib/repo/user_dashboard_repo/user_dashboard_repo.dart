import 'package:ngo_app/data/network/network_api_service.dart';
import 'package:ngo_app/res/URLs/URLs.dart';


class UserDashboardRepo {
  final _api= NetworkApiService();

  Future<dynamic> fetchAllDonationAmount() async{
    dynamic response= await _api.getAPIWithToken(Urls.totalDonationAPI);
    return response;
  }
}