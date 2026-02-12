import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:ngo_app/res/routes_name/routes_name.dart';
import 'package:ngo_app/view_models/user_prefernce/user_preference.dart';
import '../../res/app_colors/app_colors.dart';
import '../../view_models/dashboard_controller/dashboard_controller.dart';
import '../../view_models/user_dashboard_controller/profile_controller.dart';
import '../../widgets/custom_profile_button.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final UserPreference user= UserPreference();
    final profile= Get.find<ProfileController>();
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 120),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(FontAwesomeIcons.solidCircleUser, size: 40, color: Colors.grey),
                      const SizedBox(width: 12),
                      Obx(
                        () {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(profile.name.value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                              Text(profile.email.value, style: const TextStyle(fontSize: 14, color: Colors.grey)),
                            ],
                          );
                        },
                      ),

                    ],
                  ),
                  const Divider(height: 30),
                  CustomProfileButton(
                    title: 'View Payment History',
                    icon: FontAwesomeIcons.receipt,
                    color: AppColors.admin,
                    onTap: () {
                      profile.fetchTotalDonationByUser(profile.userID.value);
                      Get.toNamed(RoutesName.paymentHistoryPage);
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () async {
                      profile.logout(await user.getRefreshToken());
                      user.logout();
                      Get.deleteAll();
                      Get.toNamed(RoutesName.signInPage);
                    },
                    icon: const Icon(FontAwesomeIcons.signOutAlt),
                    label: const Text('Log Out', style: TextStyle(fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.redError.withOpacity(0.1),
                      foregroundColor: AppColors.redError,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: AppColors.redError.withOpacity(0.5))),
                      elevation: 0,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
