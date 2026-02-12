import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ngo_app/view_models/chat_controller/chat_controller.dart';
import '../../res/app_colors/app_colors.dart';
import '../../view_models/chat_controller/group_controller.dart';
import '../../widgets/custom_member_card.dart';
import 'chat_page.dart';
import 'group_chat_page.dart';

class ChatListPage extends StatelessWidget {
  final String userType;
  final String firebaseUid;
  final String userName;
  const ChatListPage({
    required this.userType,
    required this.firebaseUid,
    required this.userName,
    super.key});

  @override
  Widget build(BuildContext context) {
    final GroupController controller = Get.find<GroupController>();
    final chat= Get.find<ChatController>();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0,right: 15.0,top: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ADMIN CHAT
              if (userType == 'User')
                Obx(() => CustomMemberCard(
                  heading: 'Admin',
                  subheading: 'admin@gmail.com',
                  badgeCount: chat.unreadCount.value,
                  onTap: () {
                    chat.resetUnread();
                    Get.to(() => ChatPage(
                      currentUserId: firebaseUid,
                      currentUserName: userName,
                      peerUserId: controller.adminFirebaseUid.value,
                      peerUserName: 'Admin',
                    ));
                  },
                )),
              // Visibility(
              //   visible: userType == 'User',
              //     child: CustomMemberCard(
              //       heading: 'Admin',
              //       subheading: 'admin@gmail.com',
              //       icon: Icon(
              //         Icons.messenger_outline,
              //         color: AppColors.primary,
              //       ),
              //       onTap: () {
              //         Get.to(() => ChatPage(
              //           currentUserId: firebaseUid,
              //           currentUserName: userName,
              //           peerUserId: controller.adminFirebaseUid.value,
              //           peerUserName: 'Admin',
              //         ));
              //       },
              //     )
              // ),

              // CustomMemberCard(
              //   heading: 'Community Chat',
              //   subheading: 'Community Chat',
              //   icon: Icon(
              //     Icons.messenger_outline,
              //     color: AppColors.primary,
              //   ),
              //   onTap: () {
              //     Get.to(() => GroupChatPage(
              //       groupId: GroupController.GROUP_ID,
              //       currentUserId: firebaseUid,
              //       currentUserName: userName,
              //       userRole: userType,
              //     ));
              //   },
              // ),
              /// COMMUNITY CHAT
              Obx(() => CustomMemberCard(
                heading: 'Community Chat',
                subheading: 'Community Chat',
                badgeCount: controller.unreadGroupCount.value,
                onTap: () {
                  controller.resetGroupUnread();
                  debugPrint(controller.unreadGroupCount.value.toString());
                  Get.to(() => GroupChatPage(
                    groupId: GroupController.GROUP_ID,
                    currentUserId: firebaseUid,
                    currentUserName: userName,
                    userRole: userType,
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
