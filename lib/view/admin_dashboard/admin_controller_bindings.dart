import 'package:get/get.dart';
import '../../view_models/admin_controller/payment_history_controller.dart';

class AdminControllerBindings extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<PaymentHistoryController>(() => PaymentHistoryController(), fenix: true);
  }

}