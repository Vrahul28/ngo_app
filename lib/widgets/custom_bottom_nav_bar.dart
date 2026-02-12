import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../res/app_colors/app_colors.dart';
import '../view/campaign_page/user_campaign_page.dart';
import '../view/chat_page/chat_page.dart';
import '../view/profile_page/profile_page.dart';
import '../view/user_dashboard/user_dashboard.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    int currentIndex = 0;
    return BottomNavigationBar(
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: Colors.grey,
      backgroundColor: Colors.white,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
      unselectedLabelStyle: const TextStyle(fontSize: 12),
      onTap: (index) {
        // if (index == 0) UserDashboard();
        // if (index == 1) CampaignPage();
        // if (index == 2) ChatPage();
        // if (index == 3) ProfilePage();
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.houseChimney), label: 'Dashboard'),
        BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.bullhorn), label: 'Campaigns'),
        BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.comments), label: 'Chat'),
        BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.userCircle), label: 'Profile'),
      ],
    );
  }
}
