import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';


class GroupController extends GetxController {

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  static const String GROUP_ID = "Community_group";

  RxList<QueryDocumentSnapshot> messages = <QueryDocumentSnapshot>[].obs;
  RxInt unreadGroupCount = 0.obs;

  late String currentUserId;
  late String currentUserName;

  StreamSubscription? messageSub;
  StreamSubscription? unreadSub;

  /// ================= INIT GROUP =================

  Future<void> initGroupChat({
    required String userId,
    required String userName,
  }) async {

    currentUserId = userId;
    currentUserName = userName;

    await _ensureParticipant();

    listenMessages();
  }

  /// create participant doc if not exists
  Future<void> _ensureParticipant() async {

    final ref = firestore
        .collection('groups')
        .doc(GROUP_ID)
        .collection('participants')
        .doc(currentUserId);

    final doc = await ref.get();

    if (!doc.exists) {
      await ref.set({
        'lastSeen': Timestamp(0,0),
        'name': currentUserName
      });
    }
  }

  /// ================= MESSAGES =================

  void listenMessages() {

    messageSub?.cancel();

    messageSub = firestore
        .collection('groups')
        .doc(GROUP_ID)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((snapshot) {
      messages.value = snapshot.docs;
    });
  }

  /// ================= UNREAD BADGE (CHAT LIST) =================

  void listenGroupUnread(String myUid) async {

    print("LISTENING CHAT ID: $myUid");

    final participantDoc = await firestore
        .collection('groups')
        .doc(GROUP_ID)
        .collection('participants')
        .doc(myUid)
        .get();

    Timestamp lastSeen =
        participantDoc.data()?['lastSeen'] ?? Timestamp(0,0);

    unreadSub?.cancel();

    unreadSub = firestore
        .collection('groups')
        .doc(GROUP_ID)
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

      unreadGroupCount.value = count;
    });
  }

  /// ================= MARK READ =================

  Future<void> markGroupAsRead() async {

    await firestore
        .collection('groups')
        .doc(GROUP_ID)
        .collection('participants')
        .doc(currentUserId)
        .set({
      'lastSeen': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    unreadGroupCount.value = 0;
  }

  /// ================= SEND =================

  Future<void> sendMessage(
      String text,
      String userID,
      String userName,
      String userRole,
      ) async {

    if (text.trim().isEmpty) return;

    await firestore
        .collection('groups')
        .doc(GROUP_ID)
        .collection('messages')
        .add({
      'senderId': userID,
      'senderName': userName,
      'senderRole': userRole,
      'message': text.trim(),
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  @override
  void onClose() {
    messageSub?.cancel();
    unreadSub?.cancel();
    super.onClose();
  }

  Future<void> createGroupIfNotExists(String name, String role, String userId) async {
    if (role != 'Admin') return;

    final doc = firestore.collection('groups').doc(GROUP_ID);
    final snapshot = await doc.get();

    if (!snapshot.exists) {
      await doc.set({
        'name': 'Community Chat',
        'createdAt': FieldValue.serverTimestamp(),
        'members': {
          userId: {
            'role': role,
            'name': name
          }
        }
      });
    }
  }

  Future<bool> isUserInGroup({required String userId}) async {
    final doc = await firestore
        .collection('groups')
        .doc(GROUP_ID)
        .get();

    if (!doc.exists) return false;

    final Map members = doc.data()?['members'] ?? {};

    return members.containsKey(userId);
  }

  Future<void> addUserToGroup({
    required String userId,
    required String userName,
    required String role,
  }) async {
    final doc = firestore.collection('groups').doc(GROUP_ID);

    await doc.update(
        {userId: {
          'name': userName,
          'role': role,
        }}
    );
  }
}



