import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ngo_app/view_models/admin_controller/admin_controller.dart';
import '../../data/exeception/status.dart';
import '../../res/app_colors/app_colors.dart';
import '../../widgets/custom_member_card.dart';
import '../chat_page/chat_page.dart';


class ManageMembers extends StatelessWidget {
  final String firebaseUid;
  final String currentUsername;
  const ManageMembers({
    required this.firebaseUid,
    required this.currentUsername,
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
              // Container(
              //   height: MediaQuery.of(context).size.height * 0.4,
              //   padding: const EdgeInsets.all(16),
              //   decoration: BoxDecoration(color: Colors.greenAccent, borderRadius: BorderRadius.circular(12)),
              //   child: StreamBuilder<QuerySnapshot>(
              //     stream: user.getAllUsers(),
              //     builder: (context, snapshot) {
              //       if (!snapshot.hasData) return CircularProgressIndicator();
              //       return ListView(
              //         children: snapshot.data!.docs.map((doc) {
              //           return ListTile(
              //             title: Text(doc["name"]),
              //             subtitle: Text(doc["email"]),
              //           );
              //         }).toList(),
              //       );
              //     },
              //   )
              // ),
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
                          // icon: Icon(
                          //   Icons.phone,
                          //   color: AppColors.primary,
                          // ),
                          onTap: () {
                            debugPrint(firebaseUid);
                            debugPrint(currentUsername);
                            debugPrint(member.fireBaseId);
                            Get.to(() => ChatPage(
                              currentUserId: firebaseUid,
                              currentUserName: currentUsername,
                              peerUserId: member.fireBaseId!,
                              peerUserName: member.name!,
                            ));
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
