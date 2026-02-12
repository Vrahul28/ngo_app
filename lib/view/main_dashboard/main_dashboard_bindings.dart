import 'package:get/get.dart';
import '../../view_models/admin_controller/admin_controller.dart';
import '../../view_models/admin_controller/campaign_controller.dart';
import '../../view_models/chat_controller/chat_controller.dart';
import '../../view_models/chat_controller/group_controller.dart';
import '../../view_models/dashboard_controller/dashboard_controller.dart';
import '../../view_models/payment_controller/payment_controller.dart';
import '../../view_models/user_dashboard_controller/profile_controller.dart';
import '../../view_models/user_dashboard_controller/user_dashborad_controller.dart';

class MainDashboardBindings extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<UserDashboardController>(() => UserDashboardController(), fenix: true);
    Get.lazyPut<DashboardController>(() => DashboardController(), fenix: true);
    Get.lazyPut<AdminController>(() => AdminController(), fenix: true);
    Get.lazyPut<GroupController>(() => GroupController(), fenix: true);
    Get.lazyPut<ChatController>(() => ChatController(), fenix: true);
    Get.lazyPut<PaymentController>(() => PaymentController(), fenix: true);
    Get.lazyPut<ProfileController>(() => ProfileController(), fenix: true);
    Get.lazyPut<CampaignController>(() => CampaignController(), fenix: true);
  }

}