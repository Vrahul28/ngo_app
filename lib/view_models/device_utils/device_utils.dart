import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class DeviceUtils extends GetxController{
  final deviceName= ''.obs;
  final deviceId= ''.obs;
  final fcmToken= ''.obs;

  static final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  Future<void> getDeviceInfo() async {
    if (kIsWeb) {
      deviceName.value= "Web Browser";
      deviceId.value= "WEB-${DateTime.now().millisecondsSinceEpoch}";
    }

    if (Platform.isAndroid) {
      final androidInfo = await _deviceInfo.androidInfo;
      deviceName.value= "${androidInfo.brand} ${androidInfo.model}";
      deviceId.value= androidInfo.id;
    }

    if (Platform.isIOS) {
      final iosInfo = await _deviceInfo.iosInfo;
      deviceName.value= iosInfo.name;
      deviceId.value= iosInfo.identifierForVendor ?? "IOS-UNKNOWN";
    }
  }

  Future<String?> getFcmToken() async {
    final String? token = await FirebaseMessaging.instance.getToken();
    debugPrint('FCM TOKEN AT APP START: $token');
    fcmToken.value= token ?? '';
    return token;
  }
}