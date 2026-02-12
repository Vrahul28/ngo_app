import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../res/URLs/URLs.dart';
import 'package:flutter/material.dart';
import '../device_utils/device_utils.dart';
import '../user_prefernce/user_preference.dart';

class AuthService {
  final UserPreference user = UserPreference();
  final DeviceUtils du = DeviceUtils();

  Future<bool> refreshToken() async {
    try {
      await du.getDeviceInfo();

      final data = {
        "refreshToken": await user.getRefreshToken(),
        "deviceId": du.deviceId.value,
        "deviceName": du.deviceName.value,
      };

      final response = await http.post(
        Uri.parse(Urls.refreshTokenAPI),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        debugPrint('Refresh Token API executed');

        final json = jsonDecode(response.body);
        await user.saveNewToken(json['accessToken']);
        await user.saveRefreshToken(json['refreshToken']);
        return true;
      }

      return false;
    } catch (_) {
      return false;
    }
  }
}
