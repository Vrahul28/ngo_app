import 'package:flutter/material.dart';

class CustomCardPaymentHistoryUser extends StatelessWidget {
  final String amount;
  final String date;
  final bool status;
  const CustomCardPaymentHistoryUser({
    required this.amount,
    required this.date,
    required this.status,
    super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('₹ $amount', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('$date | ${status? 'Status : Completed' : 'Status : Failed'}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
