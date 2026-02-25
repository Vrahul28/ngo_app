import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:ngo_app/res/routes_name/routes_name.dart';
import '../../res/app_colors/app_colors.dart';
import '../../view_models/signUp_controller/signUp_controller.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final form= GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final signUpControl= Get.put(SignupController());
    return Scaffold(
      body: Form(
        key: form,
        child: SingleChildScrollView(
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
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: signUpControl.nameController.value,
                          keyboardType: TextInputType.name,
                          validator: (value) {
                            if (value!.isEmpty) {
                            return 'Enter Your Name';
                          }
                          return null;
                          },
                          decoration: InputDecoration(
                              labelText: 'Full Name',
                              labelStyle: TextStyle(
                                color: AppColors.blackColor
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(12)
                                  )
                              ),
                              focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            borderSide: BorderSide(color: AppColors.primary),
                          ),
                          )
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: signUpControl.emailController.value,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                            return 'Enter Your Email Address';
                          }

                          final emailRegex = RegExp(
                            r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]+$',
                          );

                          if (!emailRegex.hasMatch(value)) {
                            return 'Enter valid email (example: abc@gmail.com)';
                          }

                          return null;
                          },
                          decoration: const InputDecoration(
                              labelText: 'Email Address',
                              labelStyle: TextStyle(
                                color: AppColors.blackColor
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(12)
                                  )
                              ),
                              focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            borderSide: BorderSide(color: AppColors.primary),
                          ),
                          )
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: signUpControl.passwordController.value,
                          obscureText: true,
                          validator: (value) {
                            if (value!.isEmpty) {
                            return 'Enter Your Unique Password';
                          }

                          if (value.length < 8) {
                            return 'Password must be at least 8 characters';
                          }
                          return null;
                          },
                          decoration: const InputDecoration(
                              labelText: 'Create Password (Min 8 chars)',
                              labelStyle: TextStyle(
                                color: AppColors.blackColor
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(12)
                                  )
                              ),
                              focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            borderSide: BorderSide(color: AppColors.primary),
                          ),
                          )
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: signUpControl.contactController.value,
                          obscureText: false,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            final phoneRegex = RegExp(r'^[0-9]{10}$');

                          if (!phoneRegex.hasMatch(value!)) {
                            return 'Contact number must be exactly 10 digits';
                          }
                          return null;
                          },
                          decoration: const InputDecoration(
                              labelText: 'Contact No.',
                              labelStyle: TextStyle(
                                color: AppColors.blackColor
                              ),
                              border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            borderSide: BorderSide(color: AppColors.primary),
                          ),
                          )
                      ),
                      const SizedBox(height: 24),
                      Obx(
                            () {
                          return ElevatedButton(
                            onPressed: () {
                              if(form.currentState!.validate()){
                                form.currentState!.save();
                                signUpControl.singUp();
                              }
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
      ),
    );
  }
}

