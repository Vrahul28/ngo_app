class Donation {
  final int id;
  final String userId;
  final double amount;
  final String type;
  final DateTime date;
  final String status;

  Donation({
    required this.id,
    required this.userId,
    required this.amount,
    required this.type,
    required this.date,
    required this.status
  });
}
