class PaymentDataForUser {
  String? userId;
  int? totalContribution;

  PaymentDataForUser({
    required this.userId,
    required this.totalContribution,
  });

  PaymentDataForUser.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    totalContribution = json['totalContribution'];
  }

}
