import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../view/chat_page/chat_page.dart';
import '../../view/chat_page/group_chat_page.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();

  // Initialize local notifications
  static Future<void> initialize() async {

  const AndroidInitializationSettings androidSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const DarwinInitializationSettings iosSettings =
      DarwinInitializationSettings();

  const InitializationSettings settings =
      InitializationSettings(android: androidSettings, iOS: iosSettings);

  await _notifications.initialize(
    settings: settings,
    onDidReceiveNotificationResponse: (NotificationResponse response) {

      if(response.payload != null){
        final data = jsonDecode(response.payload!);

        if(data['type'] == 'private'){
          Get.to(() => ChatPage(
            currentUserId: data['receiverId'],
            peerUserId: data['senderId'],
            currentUserName: data['receiverName'],
            peerUserName: data['senderName'],
          ));
        }else{
          Get.to(() => GroupChatPage(
            groupId: data['groupId'],
            currentUserId: data['receiverId'],
            currentUserName: data['receiverName'],
            userRole: data['userRole'],
          ));
        }
      }

    },
  );
  }


  // show notification when message comes in foreground
  static Future<void> showNotification(RemoteMessage message) async {

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

   await _notifications.show(
  id: message.hashCode,
  title: message.notification?.title ?? "New Message",
  body: message.notification?.body ?? "",
  notificationDetails: details,
  payload: jsonEncode(message.data),
  );
  }

  

}
