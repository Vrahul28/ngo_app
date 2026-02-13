import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ngo_app/view_models/chat_controller/chat_controller.dart';
import '../../view_models/chat_controller/group_controller.dart';
import '../../widgets/custom_member_card.dart';
import 'chat_page.dart';
import 'group_chat_page.dart';

class ChatListPage extends StatefulWidget {
  final String userType;
  final String firebaseUid;
  final String userName;
  final String adminFirebaseUid;
  final String adminName;
  final String adminEmail;
  const ChatListPage({
    required this.userType,
    required this.firebaseUid,
    required this.userName,
    required this.adminFirebaseUid,
    required this.adminName,
    required this.adminEmail,
    super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  final GroupController controller = Get.find<GroupController>();
  final chat= Get.find<ChatController>();
  
  @override
  void initState() {
    super.initState();

    controller.listenGroupUnread(widget.firebaseUid);

    /// start badge listener
    WidgetsBinding.instance.addPostFrameCallback((_) {
      chat.listenChatListUnread(
        widget.firebaseUid,
        widget.adminFirebaseUid,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0,right: 15.0,top: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ADMIN CHAT
              if (widget.userType == 'User')
                Obx(() => CustomMemberCard(
                  heading: widget.adminName,
                  subheading: widget.adminEmail,
                  badgeCount: chat.unreadCount.value,
                  onTap: () async {
                    Get.to(() => ChatPage(
                      currentUserId: widget.firebaseUid,
                      currentUserName: widget.userName,
                      peerUserId: widget.adminFirebaseUid,
                      peerUserName: widget.adminName,
                    ));
                  },
                )),
              /// COMMUNITY CHAT
              Obx(() => CustomMemberCard(
                heading: 'Community Chat',
                subheading: 'Community Chat',
                badgeCount: controller.unreadGroupCount.value,
                onTap: () {
                  Get.to(() => GroupChatPage(
                    groupId: GroupController.GROUP_ID,
                    currentUserId: widget.firebaseUid,
                    currentUserName: widget.userName,
                    userRole: widget.userType,
                  ));
                },
              )),
            ],
          ),
        ),
      ),
    );
  }
}
