import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:ngo_app/res/routes_name/routes_name.dart';
import '../../res/app_colors/app_colors.dart';
import '../../view_models/signUp_controller/signUp_controller.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({super.key});

  @override
  Widget build(BuildContext context) {
    final signUpControl= Get.put(SignupController());
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(FontAwesomeIcons.handHoldingHeart, size: 70, color: AppColors.primary),
                    const SizedBox(height: 16),
                    Text('Create Account',
                        style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1F2937)
                        )),
                    Text('Join the mission as a Donor.',
                        style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey
                        )
                    ),
                    const SizedBox(height: 32),
                    TextField(
                        controller: signUpControl.nameController.value,
                        keyboardType: TextInputType.name,
                        decoration: const InputDecoration(
                            labelText: 'Full Name',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(12)
                                )
                            )
                        )
                    ),
                    const SizedBox(height: 16),
                    TextField(
                        controller: signUpControl.emailController.value,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                            labelText: 'Email Address',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(12)
                                )
                            )
                        )
                    ),
                    const SizedBox(height: 16),
                    TextField(
                        controller: signUpControl.passwordController.value,
                        obscureText: true,
                        decoration: const InputDecoration(
                            labelText: 'Create Password (Min 8 chars)',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(12)
                                )
                            )
                        )
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                        controller: signUpControl.contactController.value,
                        obscureText: false,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            labelText: 'Contact No.',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(12)
                                )
                            )
                        )
                    ),
                    const SizedBox(height: 24),
                    Obx(
                          () {
                        return ElevatedButton(
                          onPressed: () {
                            signUpControl.singUp();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: signUpControl.isLoading.value?
                          const CircularProgressIndicator(color: Colors.white):
                          const Text('Sign Up', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                        );
                      },
                    ),
                    TextButton(
                      onPressed: () {
                        Get.toNamed(RoutesName.signInPage);
                      },
                      child: const Text('Already a member? Sign In Here', style: TextStyle(color: AppColors.primary)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

