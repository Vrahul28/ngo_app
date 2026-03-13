import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';


class ChatController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  RxString chatId = ''.obs;
  late String currentUserId;
  late String otherUserId;

  RxList<QueryDocumentSnapshot> messages = <QueryDocumentSnapshot>[].obs;
  RxInt unreadCount = 0.obs;
  RxInt personalUnread = 0.obs;
  RxInt unreadCountForDashboard = 0.obs;

  StreamSubscription? messageSub;
  StreamSubscription? chatListSub;

  NativeAd? nativeAd;
  var nativeAdLoaded = false.obs;

  /// Create stable chat id
  String getChatId(String id1, String id2) {
    return id1.compareTo(id2) < 0 ? '${id1}_$id2' : '${id2}_$id1';
  }

  @override
  void onReady() { // Changed from onInit
    super.onReady();
    loadNativeAd();
  }

  //Native Ad
  void loadNativeAd() {
    nativeAd = NativeAd(
      adUnitId: "ca-app-pub-3940256099942544/2247696110",
      // adUnitId: "ca-app-pub-8961859671672268/1567973049", // your native ad id
      factoryId: "dashboardNativeAd", // must match Android factory
      request: const AdRequest(),
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          nativeAdLoaded.value = true;
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          debugPrint("Native ad failed: ${error.message}");
        },
      ),
    );
    nativeAd!.load();
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

  /// ================= CHAT LIST BADGE =================
  void listenChatListUnread(String myUid, String otherUid) async {
    String id = getChatId(myUid, otherUid);
    debugPrint("LISTENING CHAT ID: $id");

    chatListSub?.cancel();

    chatListSub = firestore
        .collection('chats')
        .doc(id)
        .collection('participants')
        .doc(myUid)
        .snapshots()
        .listen((doc) {
      unreadCount.value = doc.data()?['unreadCount'] ?? 0;
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
    
    try{
      final chatRef = firestore.collection('chats').doc(chatId);
      final msgRef = chatRef.collection('messages');

      await msgRef.add({
        'message': text.trim(),
        'senderId': senderId,
        'receiverId': receiverId,
        'timestamp': FieldValue.serverTimestamp(),
      });

      await chatRef.set({
        'participants': [senderId, receiverId],
        'lastMessage': text.trim(),
        'lastMessageTime': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      /// 🔥 INCREMENT unread count of receiver
      await chatRef
          .collection('participants')
          .doc(receiverId)
          .set({
        'unreadCount': FieldValue.increment(1),
      }, SetOptions(merge: true));
    }catch(e){
      debugPrint("Firestore error in chat controller: $e");
    }



    // final msgRef = firestore
    //     .collection('chats')
    //     .doc(chatId)
    //     .collection('messages');
    //
    // await msgRef.add({
    //   'message': text.trim(),
    //   'senderId': senderId,
    //   'receiverId': receiverId,
    //   'timestamp': FieldValue.serverTimestamp(),
    // });
    //
    // await firestore.collection('chats').doc(chatId).set({
    //   'participants': [senderId, receiverId],
    //   'lastMessage': text,
    //   'lastMessageTime': FieldValue.serverTimestamp(),
    // },
    // SetOptions(merge: true));
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

  Future<void> resetUnread() async {
    await FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId.value)
        .collection('participants')
        .doc(currentUserId)
        .set({
      'unreadCount': 0,
      'lastSeen': FieldValue.serverTimestamp(),
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

