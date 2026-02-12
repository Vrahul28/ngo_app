import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';


class GroupController extends GetxController{
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  RxString adminFirebaseUid = ''.obs;
  RxInt unreadGroupCount = 0.obs;
  static const String GROUP_ID = "Community_group";

  @override
  void onInit() async{
    super.onInit();
    fetchAdminFirebaseUid();
  }

  Future<void> fetchAdminFirebaseUid() async {
    final snapshot = await firestore
        .collection('users')
        .where('role', isEqualTo: 'Admin')
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      adminFirebaseUid.value = snapshot.docs.first.id;
    }
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

  Future<String?> getUserRole(String userId) async {
    final doc = await firestore
        .collection('groups')
        .doc(GROUP_ID)
        .get();

    if (!doc.exists) return null;

    return doc.data()?['members']?[userId]?['role'];
  }


  late String currentUserId;
  late String currentUserName;

  RxList<QueryDocumentSnapshot> messages = <QueryDocumentSnapshot>[].obs;

  void initGroupChat({
    required String userId,
    required String userName,
  }) {
    currentUserId = userId;
    currentUserName = userName;

    listenGroupMessages();
    resetGroupUnread();
    // firestore
    //     .collection('groups')
    //     .doc(GROUP_ID)
    //     .collection('messages')
    //     .orderBy('timestamp', descending: true)
    //     .snapshots()
    //     .listen((snapshot) {
    //   messages.value = snapshot.docs;
    // });
  }

  void listenGroupMessages() {
    FirebaseFirestore.instance
        .collection('groups')
        .doc(GROUP_ID)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((snapshot) {
      messages.value = snapshot.docs;

      if (snapshot.docChanges.isNotEmpty) {
        final change = snapshot.docChanges.first;
        if (change.type == DocumentChangeType.added) {
          final msg = change.doc.data();
          if (msg != null && msg['senderId'] != currentUserId) {
            unreadGroupCount++;
          }
        }
      }
    });
  }

  void resetGroupUnread() {
    unreadGroupCount.value = 0;
  }

  Future<void> sendMessage(String text,String userID,String userName,String userRole) async {
    if (text.trim().isEmpty) return;

    await firestore
        .collection('groups')
        .doc(GROUP_ID)
        .collection('messages')
        .add({
      'senderId': userID,
      'senderName': userName,
      'senderRole': userRole, // ADMIN / USER
      'message': text.trim(),
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

}