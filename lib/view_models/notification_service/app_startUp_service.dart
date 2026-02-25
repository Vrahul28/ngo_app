
class AppStartupService {

  // static Future<void> afterLogin(String userId) async {
  //   // 1. get FCM token
  //   String? token = await FirebaseMessaging.instance.getToken();

  //   if(token == null) return;

  //   debugPrint("SAVING TOKEN FOR USER: $userId");
  //   debugPrint("TOKEN: $token");

  //   // 2. save to firestore
  //   await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(userId)
  //       .set({
  //     'fcmToken': token,
  //     'updatedAt': FieldValue.serverTimestamp(),
  //   }, SetOptions(merge: true));

  //   // 3. listen token refresh (VERY IMPORTANT)
  //   FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
  //     await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(userId)
  //         .update({'fcmToken': newToken});
  //   });
  // }
}
