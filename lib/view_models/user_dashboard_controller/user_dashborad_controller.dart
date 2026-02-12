import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ngo_app/view_models/user_prefernce/user_preference.dart';
import '../../data/exeception/status.dart';
import '../../repo/user_dashboard_repo/user_dashboard_repo.dart';
import '../device_utils/device_utils.dart';

class UserDashboardController extends GetxController{
  final _api= UserDashboardRepo();
  final rxRequestStatus = Status.LOADING.obs;
  RxString error = ''.obs;
  RxDouble totalDonation=  0.0.obs;
  RxString refreshedToken= ''.obs;

  RxBool isLoading= false.obs;
  final user= UserPreference();
  final DeviceUtils du = DeviceUtils();

  void setRequestStatus(Status value) => rxRequestStatus.value = value;
  void setError(String value) => error.value = value;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchTotalDonationByUser();
  }

  //Fetch Count OF Members
  void fetchTotalDonationByUser() async{
    isLoading.value= true;
    _api.fetchAllDonationAmount().then((value) {
      isLoading.value= false;
      totalDonation.value= value['totalContribution'];
      debugPrint(value['totalContribution'].toString());
      setRequestStatus(Status.COMPLETED);
    }).onError((error, stackTrace) {
      isLoading.value= false;
      debugPrint('UserDashboardController fetchTotalDonationByUser: ${error.toString()}');
      setRequestStatus(Status.ERROR);
    });
  }

}