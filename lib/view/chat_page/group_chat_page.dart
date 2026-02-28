import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:ngo_app/res/app_colors/app_colors.dart';
import 'package:ngo_app/view_models/dashboard_controller/dashboard_controller.dart';
import '../../view_models/chat_controller/group_controller.dart';


class GroupChatPage extends StatefulWidget {
  final String groupId;
  final String currentUserId;
  final String currentUserName;
  final String userRole;
  const GroupChatPage({
    super.key,
    required this.groupId,
    required this.currentUserId,
    required this.currentUserName,
    required this.userRole,
  });

  @override
  State<GroupChatPage> createState() => _GroupChatPageState();
}

class _GroupChatPageState extends State<GroupChatPage> {
  final GroupController controller = Get.find<GroupController>();
  final TextEditingController msgCtrl = TextEditingController();
  final DashboardController dash = Get.find<DashboardController>();

  @override
void initState() {
  super.initState();
  
  controller.initGroupChat(
    userId: widget.currentUserId,
    userName: widget.currentUserName,
  );

  /// mark read AFTER open
  Future.delayed(const Duration(milliseconds: 300), () {
    controller.markGroupAsRead();
    dash.clearUnreadBadgeCount();
  });
}

@override
void dispose() {
  controller.markGroupAsRead();
  msgCtrl.dispose();
  super.dispose();
}

  @override
  Widget build(BuildContext context) {
    debugPrint('User ID: ${widget.currentUserId}');
    return Scaffold(
      backgroundColor: Colors.white,
    appBar: AppBar(
      title: Text(
          'Community Chat',
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 18
          )
      ),
      automaticallyImplyLeading: true,
      centerTitle: true,
      backgroundColor: Colors.white,
      elevation: 1,
    ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Expanded(
              child: Obx(() => ListView.builder(
                reverse: true,
                itemCount: controller.messages.length,
                itemBuilder: (context, index) {
                  final msg = controller.messages[index];
                  final isMe = msg['senderId'] == controller.currentUserId;
                  debugPrint(controller.currentUserId);
                  return Align(
                    alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isMe ? AppColors.primary : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (!isMe)
                            Text(
                              msg['senderName'],
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          Text(msg['message'],
                            style: TextStyle(
                              color: isMe ? Colors.white : Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: msgCtrl,
                      decoration: InputDecoration(
                        hintText: 'Type your message',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      onSubmitted: (value) {
                        // _handleSendMessage
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async{
                        controller.sendMessage(
                          msgCtrl.text,
                          widget.currentUserId,
                          widget.currentUserName,
                          widget.userRole,
                        );
                        // controller.sendMessage(msgCtrl.text,await use.getUserId(),await use.getUserName(),await use.getRole());
                        msgCtrl.clear();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                      ),
                      child: const Icon(FontAwesomeIcons.paperPlane, size: 20),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
