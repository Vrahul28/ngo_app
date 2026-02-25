import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ngo_app/res/app_colors/app_colors.dart';
import '../../../data/exeception/status.dart';
import '../../../res/routes_name/routes_name.dart';
import '../../../view_models/admin_controller/campaign_controller.dart';
import '../../../widgets/custom_card_campaign.dart';
import '../../../widgets/custom_popup_menu.dart';

enum CampaignMenu { edit, delete }

class CampaignPage extends StatefulWidget {
  const CampaignPage({super.key});

  @override
  State<CampaignPage> createState() => _CampaignPageState();
}

class _CampaignPageState extends State<CampaignPage> {
  final cam= Get.find<CampaignController>();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Campaign', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),
        centerTitle: true,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () async{
              Get.toNamed(
                RoutesName.campaignAddPage,
                arguments: {
                  "edit": false,
                }
                );
            },
            icon: const Icon(Icons.add_box_outlined, color: Colors.black),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0,right: 15.0,top: 5.0, bottom: 10.0),
          child: Obx(
                () {
                  if (cam.rxRequestStatus.value == Status.LOADING) {
                   return const Center(child: CircularProgressIndicator());
                  }

                  if (cam.userCampaign.isEmpty) {
                  return const Center(child: Text('No Campaign found'));
                  }

                  return ListView.builder(
                    itemCount: cam.userCampaign.length,
                    itemBuilder: (context, index) {
                      final hist= cam.userCampaign[index];
                      return CustomCardCampaign(
                        name: hist.title ?? '',
                        email:  hist.description ?? '',
                        amount: hist.targetAmount.toString(),
                        trailing: PopupMenuButton(
                          padding: EdgeInsets.zero,
                          icon: Icon(Icons.more_horiz),
                          color: Colors.white,
                          elevation: 8,
                          offset: const Offset(0, 40),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          onSelected: (value) {
                            switch (value) {
                              case CampaignMenu.edit:
                                cam.title.value.text = hist.title ?? '';
                                cam.des.value.text = hist.description ?? '';
                                cam.amount.value.text = hist.targetAmount.toString();
                                cam.startDate.value.text = hist.startDate ?? '';
                                cam.endDate.value.text = hist.endDate ?? '';
                                Get.toNamed(
                                  RoutesName.campaignAddPage,
                                  arguments: {
                                    "id": hist.id,
                                    "edit": true,
                                  },
                                );
                                break;

                              case CampaignMenu.delete:
                                Get.dialog(
                                  AlertDialog(
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    title: const Text('Delete Campaign?'),
                                    content: const Text('This action cannot be undone.'),
                                    actions: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: AppColors.primary,
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.all(Radius.circular(12)))
                                        ),
                                        onPressed: () {
                                          Get.back();
                                        },
                                        child: Text(
                                            'Cancel',
                                            style: TextStyle(
                                              color: Colors.white,
                                            )),
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.primary,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.all(Radius.circular(12)))
                                        ),
                                        onPressed: () async{ 
                                          Get.back();                               
                                          await cam.deleteCampaign(hist.id ?? '');
                                        },
                                        child: Text(
                                            'Delete',
                                            style: TextStyle(
                                                color: Colors.white,
                                            )),
                                      ),
                                    ],
                                  ),
                                );
                                break;
                            }
                          },
                          itemBuilder: (context) => [
                            CustomPopupMenu<CampaignMenu>(
                              icon: Icons.edit_outlined,
                              title: 'Edit',
                              value: CampaignMenu.edit,
                              color: AppColors.primary,
                            ),
                            CustomPopupMenu<CampaignMenu>(
                              icon: Icons.delete_outline,
                              title: 'Delete',
                              value: CampaignMenu.delete,
                              color: AppColors.primary,
                            ),

                          ],
                        ),
                      );
                    },
                  );
                }
          ),
        ),
      ),
    );
  }
}
