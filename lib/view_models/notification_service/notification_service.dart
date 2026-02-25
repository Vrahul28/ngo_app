import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../view/chat_page/chat_page.dart';
import '../../view/chat_page/group_chat_page.dart';
import 'local_notification_service.dart';

class NotificationService {

  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  // static Future init(String uid, String userName) async {

  //   FirebaseMessaging messaging = FirebaseMessaging.instance;

  //   // Android 13+
  //   await messaging.requestPermission();

  //   String? token = await messaging.getToken();

  //   debugPrint("FCM TOKEN: $token");

  //   if (token == null) return;

  //   // 🔥 CREATE USER DOCUMENT IF NOT EXISTS
  //   await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(uid)
  //       .set({
  //     'uid': uid,
  //     'name': userName,
  //     'fcmToken': token,
  //     'updatedAt': FieldValue.serverTimestamp(),
  //   }, SetOptions(merge: true));
  // }

  // Initialize all listeners
  static Future<void> initialize(String currentUserId) async {

    // Request permission (VERY IMPORTANT for Android 13+ and iOS)
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Foreground message
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint("FOREGROUND MESSAGE RECEIVED");
      // SHOW LOCAL NOTIFICATION
      if (message.notification != null) {
        LocalNotificationService.showNotification(message);
      }
   });

    // When app is in BACKGROUND and user taps notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleNotificationClick(message, currentUserId);
    });

    // When app is CLOSED and opened via notification
    RemoteMessage? initialMessage = await _messaging.getInitialMessage();

    if (initialMessage != null) {
      _handleNotificationClick(initialMessage, currentUserId);
    }
  }

  // Navigate to correct chat
  static void _handleNotificationClick(RemoteMessage message, String currentUserId) {

    final data = message.data;

    String type = data['type']; // private OR group

    if (type == "private") {

      Get.to(() => ChatPage(
        currentUserId: currentUserId,
        peerUserId: data['senderId'], 
        currentUserName: data['senderName'],
        peerUserName: data['senderName'],
      ));

    } else if (type == "group") {

      Get.to(() => GroupChatPage(
            groupId: data['groupId'],
            currentUserId: currentUserId,
            currentUserName: data['senderName'],
            userRole: data['userRole'],
          ));
    }
  }
}
