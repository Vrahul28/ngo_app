class PaymentHistoryUser {
  String? id;
  String? userId;
  String? campaignId;
  String? paymentId;
  double? amount;
  bool? success;
  String? donationType;
  String? paymentDate;
  String? createdAt;

  PaymentHistoryUser(
      {this.id,
        this.userId,
        this.campaignId,
        this.paymentId,
        this.amount,
        this.success,
        this.donationType,
        this.paymentDate,
        this.createdAt});

  PaymentHistoryUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    campaignId = json['campaignId'];
    paymentId = json['paymentId'];
    amount = json['amount'];
    success = json['success'];
    donationType = json['donationType'];
    paymentDate = json['paymentDate'];
    createdAt = json['createdAt'];
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = <dynamic, dynamic>{};
    data['id'] = id;
    data['userId'] = userId;
    data['campaignId'] = campaignId;
    data['paymentId'] = paymentId;
    data['amount'] = amount;
    data['success'] = success;
    data['donationType'] = donationType;
    data['paymentDate'] = paymentDate;
    data['createdAt'] = createdAt;
    return data;
  }
}
