import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:ngo_app/res/routes_name/routes_name.dart';
import 'package:ngo_app/view/admin_dashboard/manage_members.dart';
import 'package:ngo_app/view_models/admin_controller/admin_controller.dart';
import '../../res/app_colors/app_colors.dart';
import '../../view_models/dashboard_controller/dashboard_controller.dart';
import '../../widgets/custom_admin_button.dart';
import '../../widgets/custom_metric_card.dart';
import '../chat_page/group_chat_page.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final AdminController ad= Get.find<AdminController>();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Admin Dashboard 📊', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                Obx(
                  () {
                    return _buildAdminOverview(ad.totalMembers.value, ad.totalDonation.value.toString());
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAdminOverview(String activeMember, String totalDonation) {
    final dash= Get.find<DashboardController>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Key Metrics Grid
        Row(
          children: [
            CustomMetricCard(
              title: 'Active Members',
              value: activeMember,
              color: AppColors.admin,
            ),
            const SizedBox(width: 16),
            CustomMetricCard(
                title: 'Total Collection',
                value: totalDonation,
                color: AppColors.primary
            ),
          ],
        ),
        const SizedBox(height: 20),
        // Management Action List
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Management Actions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const Divider(height: 20, thickness: 1),
              CustomAdminButton(
                  title: 'Add Donation Manually',
                  icon: FontAwesomeIcons.userPlus,
                  color:AppColors.admin,
                onTap: () {
                  Get.toNamed(RoutesName.addNewMemberPage);
                },
              ),
              CustomAdminButton(
                  title:' Manage Members',
                  icon:FontAwesomeIcons.users,
                  color:AppColors.admin,
                onTap: () {
                    debugPrint(dash.userId.value);
                    debugPrint(dash.name.value);
                  Get.to(() => ManageMembers(
                    firebaseUid: dash.userId.value,
                    currentUsername: dash.name.value,
                  ));
                },
              ),
              CustomAdminButton(
                title:' Community Chat',
                icon:FontAwesomeIcons.users,
                color:AppColors.admin,
                onTap: () {
                  Get.to(() => GroupChatPage(
                    groupId: "Community_group",
                    currentUserId: dash.userId.value,
                    currentUserName: dash.name.value,
                    userRole: dash.role.value,
                  ));
                },
              ),
              CustomAdminButton(
                  title: 'Campaign',
                  icon:FontAwesomeIcons.campground,
                  color:AppColors.admin,
                onTap: () {
                  Get.toNamed(RoutesName.campaignPage);
                }
              ),
              CustomAdminButton(
                  title:'Payment History',
                  icon:FontAwesomeIcons.wallet,
                  color:AppColors.redError,
                onTap: () {
                    Get.toNamed(RoutesName.paymentHistoryPageForAdmin);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
