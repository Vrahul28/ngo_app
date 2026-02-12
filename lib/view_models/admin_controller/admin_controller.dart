import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:ngo_app/repo/members_repo/members_repo.dart';
import 'package:ngo_app/res/routes_name/routes_name.dart';
import 'package:ngo_app/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/exeception/status.dart';
import '../../model/members.dart';
import '../dashboard_controller/dashboard_controller.dart';

class AdminController extends GetxController{
  final dash= Get.find<DashboardController>();
  final _api= MembersRepo();

  final rxRequestStatus = Status.LOADING.obs;
  RxString error = ''.obs;
  RxList<Datum> members= <Datum>[].obs;
  RxBool isLoading= false.obs;
  RxString totalMembers= ''.obs;
  RxDouble totalDonation= 0.0.obs;
  RxString userID= ''.obs;

  void setRequestStatus(Status value) => rxRequestStatus.value = value;
  void setError(String value) => error.value = value;

  //For Member Page
  final contact= TextEditingController().obs;
  final email= TextEditingController().obs;
  final name= TextEditingController().obs;
  final donationAmount= TextEditingController().obs;

  void clearController(){
    contact.value.clear();
    email.value.clear();
    name.value.clear();
    donationAmount.value.clear();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchMembers();
  }

  //Fetch Count OF Members
  void fetchTotalCountOfMembers(){
    isLoading.value= true;

    _api.fetchCountMembers().then((value) {
      isLoading.value= false;
      totalMembers.value= value['data']['totalUsers'].toString();
      debugPrint(value['data']['totalUsers'].toString());
      setRequestStatus(Status.COMPLETED);
    }).onError((error, stackTrace) {
      debugPrint('Error in Admin Controller fetchTotalCountOfMembers: ${error.toString()}');
      isLoading.value= false;
      setRequestStatus(Status.ERROR);
    });
  }

  //Fetch Total Donation
  void totalDonationCount(){
    isLoading.value= true;

    _api.totalDonation().then((value) {
      isLoading.value= false;
      totalDonation.value= value['totalContribution'];
      debugPrint(value['totalDonation'].toString());
      setRequestStatus(Status.COMPLETED);
    }).onError((error, stackTrace) {
      isLoading.value= false;
      debugPrint('Total Donation Error: ${error.toString()}');
      setRequestStatus(Status.ERROR);
    });

  }


  //Fetch All Members
  void fetchMembers(){
    isLoading.value= true;

    _api.fetchAllMembers().then((value) {
      isLoading.value= false;
      debugPrint(value.message);
      members.value = value.data?.data ?? [];
      setRequestStatus(Status.COMPLETED);
    }).onError((error, stackTrace) {
      isLoading.value= false;
      debugPrint('Admin Controller fetchMembers: ${error.toString()}');
      setRequestStatus(Status.ERROR);
    });

  }

  Timer? _debounce;

  void onNumberChanged(String num) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 600), () {
      if (num.isNotEmpty) {
        addMemberByAdmin(num);
      }
    });
  }

  //For Add Member Page
  //Add Member by Email By admin
  void addMemberByAdmin(String num){
    isLoading.value= true;

    _api.addMemberByNumber(num).then((value) {
      if(value['status'] == 200){
        isLoading.value= false;
        debugPrint(value['data']['name'].toString());
        name.value.text= value['data']['name'];
        email.value.text= value['data']['email'];
        userID.value= value['data']['id'];
        setRequestStatus(Status.COMPLETED);
      }else{
        isLoading.value= false;
        Utils.showSnackBar(value['message'], '', true);
      }

    }).onError((error, stackTrace) {
      isLoading.value= false;
      debugPrint(error.toString());
      setRequestStatus(Status.ERROR);
      debugPrint('Admin Controller addMemberByAdmin: ${error.toString()}');
    });

  }

  //For Add Member Page
  //Add Donation By admin
  void addDonation(int amount){
    isLoading.value= true;

    Map data= {
      "userId": userID.value,
      "amount": amount
    };

    debugPrint(data.toString());

    _api.addDonationByAdmin(data).then((value) {
      if(value['status'] == 200){
        isLoading.value= false;
        debugPrint(value['message'].toString());
        Utils.showSnackBar(value['message'], '', true);
        setRequestStatus(Status.COMPLETED);
        Get.toNamed(RoutesName.adminDashboardPage);
        clearController();
      }else{
        isLoading.value= false;
        Utils.showSnackBar(value['message'], '', true);
      }

    }).onError((error, stackTrace) {
      isLoading.value= false;
      debugPrint('Admin Controller addDonation: ${error.toString()}');
      setRequestStatus(Status.ERROR);
    });

  }

  // Open phone app for call
  void launchPhoneDialer(String phoneNumber) async {
    final Uri uri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      print('Could not launch dialer for $phoneNumber');
    }
  }

}