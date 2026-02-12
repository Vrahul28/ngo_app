import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomProfileButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final Color color;
  const CustomProfileButton({
    required this.title,
    required this.icon,
    required this.onTap,
    required this.color,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(width: 12),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
            const Spacer(),
            const Icon(FontAwesomeIcons.chevronRight, size: 14, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
