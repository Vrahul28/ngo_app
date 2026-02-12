import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ngo_app/repo/profile_repo/profile_repo.dart';
import '../../data/exeception/status.dart';
import '../../model/payment_history_user.dart';
import '../dashboard_controller/dashboard_controller.dart';
import '../user_prefernce/user_preference.dart';

class ProfileController extends GetxController{
  final user= UserPreference();
  final _api= ProfileRepo();
  final dash= Get.find<DashboardController>();

  RxString name= ''.obs;
  RxString email= ''.obs;
  RxString userID= ''.obs;
  RxBool isLoading= false.obs;
  var paymentHistory= <PaymentHistoryUser>[].obs;

  final rxRequestStatus = Status.LOADING.obs;
  RxString error = ''.obs;

  void setRequestStatus(Status value) => rxRequestStatus.value = value;
  void setError(String value) => error.value = value;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchProfile();
  }

  void fetchProfile() async{
    name.value= await user.getUserName();
    email.value= await user.getEmail();
    userID.value= await user.getUserId();
  }


  String formatDate(String dateString) {
    final DateTime dateTime = DateTime.parse(dateString);
    return DateFormat('dd-MM-yyyy').format(dateTime);
  }

  //Fetch Payment History of User
  void fetchTotalDonationByUser(String userID){
    isLoading.value= true;

    _api.fetchPaymentHistoryForUser(userID).then((value) {
      isLoading.value= false;
      paymentHistory.value= value;
      setRequestStatus(Status.COMPLETED);
    }).onError((error, stackTrace) {
      isLoading.value= false;
      debugPrint(error.toString());
      setRequestStatus(Status.ERROR);
    });
  }

  void logout(String token){
    isLoading.value= true;
    
    Map data= {
      "refreshToken": token
    };

    debugPrint(data.toString());

    _api.logout(data).then((value) {
      isLoading.value= false;
      setRequestStatus(Status.COMPLETED);
    }).onError((error, stackTrace) {
      isLoading.value= false;
      debugPrint(error.toString());
      setRequestStatus(Status.ERROR);
    });
  }
}