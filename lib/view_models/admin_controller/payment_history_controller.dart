import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/exeception/status.dart';
import '../../model/payment_history.dart';
import '../../repo/payment_history_repo/payment_history_repo.dart';
import '../dashboard_controller/dashboard_controller.dart';

class PaymentHistoryController extends GetxController{

  final _api= PaymentHistoryRepo();
  final rxRequestStatus = Status.LOADING.obs;
  RxString error = ''.obs;
  RxList<Data> history= <Data>[].obs;
  RxList<Data> search= <Data>[].obs;
  RxBool isLoading= false.obs;

  void setRequestStatus(Status value) => rxRequestStatus.value = value;
  void setError(String value) => error.value = value;

  final name= TextEditingController().obs;
  final fromDate= TextEditingController().obs;
  final toDate= TextEditingController().obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchPaymentHistory('', '', '');
  }

  void clearController(){
    name.value.clear();
    fromDate.value.clear();
    toDate.value.clear();
  }

  //Fetch Payment History
  void fetchPaymentHistory(String? name,String? fromDate, String? toDate){
    isLoading.value= true;

    _api.searchPaymentHistoryByFilter(name!.trim(), fromDate!, toDate!).then((value) {
      isLoading.value= false;
      if(name.isNotEmpty || fromDate.isNotEmpty || toDate.isNotEmpty){
        search.value = value.data ?? [];
        setRequestStatus(Status.COMPLETED);
      }else{
        history.value = value.data ?? [];
        setRequestStatus(Status.COMPLETED);
      }

    }).onError((error, stackTrace) {
      isLoading.value= false;
      debugPrint(error.toString());
      setRequestStatus(Status.ERROR);
    });
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

}