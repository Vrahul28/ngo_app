import 'package:flutter/material.dart';
import '../res/app_colors/app_colors.dart';

class CustomCardPaymentHistory extends StatelessWidget {
  final String name;
  final String? email;
  final String? amount;
  final String? date;
  const CustomCardPaymentHistory({
    required this.name,
    this.email,
    this.amount,
    this.date,
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        date!,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColors.blackColor,
                          fontSize: 13,
                        )
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
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: AppColors.blackColor,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                Spacer(),
                Text(
                  '₹ $amount',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                    fontSize: 16,
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
