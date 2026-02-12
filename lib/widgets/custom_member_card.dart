import 'package:flutter/material.dart';
import '../res/app_colors/app_colors.dart';

class CustomMemberCard extends StatelessWidget {
  final String heading;
  final String? subheading;
  // final Icon? icon;
  final VoidCallback? onCallTap;
  final VoidCallback onTap;
  final int badgeCount;
  const CustomMemberCard({
    required this.heading,
     this.onCallTap,
    // this.icon,
    required this.onTap,
    this.subheading,
    this.badgeCount = 0,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    heading,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  if (subheading != null)
                    Text(
                      subheading!,
                      style: const TextStyle(fontSize: 14),
                    ),
                ],
              ),
              const Spacer(),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  // icon ?? const SizedBox(),
                  const SizedBox(),
                  if (badgeCount > 0)
                    Positioned(
                      right: -6,
                      top: -6,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 14,
                          minHeight: 14,
                        ),
                        child: Center(
                          child: Text(
                            badgeCount.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
// GestureDetector(
//   onTap: onCallTap,
//   child: icon
// ),