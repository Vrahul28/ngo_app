import 'package:ngo_app/data/network/network_api_service.dart';
import 'package:ngo_app/model/members.dart';
import 'package:ngo_app/res/URLs/URLs.dart';

class MembersRepo {
  final _api= NetworkApiService();

  Future<Members> fetchAllMembers() async{
    String url= '${Urls.allMemberAPI}/?page=1&pageSize=10';
    dynamic response= await _api.getAPIWithToken(url);
    return Members.fromJson(response);
  }

  Future<dynamic> fetchCountMembers() async{
    dynamic response= await _api.getAPIWithToken(Urls.countMemberAPI);
    return response;
  }

  Future<dynamic> totalDonation() async{
    dynamic response= await _api.getAPIWithToken(Urls.totalDonationAPI);
    return response;
  }

  Future<dynamic> addMemberByNumber(String num) async{
    String url= '${Urls.addMemberByAdminAPI}/?contactNumber=$num';
    dynamic response= await _api.getAPIWithToken(url);
    return response;
  }

  Future<dynamic> addDonationByAdmin(var data) async{
    dynamic response= await _api.postAPI(data, Urls.addDonationByAdminAPI);
    return response;
  }
}
