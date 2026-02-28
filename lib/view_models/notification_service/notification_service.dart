import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../view/chat_page/chat_page.dart';
import '../../view/chat_page/group_chat_page.dart';
import 'local_notification_service.dart';

class NotificationService {

  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static StreamSubscription<RemoteMessage>? onMessageSub;
  static StreamSubscription<RemoteMessage>? onMessageOpenedAppSub;
  static bool isInitialized = false;

  /// Keep recently handled message IDs to avoid duplicate local notifications.
  static final Map<String, DateTime> handledMessageIds = {};
  static const Duration dedupeWindow = Duration(minutes: 2);

  // Initialize all listeners
  static Future<void> initialize(String currentUserId) async {

    // local plugin initialization should happen before listeners.
    await LocalNotificationService.initialize();

    // Request permission (VERY IMPORTANT for Android 13+ and iOS)
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Foreground message
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async{
      debugPrint("FOREGROUND MESSAGE RECEIVED");
      // SHOW LOCAL NOTIFICATION
       await onMessageSub?.cancel();
       await onMessageOpenedAppSub?.cancel();

       onMessageSub = FirebaseMessaging.onMessage.listen((
        RemoteMessage message,
      ) {
        if (!shouldHandleMessage(message)) {
          return;
        }
      });

   });

    // When app is in BACKGROUND and user taps notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // _handleNotificationClick(message, currentUserId);
      // Show foreground local notification exactly once.
      LocalNotificationService.showNotification(message);
    });

    // When app is CLOSED and opened via notification
    // RemoteMessage? initialMessage = await _messaging.getInitialMessage();
    onMessageOpenedAppSub = FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      handleNotificationClick(message, currentUserId);
    });

    // if (initialMessage != null) {
    //   _handleNotificationClick(initialMessage, currentUserId);
    // }

    if (!isInitialized) {
      RemoteMessage? initialMessage = await _messaging.getInitialMessage();
      if (initialMessage != null) {
        handleNotificationClick(initialMessage, currentUserId);
      }
    }
    isInitialized = true;
  }



  // Navigate to correct chat
  // static void _handleNotificationClick(RemoteMessage message, String currentUserId) {

  //   final data = message.data;

  //   String type = data['type']; // private OR group

  //   if (type == "private") {

  //     Get.to(() => ChatPage(
  //       currentUserId: currentUserId,
  //       peerUserId: data['senderId'], 
  //       currentUserName: data['senderName'],
  //       peerUserName: data['senderName'],
  //     ));

  //   } else if (type == "group") {

  //     Get.to(() => GroupChatPage(
  //           groupId: data['groupId'],
  //           currentUserId: currentUserId,
  //           currentUserName: data['senderName'],
  //           userRole: data['userRole'],
  //         ));
  //   }
  // }

  static bool shouldHandleMessage(RemoteMessage message) {
    cleanupHandledMessages();
    final String? messageId = message.messageId;

    if (messageId == null || messageId.isEmpty) {
      // fallback key when messageId is unavailable.
      final fallbackKey =
          '${message.sentTime?.millisecondsSinceEpoch}_${message.data['type']}_${message.data['senderId']}_${message.data['groupId']}_${message.data['message']}';
      if (handledMessageIds.containsKey(fallbackKey)) {
        return false;
      }
      handledMessageIds[fallbackKey] = DateTime.now();
      return true;
    }

    if (handledMessageIds.containsKey(messageId)) {
      return false;
    }

   handledMessageIds[messageId] = DateTime.now();
    return true;

  }

  static void cleanupHandledMessages() {
    final now = DateTime.now();
    final expiredKeys = handledMessageIds.entries
        .where((entry) => now.difference(entry.value) > dedupeWindow)
        .map((entry) => entry.key)
        .toList();

    for (final key in expiredKeys) {
      handledMessageIds.remove(key);
    }

  }

    static void handleNotificationClick(RemoteMessage message, String currentUserId) {
    final data = message.data;
    final String type = data['type'] ?? '';

    if (type == 'private') {
      Get.to(() => ChatPage(
            currentUserId: currentUserId,
            peerUserId: data['senderId'] ?? '',
            currentUserName: data['receiverName'] ?? '',
            peerUserName: data['senderName'] ?? '',
          ));
    }else if (type == 'group') {
      Get.to(() => GroupChatPage(
            groupId: data['groupId'] ?? 'Community_group',
            currentUserId: currentUserId,
            currentUserName: data['receiverName'] ?? '',
            userRole: data['userRole'] ?? 'User',
          ));
    }else {
      debugPrint('Unknown notification type: $type');
    }


    }
}
