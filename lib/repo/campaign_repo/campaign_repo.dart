import 'package:flutter/cupertino.dart';
import 'package:ngo_app/data/network/network_api_service.dart';
import 'package:ngo_app/model/campaign_model.dart';
import 'package:ngo_app/res/URLs/URLs.dart';

class CampaignRepo {
  final _api= NetworkApiService();

  Future<dynamic> addCampaign(var data) async{
    final response= await _api.postAPI(data, Urls.addCampaignAPI);
    return response;
  }

  Future<dynamic> editCampaign(var data,String id) async{
    String url= '${Urls.editCampaignAPI}/$id';
    final response= await _api.putAPI(data, url);
    return response;
  }

  Future<dynamic> deleteCampaign(String id) async{
    String url= '${Urls.deleteCampaignAPI}/$id';
    final response= await _api.deleteAPI(url);
    debugPrint(response.toString());
    return response;
  }

  Future<CampaignModel> getAllCampaign() async{
    final response= await _api.getAPIWithToken(Urls.getAllCampaignAPI);
    debugPrint(response.toString());
    return CampaignModel.fromJson(response);
  }

  Future<CampaignModel> getAllUserCampaign() async{
    final response= await _api.getAPIWithToken(Urls.getAllUserCampaignAPI);
    return CampaignModel.fromJson(response);
  }
}