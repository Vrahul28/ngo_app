import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';


class ChatController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  RxString chatId = ''.obs;
  late String currentUserId;
  late String otherUserId;

  RxList<QueryDocumentSnapshot> messages = <QueryDocumentSnapshot>[].obs;
  RxInt unreadCount = 0.obs;

  StreamSubscription? messageSub;
  StreamSubscription? chatListSub;

  /// Create stable chat id
  String getChatId(String id1, String id2) {
    return id1.compareTo(id2) < 0 ? '${id1}_$id2' : '${id2}_$id1';
  }

  /// ================= CHAT PAGE =================

  void initChat({
    required String currentUser,
    required String otherUser,
  }) async {
    currentUserId = currentUser;
    otherUserId = otherUser;

    chatId.value = getChatId(currentUser, otherUser);

    await _ensureParticipantDoc();   // VERY IMPORTANT
    listenMessages();
  }

  /// ensure participants document exists
  Future<void> _ensureParticipantDoc() async {
    final ref = firestore
        .collection('chats')
        .doc(chatId.value)
        .collection('participants')
        .doc(currentUserId);

    final doc = await ref.get();

    if (!doc.exists) {
      await ref.set({
        'lastSeen': Timestamp(0, 0),
      });
    }
  }

  /// listen chat messages
  void listenMessages() {
    messageSub?.cancel();

    messageSub = firestore
        .collection('chats')
        .doc(chatId.value)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((snapshot) {
      messages.value = snapshot.docs;
    });
  }

  /// mark read
  Future<void> markChatAsRead() async {
    await firestore
        .collection('chats')
        .doc(chatId.value)
        .collection('participants')
        .doc(currentUserId)
        .set({
      'lastSeen': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    unreadCount.value = 0;
  }

  /// ================= CHAT LIST BADGE =================

  void listenChatListUnread(String myUid, String otherUid) async {

    String id = getChatId(myUid, otherUid);

    debugPrint("LISTENING CHAT ID: $id");

    // get lastSeen
    final participantDoc = await firestore
        .collection('chats')
        .doc(id)
        .collection('participants')
        .doc(myUid)
        .get();

    Timestamp lastSeen =
        participantDoc.data()?['lastSeen'] ?? Timestamp(0, 0);

    chatListSub?.cancel();

    chatListSub = firestore
        .collection('chats')
        .doc(id)
        .collection('messages')
        .orderBy('timestamp')
        .snapshots()
        .listen((snapshot) {

      int count = 0;

      for (var doc in snapshot.docs) {
        final data = doc.data();

        if (data['senderId'] != myUid &&
            data['timestamp'] != null &&
            (data['timestamp'] as Timestamp).compareTo(lastSeen) > 0) {
          count++;
        }
      }

      unreadCount.value = count;
    });
  }

  /// ================= SEND MESSAGE =================

  Future<void> sendMessage(
      String text,
      String senderId,
      String receiverId,
      String chatId,
      ) async {

    if (text.trim().isEmpty) return;

    final msgRef = firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages');

    await msgRef.add({
      'message': text.trim(),
      'senderId': senderId,
      'receiverId': receiverId,
      'timestamp': FieldValue.serverTimestamp(),
    });

    await firestore.collection('chats').doc(chatId).set({
      'participants': [senderId, receiverId],
      'lastMessage': text,
      'lastMessageTime': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    
  }

  Future<void> updateChatList({
  required String senderId,
  required String receiverId,
  required String senderName,
  required String receiverName,
  required String message,
}) async {

  final time = FieldValue.serverTimestamp();

  /// sender chat list
  await FirebaseFirestore.instance
      .collection('chat_list')
      .doc(senderId)
      .collection('users')
      .doc(receiverId)
      .set({
    'uid': receiverId,
    'name': receiverName,
    'lastMessage': message,
    'timestamp': time,
    'unreadCount': 0,
  }, SetOptions(merge: true));

  /// receiver chat list (increase unread)
  await FirebaseFirestore.instance
      .collection('chat_list')
      .doc(receiverId)
      .collection('users')
      .doc(senderId)
      .set({
    'uid': senderId,
    'name': senderName,
    'lastMessage': message,
    'timestamp': time,
    'unreadCount': FieldValue.increment(1),
  }, SetOptions(merge: true));
}

Stream<QuerySnapshot> getChatList(String currentUserId) {
  return FirebaseFirestore.instance
      .collection('chat_list')
      .doc(currentUserId)
      .collection('users')
      .orderBy('timestamp', descending: true)
      .snapshots();
}


  @override
  void onClose() {
    messageSub?.cancel();
    chatListSub?.cancel();
    super.onClose();
  }
}

