import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ngo_app/view_models/user_dashboard_controller/user_dashborad_controller.dart';
import '../../res/app_colors/app_colors.dart';
import '../../res/routes_name/routes_name.dart';
import '../../utils/utils.dart';
import 'package:get/get.dart';

class UserDashboard extends StatelessWidget {
  const UserDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Get.find<UserDashboardController>();
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Welcome, Donor! 👋', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                const SizedBox(height: 20),
                // Impact Card
                Obx(
                  () {
                    return Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Total Lifetime Contribution', style: TextStyle(fontSize: 14, color: Colors.white70)),
                              const SizedBox(height: 4),
                              Text('₹ ${user.totalDonation.value}', style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w900, color: Colors.white)),
                            ],
                          ),
                          Icon(FontAwesomeIcons.handsHelping, size: 50, color: Colors.white.withOpacity(0.8)),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                // Reminder Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.warning),
                    boxShadow: [BoxShadow(color: AppColors.warning.withOpacity(0.1), blurRadius: 5)],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(FontAwesomeIcons.bell, size: 20, color: AppColors.warning.withOpacity(0.8)),
                          const SizedBox(width: 8),
                          const Text('Recurring Donation Reminder', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF92400E))),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text('Your monthly contribution of \$50.00 is due on:', style: TextStyle(fontSize: 14, color: Color(0xFF92400E))),
                      const Text('Dec 15, 2025', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF92400E))),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () {
                          Utils.showSnackBar('','Managing Subscription...',true);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.warning,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 40),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text('Manage Subscription', style: TextStyle(fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Quick Donate CTA
                ElevatedButton.icon(
                  onPressed: () {
                    Get.toNamed(RoutesName.donatePage);
                  },
                  icon: const Icon(FontAwesomeIcons.moneyBillWave, size: 20),
                  label: const Text('Quick Donate Now', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade600,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 55),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    shadowColor: Colors.blue.shade800,
                    elevation: 8,
                  ),
                ),
                const SizedBox(height: 24),
                // AD 1: Native Sponsored Content (Mid-page)
                const Text('SPONSORED PARTNER', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey, letterSpacing: 1.0)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40, height: 40,
                        decoration: BoxDecoration(color: const Color(0xFF007AFF), borderRadius: BorderRadius.circular(8)),
                        child: const Center(child: Text('S', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                      ),
                      const SizedBox(width: 12),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Sustainable Tech Co.', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                          Text(
                              'Supporting our clean water initiative this month.',
                              style: TextStyle(fontSize: 8, color: Colors.grey)
                          ),
                        ],
                      ),
                      const Spacer(),
                      const Icon(FontAwesomeIcons.arrowRight, size: 16, color: Colors.grey),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Project Updates
                // const Text(
                //   'Admin Announcements',
                //   style: TextStyle(
                //       fontSize: 20,
                //       fontWeight: FontWeight.bold
                //   ),
                //   textAlign: TextAlign.left,
                // ),
                // const SizedBox(height: 15),
                // Container(
                //   padding: const EdgeInsets.all(16),
                //   decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)]),
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       const Text('New School Project Launched!', style: TextStyle(fontWeight: FontWeight.w600)),
                //       const SizedBox(height: 4),
                //       Row(
                //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //         children: [
                //           const Text('Check out the photo gallery!', style: TextStyle(fontSize: 12, color: Colors.grey)),
                //           Text('2h ago', style: TextStyle(fontSize: 12, color: Colors.grey.shade400)),
                //         ],
                //       ),
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
