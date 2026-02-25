import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../res/app_colors/app_colors.dart';
import '../../view_models/admin_controller/admin_controller.dart';
import '../../widgets/custom_textfields.dart';

class AddNewMember extends StatelessWidget {
  const AddNewMember({super.key});

  @override
  Widget build(BuildContext context) {
    final AdminController ad= Get.find<AdminController>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Add Donation', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                TextFormField(
                    controller: ad.contact.value,
                    onChanged: (value) => ad.onNumberChanged(ad.contact.value.text),
                    decoration: InputDecoration(
                        labelText: 'Phone Number',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)
                            )
                        )
                    )
                ),
                const SizedBox(height: 16),
                Obx(
                  () {
                    return TextFormField(
                        controller: ad.name.value,
                        readOnly: true,
                        decoration: InputDecoration(
                            labelText: 'Name',
                            suffixIcon: ad.isLoading.value
                                ? Padding(
                              padding: EdgeInsets.all(10),
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                                : null,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(12)
                                )
                            )
                        )
                    );
                  },
                ),
                const SizedBox(height: 16),
                Obx(
                      () {
                    return TextFormField(
                        controller: ad.email.value,
                        readOnly: true,
                        decoration: InputDecoration(
                            labelText: 'Email',
                            suffixIcon: ad.isLoading.value
                                ? Padding(
                              padding: EdgeInsets.all(10),
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                                : null,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(12)
                                )
                            )
                        )
                    );
                  },
                ),
                const SizedBox(height: 16),
                CustomTextFields(
                  controller: ad.donationAmount.value,
                  hintText: 'Donation Amount (\$)',
                  obscure: false,
                ),
                const SizedBox(height: 24),
                Obx(
                  () {
                    return ElevatedButton(
                      onPressed: () {
                        ad.addDonation(int.parse(ad.donationAmount.value.text));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.admin,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: ad.isLoading.value ? CircularProgressIndicator(color: Colors.white) : const Text('ADD DONATION', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
