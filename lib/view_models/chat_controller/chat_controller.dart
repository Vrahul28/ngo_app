import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ChatController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  RxString chatId = ''.obs;
  late String currentUserId;
  late String otherUserId;

  RxList<QueryDocumentSnapshot> messages = <QueryDocumentSnapshot>[].obs;
  RxInt unreadCount = 0.obs;

  String getChatId(String id1, String id2) {
    return id1.compareTo(id2) < 0 ? '${id1}_$id2' : '${id2}_$id1';
  }

  void initChat({
    required String currentUser,
    required String otherUser,
  }) {

    currentUserId = currentUser;
    chatId.value = getChatId(currentUser, otherUser);
    debugPrint("ChatID: $chatId");
    listenMessages();
    resetUnread();
    // firestore
    //     .collection('chats')
    //     .doc(chatId.value)
    //     .collection('messages')
    //     .orderBy('timestamp', descending: true)
    //     .snapshots()
    //     .listen((snapshot) {
    //   messages.value = snapshot.docs;
    // });
  }

  void listenMessages() {
    FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId.value)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((snapshot) {
      messages.value = snapshot.docs;

      // Increase unread only if sender is NOT me
      if (snapshot.docChanges.isNotEmpty) {
        final change = snapshot.docChanges.first;
        if (change.type == DocumentChangeType.added) {
          final msg = change.doc.data();
          if (msg != null && msg['senderId'] != currentUserId) {
            unreadCount++;
          }
        }
      }
    });
  }

  void resetUnread() {
    unreadCount.value = 0;
  }

  //Pick Image from Gallery
  Future<File?> pickImage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      return File(image.path);
    }
    return null;
  }

  //upload image to firebase
  Future<String?> uploadImageToFirebase(File imageFile, String chatId) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();

      final ref = FirebaseStorage.instance
          .ref()
          .child('chat_images/$chatId/$fileName.jpg');

      await ref.putFile(
        imageFile,
        SettableMetadata(contentType: 'image/jpeg'),
      );

      return await ref.getDownloadURL();
    } catch (e) {
      debugPrint("Image upload error: $e");
      return null;
    }
  }

  //Send message in firebase
  Future<void> sendMessage(String text,String senderId,String receiverId, String chatId) async {
    if (text.trim().isEmpty) return;

    await firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add({
      'senderId': senderId,
      'receiverId': receiverId,
      'message': text.trim(),
      'timestamp': FieldValue.serverTimestamp(),
    });

    await firestore.collection('chats').doc(chatId).set({
      'participants': [senderId, receiverId],
      'lastMessage': text.trim(),
      'lastMessageTime': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  //Send Image in Message
  Future<void> sendImageMessage({
    required String senderId,
    required String receiverId,
    required String chatId,
  }) async {
    final File? imageFile = await pickImage();
    if (imageFile == null) return;

    final imageUrl = await uploadImageToFirebase(imageFile, chatId);
    if (imageUrl == null) return;

    await firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add({
      'senderId': senderId,
      'receiverId': receiverId,
      'imageUrl': imageUrl,
      'type': 'image',
      'timestamp': FieldValue.serverTimestamp(),
    });

    await firestore.collection('chats').doc(chatId).set({
      'participants': [senderId, receiverId],
      'lastMessage': 'Image',
      'lastMessageTime': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

}
