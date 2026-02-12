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
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['campaignId'] = this.campaignId;
    data['paymentId'] = this.paymentId;
    data['amount'] = this.amount;
    data['success'] = this.success;
    data['donationType'] = this.donationType;
    data['paymentDate'] = this.paymentDate;
    data['createdAt'] = this.createdAt;
    return data;
  }
}
