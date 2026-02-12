import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ngo_app/repo/payment_repo/payment_repo.dart';
import 'package:ngo_app/utils/utils.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../data/exeception/status.dart';


class PaymentController extends GetxController{
  final _api= PaymentRepo();
  late Razorpay razorpay;
  RxBool loading= false.obs;
  RxString paymentId= ''.obs;
  RxString orderId= ''.obs;
  RxString signature= ''.obs;

  final rxRequestStatus = Status.LOADING.obs;
  RxString error = ''.obs;
  void setRequestStatus(Status value) => rxRequestStatus.value = value;
  void setError(String value) => error.value = value;

  final amount= TextEditingController().obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    razorpay= Razorpay();
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    razorpay.clear();
    super.dispose();
  }

  Future<String> createOrderForPayment(int amount) async{
    loading.value= true;
    var data= {
      "amount": amount,
    };
    _api.createOrder(data).then((value) {
      debugPrint('Payment controller response : ${value['orderId']}');
      loading.value= false;
      setRequestStatus(Status.COMPLETED);
      orderId.value= value['orderId'];
      return value['orderId'];
    }).onError((error, stackTrace) {
      loading.value= false;
      debugPrint('Error in Payment Controller createOrderForPayment: ${error.toString()}');
      setRequestStatus(Status.ERROR);
    });
    return '';
  }

  // 🔹 STEP 2: Open Razorpay
  void openCheckout(String orderId,int amount) {
    var options = {
      'key': 'rzp_test_Rxkj4rG6vkz5BK', // Key ID
      'amount': amount * 100,
      'currency': 'INR',
      'name': 'NGO App',
      'description': 'Send Donation',
      'order_id': orderId,
      'prefill': {
        'contact': '7369919326',
        'email': 'test@gmail.com'
      },
      'theme': {
        'color': '#0A5CFF'
      },
      'external': {
        'wallets': ['paytm']
      }
    };

    razorpay.open(options);
  }

  // 🔹 Payment Success
  void _handlePaymentSuccess(PaymentSuccessResponse response) {

    // Send paymentId, orderId, signature to backend for verification
    Map data= {
      "razorpayOrderId":  orderId.value,
      "razorpayPaymentId": response.paymentId,
      "razorpaySignature": response.signature,
      "amount": 1,
      "userId": "bec463a6-6d4f-4ba7-903b-946f48f11aac",
      "campaignId": "4481DE4C-5680-4EEA-AFA8-66ED6A1EA0EA"
    };

    debugPrint(data.toString());

    _api.verifyPayment(data).then((value) {
      debugPrint('Handle Payment response : ${value['message']}');
      loading.value= false;
      setRequestStatus(Status.COMPLETED);
      debugPrint(value['message']);
      Utils.showSnackBar('Payment Success', '${response.paymentId}', true);
    }).onError((error, stackTrace) {
      loading.value= false;
      setRequestStatus(Status.ERROR);
      debugPrint('Error in Payment Controller handlePaymentSuccess: ${error.toString()}');
    });


  }

  // 🔹 Payment Failure
  void _handlePaymentError(PaymentFailureResponse response) {
    Utils.showSnackBar('Payment Failed', '', true);
  }

  // 🔹 External Wallet
  void _handleExternalWallet(ExternalWalletResponse response) {
    String chosenWallet = response.walletName ?? ""; // Capture chosen wallet name
    switch (chosenWallet) {
      case 'paytm':
      // Display specific information for Paytm
        break;
      case 'freecharge':
      // Display specific information for Freecharge
        break;
      default:
      // Handle other wallets
    }
    Utils.showSnackBar('Wallet', '${response.walletName}', true);
  }

  Future<void> startPayment(int amount) async {
    loading.value= true;

    try {
      String orderId = await createOrderForPayment(amount);
      debugPrint('Payment Controller Order Id : $orderId');
      openCheckout(orderId,amount);
    } catch (e) {
      loading.value= false;
      Utils.showSnackBar('Order Creation Failed', e.toString(), true);
      debugPrint('Error in Payment Controller startPayment: ${error.toString()}');
    }


  }

}