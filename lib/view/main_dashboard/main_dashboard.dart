import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ngo_app/res/routes_name/routes_name.dart';
import '../../res/app_colors/app_colors.dart';
import 'package:get/get.dart';
import '../../view_models/admin_controller/admin_controller.dart';
import '../../view_models/chat_controller/group_controller.dart';
import '../../view_models/dashboard_controller/dashboard_controller.dart';
import '../campaign_page/user_campaign_page.dart';
import '../chat_page/chatList_page.dart';
import '../profile_page/profile_page.dart';
import '../user_dashboard/user_dashboard.dart';

class MainDashboard extends StatelessWidget {
  const MainDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final dash= Get.find<DashboardController>();
    final admin= Get.find<AdminController>();
    final groupController = Get.find<GroupController>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
            'Hope Foundation',
            style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 18
            )
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Obx(
            () {
              return Visibility(
                visible: dash.role.value == 'Admin',
                child:   Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      admin.fetchTotalCountOfMembers();
                      admin.totalDonationCount();
                      Get.toNamed(RoutesName.adminDashboardPage);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:Colors.blue,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                    ),
                    child: Text('Switch to Admin', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                ),
              );
            },
          ),

        ],
      ),
      body: Obx(
        () {
          return PageView(
            controller: dash.pageController,
            physics: const NeverScrollableScrollPhysics(),
            onPageChanged: (value) {
              dash.onPageChangedWithOutAnimation(value);
            },
            children: [
              UserDashboard(),
              UserCampaignPage(),
              ChatListPage(
                userType: dash.role.value,
                firebaseUid: dash.userId.value,
                userName: dash.name.value,
              ),
              ProfilePage(),
            ],
          );
        },
      ),
      bottomNavigationBar: Obx(
        () {
          return BottomNavigationBar(
            currentIndex: dash.currentIndex.value,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: AppColors.primary,
            unselectedItemColor: Colors.grey,
            backgroundColor: Colors.white,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            unselectedLabelStyle: const TextStyle(fontSize: 12),
            onTap: (index) {
              dash.updateTabSelection(index);
            },
            items: const [
              BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.houseChimney), label: 'Dashboard'),
              BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.bullhorn), label: 'Campaigns'),
              BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.comments), label: 'Chat'),
              BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.userCircle), label: 'Profile'),
            ],
          );
        },
      )
    );
  }
}
