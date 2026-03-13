import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ngo_app/view_models/dashboard_controller/dashboard_controller.dart';
import '../../res/app_colors/app_colors.dart';
import '../../view_models/chat_controller/chat_controller.dart';


class ChatPage extends StatefulWidget {
  final String currentUserId;
  final String currentUserName;
  final String peerUserId;
  final String peerUserName;
  const ChatPage({
    required this.currentUserId,
    required this.currentUserName,
    required this.peerUserId,
    required this.peerUserName,
    super.key
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ChatController controller = Get.find<ChatController>();
  final TextEditingController _chatController = TextEditingController();
  final DashboardController dash = Get.find<DashboardController>();

  @override
  void initState() {
    super.initState();
    controller.initChat(
      currentUser: widget.currentUserId,
      otherUser: widget.peerUserId,
    );

    /// VERY IMPORTANT
    /// mark read AFTER chat opens
    Future.delayed(const Duration(milliseconds: 700), () {
      controller.resetUnread();
      dash.clearUnreadBadgeCount();
    });
  }

   @override
  void dispose() {
     controller.resetUnread();
    _chatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
            widget.peerUserName,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
            )
        ),
        automaticallyImplyLeading: true,
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Obx(() => ListView.builder(
                reverse: true,
                itemCount: controller.messages.length,
                itemBuilder: (context, index) {
                  final msg = controller.messages[index];
                  final isMe = msg['senderId'] == controller.currentUserId;
                  return Align(
                    alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 6),
                      decoration: BoxDecoration(
                        color: isMe ? AppColors.primary : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                            Text(
                              msg['message'] ?? '',
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
                      controller: _chatController,
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
                      onPressed: () {
                        controller.sendMessage(_chatController.text, widget.currentUserId,widget.peerUserId,controller.chatId.value);
                        controller.updateChatList(
                          senderId: widget.currentUserId,
                          receiverId: widget.peerUserId,
                          senderName: widget.currentUserName,
                          receiverName: widget.peerUserName,
                          message: _chatController.text.trim(),
                        );
                        _chatController.clear();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                      child: const Icon(Icons.send, size: 20),
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