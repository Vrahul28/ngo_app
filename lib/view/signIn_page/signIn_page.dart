import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../res/app_colors/app_colors.dart';
import '../../res/routes_name/routes_name.dart';
import '../../view_models/chat_controller/group_controller.dart';
import '../../view_models/device_utils/device_utils.dart';
import '../../view_models/signIn_controller/signIn_controller.dart';
import '../../widgets/custom_textfields.dart';


class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    final signIn= Get.put(SignInController());
    final group= Get.put(GroupController());
    final devicUtil= Get.put(DeviceUtils());
    return Scaffold(
      backgroundColor: Colors.white,
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
                  Text( 'Sign In',
                      style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1F2937)
                      )),
                  Text('Access your Donor or Admin dashboard.',
                      style: const TextStyle(
                          fontSize: 13,
                          color: Colors.grey
                      )
                  ),
                  const SizedBox(height: 32),
                  CustomTextFields(
                    controller: signIn.emailController.value,
                    hintText: 'Email Address',
                    obscure: false,
                  ),
                  const SizedBox(height: 16),
                  CustomTextFields(
                    controller: signIn.passwordController.value,
                    hintText: 'Password',
                    obscure: true,
                  ),
                  Align(
                    alignment: AlignmentGeometry.bottomRight,
                    child: TextButton(
                      onPressed: () {
                        Get.toNamed(RoutesName.setEmailPage);
                      },
                      child: const Text('Forget Password',
                        style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Obx(() {
                      return ElevatedButton(
                        onPressed: () async{
                          await devicUtil.getDeviceInfo();
                          await signIn.singIn(devicUtil.deviceName.value,devicUtil.deviceId.value);
                          await group.createGroupIfNotExists(signIn.userName.value,signIn.userRole.value,signIn.userId.value);

                          if (!await group.isUserInGroup(userId: signIn.firebaseUid.value)) {
                            await group.addUserToGroup(
                              userId: signIn.firebaseUid.value,
                              userName: signIn.userName.value,
                              role: signIn.userRole.value,
                            );
                          }
                          
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: signIn.isLoading.value?
                        const CircularProgressIndicator(color: Colors.white):
                        const Text('Sign IN', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      );
                    },
                  ),
                  TextButton(
                    onPressed: () {
                      Get.toNamed(RoutesName.signUpPage);
                    },
                    child: const Text('Need an account? Sign Up', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),
        ),
      )
    );
  }
}

