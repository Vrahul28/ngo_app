import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ngo_app/res/app_colors/app_colors.dart';
import 'package:ngo_app/view_models/chat_controller/chat_controller.dart';
import '../../view_models/chat_controller/group_controller.dart';
import '../../view_models/dashboard_controller/dashboard_controller.dart';
import '../../widgets/custom_member_card.dart';
import '../admin_dashboard/manage_members.dart';
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
  final dash= Get.find<DashboardController>();
  
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
              if (widget.userType == 'Admin')
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: chat.getChatList(widget.firebaseUid),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final chats = snapshot.data!.docs;
                      if (chats.isEmpty) {
                        return const Center(child: Text("No conversations yet"));
                      }
                      return ListView.builder(
                        itemCount: chats.length,
                        itemBuilder: (context, index) {
                          final data = chats[index];
                          return CustomMemberCard(
                            heading: data['name'],
                            subheading: data['lastMessage'],
                            badgeCount: data['unreadCount'],                          
                            onTap: () async {
                              /// reset unread
                              await FirebaseFirestore.instance
                                  .collection('chat_list')
                                  .doc(widget.firebaseUid)
                                  .collection('users')
                                  .doc(data['uid'])
                                  .update({'unreadCount': 0});
                                  
                              Get.to(() => ChatPage(
                                    currentUserId: widget.firebaseUid,
                                    currentUserName: widget.userName,
                                    peerUserId: data['uid'],
                                    peerUserName: data['name'],
                                  ));
                            },
                          );
                        },
                      );
                    },
                  ),
                )
            ],
          ),
        ),
      ),
      floatingActionButton: widget.userType == 'Admin'? FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () {
        Get.to(() => ManageMembers(
                firebaseUid: dash.userId.value,
                currentUsername: dash.name.value,
                pageTitle: "ChatList",
              ));
      },
      child: Icon(Icons.add, color: Colors.white,),
      ) : SizedBox(),
    );
  }
}
