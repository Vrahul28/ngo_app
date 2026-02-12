import 'package:get/get.dart';
import '../../view/OTP_page/OTP_page.dart';
import '../../view/admin_dashboard/add_new_member.dart';
import '../../view/admin_dashboard/admin_controller_bindings.dart';
import '../../view/admin_dashboard/admin_dashboard.dart';
import '../../view/admin_dashboard/campaign/campaign_add_page.dart';
import '../../view/admin_dashboard/campaign/campaign_page.dart';
import '../../view/admin_dashboard/manage_members.dart';
import '../../view/admin_dashboard/payment_history_admin/filter_payment_history.dart';
import '../../view/admin_dashboard/payment_history_admin/payment_history_admin.dart';
import '../../view/admin_dashboard/payment_history_admin/search_result_payment_history.dart';
import '../../view/campaign_page/donate_page.dart';
import '../../view/forgetPassword_page/forgetPassword_page.dart';
import '../../view/forgetPassword_page/resetOTP_page.dart';
import '../../view/forgetPassword_page/set_email.dart';
import '../../view/main_dashboard/main_dashboard.dart';
import '../../view/main_dashboard/main_dashboard_bindings.dart';
import '../../view/payment_history/payment_history.dart';
import '../../view/signIn_page/signIn_page.dart';
import '../../view/signUp_form/signUp_form.dart';
import '../../view/splash_page/splash_page.dart';
import '../../view/user_dashboard/user_dashboard.dart';
import '../routes_name/routes_name.dart';

class Routes {
  static appRoutes() => [
    GetPage(
      name: RoutesName.splashPage,
      page: () => const SplashPage(),
      transitionDuration: const Duration(microseconds: 250),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: RoutesName.signInPage,
      page: () => const SignInPage(),
      transitionDuration: const Duration(microseconds: 250),
      transition: Transition.rightToLeft,
    ),
    GetPage(
        name: RoutesName.signUpPage,
        page: () => const SignUpForm(),
      transitionDuration: const Duration(microseconds: 250),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: RoutesName.userDashBoardPage,
      page: () => const UserDashboard(),
      transitionDuration: const Duration(microseconds: 250),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: RoutesName.mainDashBoardPage,
      page: () => const MainDashboard(),
      transitionDuration: const Duration(microseconds: 250),
      transition: Transition.rightToLeft,
      binding: MainDashboardBindings(),
    ),
    GetPage(
      name: RoutesName.paymentHistoryPage,
      page: () => const PaymentHistory(),
      transitionDuration: const Duration(microseconds: 250),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: RoutesName.adminDashboardPage,
      page: () => const AdminDashboard(),
      transitionDuration: const Duration(microseconds: 250),
      transition: Transition.rightToLeft,
      binding: AdminControllerBindings(),
    ),
    GetPage(
      name: RoutesName.addNewMemberPage,
      page: () => const AddNewMember(),
      transitionDuration: const Duration(microseconds: 250),
      transition: Transition.rightToLeft,
    ),
    // GetPage(
    //   name: RoutesName.memberPage,
    //   page: () => const ManageMembers(),
    //   transitionDuration: const Duration(microseconds: 250),
    //   transition: Transition.rightToLeft,
    // ),
    GetPage(
      name: RoutesName.otpPage,
      page: () => const OtpPage(),
      transitionDuration: const Duration(microseconds: 250),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: RoutesName.resetOtpPage,
      page: () => const ResetOtpPage(),
      transitionDuration: const Duration(microseconds: 250),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: RoutesName.forgetPassPage,
      page: () => const ForgetPasswordPage(),
      transitionDuration: const Duration(microseconds: 250),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: RoutesName.setEmailPage,
      page: () => const SetEmailPassword(),
      transitionDuration: const Duration(microseconds: 250),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: RoutesName.paymentHistoryPageForAdmin,
      page: () => const PaymentHistoryAdmin(),
      transitionDuration: const Duration(microseconds: 250),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: RoutesName.filterPaymentHistoryPage,
      page: () => const FilterPaymentHistory(),
      transitionDuration: const Duration(microseconds: 250),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: RoutesName.searchResultPaymentHistoryPage,
      page: () => const SearchResultPaymentHistory(),
      transitionDuration: const Duration(microseconds: 250),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: RoutesName.campaignAddPage,
      page: () => const CampaignAddPage(),
      transitionDuration: const Duration(microseconds: 250),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: RoutesName.campaignPage,
      page: () => const CampaignPage(),
      transitionDuration: const Duration(microseconds: 250),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: RoutesName.donatePage,
      page: () => const DonatePage(),
      transitionDuration: const Duration(microseconds: 250),
      transition: Transition.rightToLeft,
    ),
  ];
}