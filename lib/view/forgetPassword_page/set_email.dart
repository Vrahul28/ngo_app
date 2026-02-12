import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../res/app_colors/app_colors.dart';
import '../../view_models/forgetPassword_controller/forgetPassword_controller.dart';
import '../../widgets/custom_textfields.dart';

class SetEmailPassword extends StatelessWidget {
  const SetEmailPassword({super.key});

  @override
  Widget build(BuildContext context) {
    final ForgetPasswordController fp= Get.put(ForgetPasswordController());
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(FontAwesomeIcons.handHoldingHeart, size: 70, color: AppColors.primary),
            const SizedBox(height: 16),
            Text('Enter your email to reset your password.',
                style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey
                )
            ),
            const SizedBox(height: 32),
            CustomTextFields(
              controller: fp.emailController.value,
              hintText: 'Enter Email',
              obscure: false,
            ),
            const SizedBox(height: 24),
            Obx(
                  () {
                return ElevatedButton(
                  onPressed: () {
                    fp.forgetPass();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: fp.isLoading.value?
                  const CircularProgressIndicator(color: Colors.white):
                  const Text('Verify Email', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
