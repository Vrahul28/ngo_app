import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ngo_app/view_models/user_prefernce/user_preference.dart';


class DashboardController extends GetxController{
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  RxInt currentIndex= 0.obs;
  RxString role= ''.obs;
  RxString userId= ''.obs;
  RxString name= ''.obs;

//for chat
  RxString adminFirebaseUid = ''.obs;
  RxString adminName = ''.obs;
  RxString adminEmail = ''.obs;
  PageController pageController = PageController(initialPage: 0);
  final user= UserPreference();

  RxInt oneToOneUnreadCount = 0.obs;
  RxInt groupUnreadCount = 0.obs;
  RxInt totalUnreadCount = 0.obs;

//Calaculate total unread count for dashboard badge
  StreamSubscription<QuerySnapshot>? oneToOneUnreadSub;
  StreamSubscription<DocumentSnapshot>? groupParticipantSub;
  StreamSubscription<QuerySnapshot>? groupMessageSub;
  static const String communityGroupId = 'Community_group';


  @override
  void onInit() {
    super.onInit();
    getRoleForDash();
  }

  Future<void> getRoleForDash() async{
    role.value= await user.getRole();
    userId.value= await user.getFirebaseId();
    name.value= await user.getUserName();
    await fetchAdminFirebaseUid();
    listenUnreadMessagesCount();
  }


  void onPageChangedWithOutAnimation(int index) {
      currentIndex.value = index;
  }

  void updateTabSelection(int index) {
    currentIndex.value = index;
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
    pageController.jumpToPage(index);
  }

  //fetch admin firebase uid from firestore
  Future<void> fetchAdminFirebaseUid() async {
  final doc = await FirebaseFirestore.instance
      .collection('app_config')
      .doc('admin')
      .get();

  if (doc.exists) {
    adminFirebaseUid.value = doc.data()!['adminUid'];
    adminName.value = doc.data()!['userName'];
    adminEmail.value = doc.data()!['adminEmail'];
  }
}

//Count unread message for both one-to-one and group chats, and update the total unread count for the dashboard badge
void listenUnreadMessagesCount() {
    if (userId.value.isEmpty) return;

    _listenOneToOneUnreadCount();
    _listenGroupUnreadCount();
  }

  void _listenOneToOneUnreadCount() {
    oneToOneUnreadSub?.cancel();

    oneToOneUnreadSub = firestore
        .collection('chat_list')
        .doc(userId.value)
        .collection('users')
        .snapshots()
        .listen((snapshot) {
      int count = 0;
      for (final chatDoc in snapshot.docs) {
        count += (chatDoc.data()['unreadCount'] ?? 0) as int;
      }

      oneToOneUnreadCount.value = count;
      _updateTotalUnreadCount();
    });
  }

  void _listenGroupUnreadCount() {
    groupParticipantSub?.cancel();
    groupMessageSub?.cancel();

    groupParticipantSub = firestore
        .collection('groups')
        .doc(communityGroupId)
        .collection('participants')
        .doc(userId.value)
        .snapshots()
        .listen((participantSnapshot) {
      final Timestamp lastSeen =
          participantSnapshot.data()?['lastSeen'] ?? Timestamp(0, 0);

      groupMessageSub?.cancel();
      groupMessageSub = firestore
          .collection('groups')
          .doc(communityGroupId)
          .collection('messages')
          .orderBy('timestamp')
          .snapshots()
          .listen((messagesSnapshot) {
        int count = 0;
        for (final messageDoc in messagesSnapshot.docs) {
          final messageData = messageDoc.data();
          if (messageData['senderId'] != userId.value &&
              messageData['timestamp'] != null &&
              (messageData['timestamp'] as Timestamp).compareTo(lastSeen) > 0) {
            count++;
          }
        }

        groupUnreadCount.value = count;
        _updateTotalUnreadCount();
      });
    });
  }

  void _updateTotalUnreadCount() {
    totalUnreadCount.value = oneToOneUnreadCount.value + groupUnreadCount.value;
  }

   void clearUnreadBadgeCount() {
    oneToOneUnreadCount.value = 0;
    groupUnreadCount.value = 0;
    totalUnreadCount.value = 0;
  }

  @override
  void dispose() {
    oneToOneUnreadSub?.cancel();
    groupParticipantSub?.cancel();
    groupMessageSub?.cancel();
    super.dispose();
    pageController.dispose();
  }


}