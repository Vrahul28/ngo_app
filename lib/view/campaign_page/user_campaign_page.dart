import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/exeception/status.dart';
import '../../res/routes_name/routes_name.dart';
import '../../view_models/admin_controller/campaign_controller.dart';
import '../../widgets/custom_campaign_card_user.dart';


class UserCampaignPage extends StatelessWidget {
  const UserCampaignPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cam = Get.find<CampaignController>();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(left: 15,right: 15),
        child: Obx(() {
          switch (cam.rxRequestStatus.value) {
            case Status.LOADING:
              return const Center(child: CircularProgressIndicator());
            case Status.ERROR:
              return Center(child: Text(cam.error.toString()));
            case Status.COMPLETED:
              return CustomScrollView(
                slivers: [
                  /// Banner
                  // SliverToBoxAdapter(
                  //   child: Container(
                  //     width: double.infinity,
                  //     padding: const EdgeInsets.all(16),
                  //     decoration: BoxDecoration(
                  //       color: Colors.yellow.shade100,
                  //       borderRadius: BorderRadius.circular(12),
                  //       border: Border(
                  //         left: BorderSide(
                  //           color: AppColors.warning,
                  //           width: 4,
                  //         ),
                  //       ),
                  //     ),
                  //     child: Column(
                  //       crossAxisAlignment: CrossAxisAlignment.start,
                  //       children: const [
                  //         Text(
                  //           'SPONSORED INITIATIVE',
                  //           style: TextStyle(
                  //             fontSize: 12,
                  //             fontWeight: FontWeight.w600,
                  //           ),
                  //         ),
                  //         SizedBox(height: 4),
                  //         Text(
                  //           'Big Bank Matches All Donations!',
                  //           style: TextStyle(
                  //             fontSize: 20,
                  //             fontWeight: FontWeight.bold,
                  //           ),
                  //         ),
                  //         SizedBox(height: 4),
                  //         Text(
                  //           'Ends November 30th. Double your impact now!',
                  //           style: TextStyle(fontSize: 14),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),

                  /// Space below banner
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 10),
                  ),

                  /// Empty state
                  if (cam.userRole.value == 'Admin'?cam.userCampaign.isEmpty: cam.campaign.isEmpty)
                    const SliverFillRemaining(
                      child: Center(child: Text('No Result found')),
                    )
                  else
                  /// Campaign List
                  cam.userRole.value == 'Admin'?
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                            (context, index) {
                          final hist = cam.userCampaign[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10), // 🔥 spacing
                            child: CustomCampaignCardUser(
                              title: hist.title ?? '',
                              des: hist.description ?? '',
                              amount: '₹ ${hist.targetAmount?.toString()}',
                              onPressed: () {
                                Get.toNamed(RoutesName.donatePage);
                              },
                            ),
                          );
                        },
                        childCount: cam.userCampaign.length,
                      ),
                    ) :
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (context, index) {
                        final hist = cam.campaign[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10), // 🔥 spacing
                          child: CustomCampaignCardUser(
                            title: hist.title ?? '',
                            des: hist.description ?? '',
                            amount: '₹ ${hist.targetAmount?.toString()}',
                            onPressed: () {
                              Get.toNamed(RoutesName.donatePage);
                            },
                          ),
                        );
                      },
                      childCount: cam.campaign.length,
                    ),
                  ),
                ],
              );
          }
        }),
      ),
    );
  }

}
