import 'package:flutter/material.dart';
import '../res/app_colors/app_colors.dart';

class CustomCampaignCardUser extends StatelessWidget {
  final String amount;
  final String title;
  final String? des;
  final VoidCallback onPressed;
  const CustomCampaignCardUser({
    required this.amount,
    required this.title,
    this.des,
    required this.onPressed,
    super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 16,bottom: 10,left: 16,right: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
        border: Border(
          left: BorderSide(
            color: AppColors.primary,
            width: 4,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
             amount,
            style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryDark
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            des!,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.all(Radius.circular(12)))
            ),
            onPressed: onPressed,
            child: Text(
                'Donate',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                )),
          ),
        ],
      ),
    );
  }
}
