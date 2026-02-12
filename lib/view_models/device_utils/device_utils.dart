import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class DeviceUtils extends GetxController{
  final deviceName= ''.obs;
  final deviceId= ''.obs;

  static final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  Future<void> getDeviceInfo() async {
    if (kIsWeb) {
      deviceName.value= "Web Browser";
      deviceId.value= "WEB-${DateTime.now().millisecondsSinceEpoch}";
    }

    if (Platform.isAndroid) {
      final androidInfo = await _deviceInfo.androidInfo;
      deviceName.value= "${androidInfo.brand} ${androidInfo.model}";
      deviceId.value= androidInfo.id ?? androidInfo.fingerprint;
    }

    if (Platform.isIOS) {
      final iosInfo = await _deviceInfo.iosInfo;
      deviceName.value= iosInfo.name ?? "iPhone";
      deviceId.value= iosInfo.identifierForVendor ?? "IOS-UNKNOWN";
    }
  }
}