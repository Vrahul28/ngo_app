import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../view/chat_page/chat_page.dart';
import '../../view/chat_page/group_chat_page.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();

  // Initialize local notifications
  static Future<void> initialize() async {

  const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

  const DarwinInitializationSettings iosSettings = DarwinInitializationSettings();

  const InitializationSettings settings = InitializationSettings(android: androidSettings, iOS: iosSettings);

  await _notifications.initialize(
    settings: settings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.payload != null) {
          final data = jsonDecode(response.payload!);

          if (data['type'] == 'private') {
            Get.to(() => ChatPage(
              currentUserId: data['receiverId'],
              peerUserId: data['senderId'],
              currentUserName: data['receiverName'],
              peerUserName: data['senderName'],
            ));
          } else {
            Get.to(() => GroupChatPage(
              groupId: data['groupId'],
              currentUserId: data['receiverId'],
              currentUserName: data['receiverName'],
              userRole: data['userRole'],
            ));
          }
        }
      });

  /// ⭐⭐⭐ CREATE ANDROID CHANNEL (THIS WAS MISSING)
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'chat_channel',
    'Chat Messages',
    description: 'Chat notifications',
    importance: Importance.max,
  );

  await _notifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
}



  // show notification when message comes in foreground
  static Future<void> showNotification(RemoteMessage message) async {

  final notification = message.notification;
  const AndroidNotificationDetails androidDetails =
      AndroidNotificationDetails(
    'chat_channel',
    'Chat Messages',
    channelDescription: 'Chat notifications',
    importance: Importance.max,
    priority: Priority.high,
    playSound: true,
  );

  const NotificationDetails details = NotificationDetails(android: androidDetails);

  final data = message.data;
  debugPrint("print data: ${data.toString()}");

  await _notifications.show(
    id: message.hashCode,
    title: notification?.title ?? data['senderName'] ?? "New Message",
    body: notification?.body ?? data['message'] ?? "",
    notificationDetails: details,
    payload: jsonEncode(data),
  );
}


}
