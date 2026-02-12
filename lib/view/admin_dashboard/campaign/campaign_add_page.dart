import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../res/app_colors/app_colors.dart';
import '../../../res/routes_name/routes_name.dart';
import '../../../view_models/admin_controller/campaign_controller.dart';
import '../../../widgets/custom_textfields.dart';

class CampaignAddPage extends StatelessWidget {
  const CampaignAddPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cam= Get.find<CampaignController>();
    final args= Get.arguments;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Add Campaign', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.only(left: 15.0,right: 15.0,top: 5.0, bottom: 10.0),
              child: Column(
                children: [
                  CustomTextFields(
                    controller: cam.title.value,
                    hintText: 'Title',
                    obscure: false,
                  ),
                  const SizedBox(height: 16),
                  CustomTextFields(
                    controller:  cam.des.value,
                    hintText: 'Description',
                    obscure: false,
                  ),
                  const SizedBox(height: 16),
                  CustomTextFields(
                    controller:  cam.amount.value,
                    hintText: 'Target Amount',
                    obscure: false,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                      controller: cam.startDate.value,
                      decoration: InputDecoration(
                          labelText: 'Start Date',
                          suffixIcon: IconButton(
                              onPressed: () {
                                cam.openDatePicker(context, cam.startDate.value);
                              },
                              icon: Icon(Icons.calendar_month,color: AppColors.primary,)
                          ),
                          border: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(12)
                              )
                          ),
                        focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)), borderSide: BorderSide(color: AppColors.primary)),
                      )
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                      controller: cam.endDate.value,
                      decoration: InputDecoration(
                          labelText: 'End Date',
                          suffixIcon: IconButton(
                              onPressed: () {
                                cam.openDatePicker(context,cam.endDate.value,);
                              },
                              icon: Icon(Icons.calendar_month,color: AppColors.primary,)
                          ),
                          border: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(12)
                              )
                          ),
                        focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)), borderSide: BorderSide(color: AppColors.primary)),
                      )
                  ),
                  const SizedBox(height: 30),
                  Obx(
                    () {
                      return ElevatedButton(
                        onPressed: () {
                          if(args['edit']){
                            cam.editCampaign(args['id'],cam.title.value.text, cam.des.value.text, double.parse(cam.amount.value.text), cam.startDate.value.text, cam.endDate.value.text);
                            Get.toNamed(RoutesName.campaignPage);
                          }else{
                            cam.addCampaign(cam.title.value.text, cam.des.value.text, double.parse(cam.amount.value.text), cam.startDate.value.text, cam.endDate.value.text);
                            Get.toNamed(RoutesName.campaignPage);
                          }

                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.admin,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: cam.isLoading.value ? const CircularProgressIndicator() : const Text('Add Campaign', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      );
                    },
                  ),
                ],
              )
          ),
        ),
      ),
    );
  }
}
