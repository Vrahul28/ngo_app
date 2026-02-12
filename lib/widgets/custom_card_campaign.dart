import 'package:flutter/material.dart';
import '../res/app_colors/app_colors.dart';

class CustomCardCampaign extends StatelessWidget {
  final String name;
  final String? email;
  final String? amount;
  final Widget? trailing;
  const CustomCardCampaign({
    required this.name,
    this.email,
    this.amount,
    this.trailing,
    super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black12, width: 1),
        borderRadius: BorderRadius.circular(0),
      ),
      child: Column(
        children: [
          // Always visible part
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                              '₹ $amount',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                                fontSize: 16,
                              )
                          ),
                          Spacer(),
                          trailing!
                        ],
                      ),
                      SizedBox(height: 3),
                      Text(
                          name,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.blackColor,
                            fontSize: 16,
                          )
                      ),
                      SizedBox(height: 3),
                      Text(
                        email!,
                        softWrap: true,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: AppColors.blackColor,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
