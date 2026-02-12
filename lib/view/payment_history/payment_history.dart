import 'package:flutter/material.dart';
import '../../data/exeception/status.dart';
import '../../res/app_colors/app_colors.dart';
import 'package:get/get.dart';
import '../../view_models/user_dashboard_controller/profile_controller.dart';
import '../../view_models/user_dashboard_controller/user_dashborad_controller.dart';
import '../../widgets/custom_card_payment_history_user.dart';

class PaymentHistory extends StatelessWidget {
  const PaymentHistory({super.key});

  @override
  Widget build(BuildContext context) {
    final user= Get.find<UserDashboardController>();
    final profile= Get.find<ProfileController>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Payment History', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // AD 2: Sponsorship Banner (Top of List)
                // Container(
                //   padding: const EdgeInsets.all(12),
                //   decoration: BoxDecoration(
                //     color: Colors.purple.shade100,
                //     borderRadius: BorderRadius.circular(12),
                //     border: Border.all(color: Colors.purple.shade300),
                //   ),
                //   child: Column(
                //     children: [
                //       Row(
                //         mainAxisAlignment: MainAxisAlignment.center,
                //         children: [
                //           const Icon(FontAwesomeIcons.solidStar, size: 16, color: Colors.purple),
                //           const SizedBox(width: 8),
                //           Text('Ad: Health Insurance Partner', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.purple.shade800)),
                //         ],
                //       ),
                //       const SizedBox(height: 4),
                //       Text('Get 10% off your annual premium when you mention \'Hope\'.', style: TextStyle(fontSize: 12, color: Colors.purple.shade700)),
                //     ],
                //   ),
                // ),
                // const SizedBox(height: 20),
                Obx(
                  () => Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(12)),
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        const Text('Total Contributions', style: TextStyle(fontSize: 14, color: Colors.grey)),
                        Text('₹${user.totalDonation.value}', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: AppColors.primary)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text('Recent Transactions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Obx(
                  () {
                    switch (profile.rxRequestStatus.value) {
                      case Status.LOADING:
                        return SizedBox(
                          child: Center(child: CircularProgressIndicator()),
                        );
                      case Status.ERROR:
                        return SizedBox(
                          child: Center(child: Text(profile.error.toString())),
                        );
                      case Status.COMPLETED:
                        return profile.paymentHistory.isEmpty?
                        SizedBox(
                          height: MediaQuery.of(context).size.height,
                          child: Text('No Payment History Found'),
                        ):
                        SizedBox(
                          height: MediaQuery.of(context).size.height,
                          child: ListView.builder(
                            itemCount: profile.paymentHistory.length,
                            itemBuilder: (context, index) {
                              final pro = profile.paymentHistory[index];
                              return CustomCardPaymentHistoryUser(
                                amount: pro.amount.toString(),
                                date: pro.paymentDate != null
                                    ? profile.formatDate(pro.paymentDate!)
                                    : '',
                                status: pro.success!,
                              );
                            },
                          ),
                        );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
