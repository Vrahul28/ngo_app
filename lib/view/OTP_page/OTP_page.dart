import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:ngo_app/view_models/OTP_controller/OTP_controller.dart';
import '../../res/app_colors/app_colors.dart';
import '../../widgets/custom_textfields.dart';

class OtpPage extends StatelessWidget {
  const OtpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args= Get.arguments;
    final verifyEmail= Get.put(OtpController());
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(FontAwesomeIcons.handHoldingHeart, size: 70, color: AppColors.primary),
            const SizedBox(height: 32),
            CustomTextFields(
              controller: verifyEmail.codeController.value,
              hintText: 'Enter OTP',
              obscure: false,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                verifyEmail.verifyEmail(args['email']);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: verifyEmail.isLoading.value?
              const CircularProgressIndicator(color: Colors.white):
              const Text('Verify Email', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
