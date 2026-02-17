import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ngo_app/view_models/admin_controller/admin_controller.dart';
import '../../data/exeception/status.dart';
import '../../widgets/custom_member_card.dart';
import '../chat_page/chat_page.dart';


class ManageMembers extends StatelessWidget {
  final String firebaseUid;
  final String currentUsername;
  final String? pageTitle;
  const ManageMembers({
    required this.firebaseUid,
    required this.currentUsername,
    this.pageTitle,
    super.key});

  @override
  Widget build(BuildContext context) {
    final users= Get.put(AdminController());
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Members', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0,right: 15.0,top: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() {
                switch (users.rxRequestStatus.value) {
                  case Status.LOADING:
                    return SizedBox(
                      child: Center(child: CircularProgressIndicator()),
                    );
                  case Status.ERROR:
                    return SizedBox(
                      child: Center(child: Text(users.error.toString())),
                    );
                  case Status.COMPLETED:
                    return users.members.isEmpty ? SizedBox(
                      child: Center(child: Text('No Member Found')),
                    ): ListView.builder(
                      shrinkWrap: true,
                      itemCount: users.members.length,
                      itemBuilder: (context, index) {
                        final member= users.members[index];
                        return CustomMemberCard(
                          heading: member.name!,
                          subheading: member.email!,
                          onCallTap: () {
                            users.launchPhoneDialer(member.contactNumber!);
                          },
                          onTap: () {
                            pageTitle == "ChatList" ? Get.to(() => ChatPage(
                              currentUserId: firebaseUid,
                              currentUserName: currentUsername,
                              peerUserId: member.fireBaseId!,
                              peerUserName: member.name!,
                            )) : null;
                          },
                        );
                      },
                    );
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}
