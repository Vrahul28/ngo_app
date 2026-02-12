import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:ngo_app/view_models/forgetPassword_controller/forgetPassword_controller.dart';
import '../../res/app_colors/app_colors.dart';
import '../../widgets/custom_textfields.dart';


class ForgetPasswordPage extends StatelessWidget {
  const ForgetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ForgetPasswordController fp= Get.find<ForgetPasswordController>();
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(FontAwesomeIcons.handHoldingHeart, size: 70, color: AppColors.primary),
                  const SizedBox(height: 16),
                  Text('Forget Password',
                      style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1F2937)
                      )),
                  Text('Enter your email to reset your password.',
                      style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey
                      )
                  ),
                  const SizedBox(height: 32),
                  CustomTextFields(
                    controller: fp.emailController.value,
                    hintText: 'Email',
                    obscure: false,
                  ),
                  const SizedBox(height: 16),
                  CustomTextFields(
                    controller: fp.passwordController.value,
                    hintText: 'New Password',
                    obscure: true,
                  ),
                  const SizedBox(height: 16),
                  CustomTextFields(
                    controller: fp.confirmPasswordController.value,
                    hintText: 'Confirm Password',
                    obscure: true,
                  ),
                  const SizedBox(height: 24),
                  Obx(
                        () {
                      return ElevatedButton(
                        onPressed: () {
                          fp.resetPassword();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: fp.isLoading.value?
                        const CircularProgressIndicator(color: Colors.white):
                        const Text('Submit', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
