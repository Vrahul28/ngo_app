import 'package:flutter/material.dart';

class CustomMetricCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  const CustomMetricCard({
    required this.title,
    required this.value,
    required this.color,
    super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border(top: BorderSide(color: color, width: 4)),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 4),
            Text(value, style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: color)),
          ],
        ),
      ),
    );
  }
}
