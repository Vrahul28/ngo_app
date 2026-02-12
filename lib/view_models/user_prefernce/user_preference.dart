import 'package:shared_preferences/shared_preferences.dart';

class UserPreference {
  Future<String> getEmail() async {
    final SharedPreferences sd = await SharedPreferences.getInstance();
    String email = sd.getString("email") ?? '';
    return email;
  }

  Future<String> getToken() async {
    final SharedPreferences sd = await SharedPreferences.getInstance();
    String token = sd.getString("token") ?? '';
    return token;
  }

  Future<String> getRefreshToken() async {
    final SharedPreferences sd = await SharedPreferences.getInstance();
    String token = sd.getString("refreshToken") ?? '';
    return token;
  }

  Future<String> getUserId() async {
    final SharedPreferences sd = await SharedPreferences.getInstance();
    String userId = sd.getString("userId") ?? '';
    return userId;
  }

  Future<String> getUserName() async {
    final SharedPreferences sd = await SharedPreferences.getInstance();
    String userName = sd.getString("userName") ?? '';
    return userName;
  }

  Future<bool> saveNewToken(String refreshToken) async {
    final SharedPreferences sd = await SharedPreferences.getInstance();
    sd.setString('token', refreshToken);
    return true;
  }

  Future<bool> saveRefreshToken(String refreshToken) async {
    final SharedPreferences sd = await SharedPreferences.getInstance();
    sd.setString('refreshToken', refreshToken);
    return true;
  }

  Future<String> getRole() async {
    final SharedPreferences sd = await SharedPreferences.getInstance();
    String role = sd.getString("role") ?? '';
    return role;
  }

  Future<String> getFirebaseId() async {
    final SharedPreferences sd = await SharedPreferences.getInstance();
    String id = sd.getString("firebaseUid") ?? '';
    return id;
  }

  Future<bool> saveUser(
      String email,
      String token,
      String userID,
      String userName,
      String role,
      String refreshToken,
      String firebaseId,
      ) async {
    final SharedPreferences sd = await SharedPreferences.getInstance();
    sd.setString('email', email);
    sd.setString('token', token);
    sd.setString('userId', userID);
    sd.setString('userName', userName);
    sd.setString('role', role);
    sd.setString('refreshToken', refreshToken);
    sd.setString('firebaseUid', firebaseId);
    return true;
  }

  Future<bool> logout() async {
    SharedPreferences s = await SharedPreferences.getInstance();
    s.clear();
    return true;
  }
}