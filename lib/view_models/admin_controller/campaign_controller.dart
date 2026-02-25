import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ngo_app/model/campaign_model.dart';
import 'package:ngo_app/repo/campaign_repo/campaign_repo.dart';
import 'package:ngo_app/view_models/user_prefernce/user_preference.dart';
import '../../data/exeception/status.dart';
import '../../utils/utils.dart';

class CampaignController extends GetxController{

  final user= UserPreference();
  final _api= CampaignRepo();
  RxBool isLoading= false.obs;
  final rxRequestStatus = Status.LOADING.obs;
  RxString error = ''.obs;
  RxList<Data> campaign= <Data>[].obs;
  RxList<Data> userCampaign= <Data>[].obs;

  void setRequestStatus(Status value) => rxRequestStatus.value = value;
  void setError(String value) => error.value = value;

  final title= TextEditingController().obs;
  final des= TextEditingController().obs;
  final amount= TextEditingController().obs;
  final startDate= TextEditingController().obs;
  final endDate= TextEditingController().obs;

  final userRole= ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUser();
  }

  void fetchUser() async{
    userRole.value= await user.getRole();
    if(userRole.value == 'Admin'){
      await getAllUserCampaign();
    }else{
      await getAllCampaign();
    }
  }



  void clearController(){
    title.value.clear();
    des.value.clear();
    amount.value.clear();
    startDate.value.clear();
    endDate.value.clear();
  }

  String formatDate(String dateString) {
    final DateTime dateTime = DateTime.parse(dateString);
    return DateFormat('yy-MM-dd').format(dateTime);
  }

  void openDatePicker(BuildContext context, TextEditingController controller) async{
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      // format date → 26-01-05 or change format if needed
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      controller.text = formattedDate;
    }
  }


Future<bool> addCampaign(String title, String des, double amount, String date, String endDate) async{
    isLoading.value= true;

    Map data= {
      "title": title,
      "description": des,
      "targetAmount": amount,
      "startDate": date,
      "endDate": endDate
    };

    debugPrint(data.toString());
    try{
      _api.addCampaign(data).then((value) async {
      await getAllCampaign().then((value1) {
        isLoading.value= false;
        debugPrint(value['message']);
        if(value['status'] == 200){
       setRequestStatus(Status.COMPLETED);
       Utils.showSnackBar(value['message'], '',true);
      }
      });
    });
    Get.back(result: true);
    clearController();
    return true;
    }catch(e){
      isLoading.value= false;
      debugPrint(error.toString());
      setRequestStatus(Status.ERROR);
     return false;
    }

  }

 Future<bool> editCampaign(String id,String title, String des, double amount, String date, String endDate) async{
    isLoading.value= true;

    Map data= {
      "title": title,
      "description": des,
      "targetAmount": amount,
      "startDate": date,
      "endDate": endDate,
      "isActive": true
    };

    debugPrint(data.toString());

    try{
      _api.editCampaign(data, id).then((value) async{
      await getAllCampaign().then((value1) {
      isLoading.value= false;
      debugPrint(value['message']);
      if(value['status'] == 200){
       setRequestStatus(Status.COMPLETED);
       Utils.showSnackBar(value['message'], '',true);
      }
      });
    });
    Get.back(result: true);
    clearController();
    return true;
    }catch(e){
      isLoading.value= false;
      debugPrint(error.toString());
      setRequestStatus(Status.ERROR);
      return false;
    }

    
  }

 Future<bool> deleteCampaign(String id) async{
    isLoading.value= true;
    try {
      final value = await _api.deleteCampaign(id);
      debugPrint(value['message']);
      if (value['status'] == 200) {
      // 🔥 REMOVE ITEM FROM LIST
      userCampaign.removeWhere((element) => element.id == id);
      setRequestStatus(Status.LOADING);
      await Future.delayed(const Duration(milliseconds: 50));
      setRequestStatus(Status.COMPLETED);
      Utils.showSnackBar(value['message'], '', true);
    }
      isLoading.value = false;
      return true;
    } catch (e) {
      isLoading.value = false;
      debugPrint(error.toString());
      setRequestStatus(Status.ERROR);
      return false;
    }
  }

  // Future<void> getAllCampaign() async{
  //   isLoading.value= true;

  //   _api.getAllCampaign().then((value) {
  //     isLoading.value= false;
  //     campaign.value = value.data ?? [];
  //     setRequestStatus(Status.COMPLETED);
  //   }).onError((error, stackTrace) {
  //     isLoading.value= false;
  //     debugPrint(error.toString());
  //     setRequestStatus(Status.ERROR);
  //   });
  // }

  Future<void> getAllCampaign() async {

  setRequestStatus(Status.LOADING);

  _api.getAllCampaign().then((value) {
    campaign.value = value.data ?? [];
    /// 🔥 THIS LINE FIXES YOUR ENTIRE PROBLEM
    userCampaign.assignAll(campaign);
    setRequestStatus(Status.COMPLETED);
  }).onError((error, stackTrace) {
    setRequestStatus(Status.ERROR);
    debugPrint(error.toString());
  });
}

  Future<void> getAllUserCampaign() async{
    isLoading.value= true;

    _api.getAllUserCampaign().then((value) {
      isLoading.value= false;
      userCampaign.value = value.data ?? [];
      setRequestStatus(Status.COMPLETED);
    }).onError((error, stackTrace) {
      isLoading.value= false;
      debugPrint(error.toString());
      setRequestStatus(Status.ERROR);
    });
  }
}