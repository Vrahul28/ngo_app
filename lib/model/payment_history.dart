class PaymentHistoryModel {
  int? page;
  int? pageSize;
  int? totalRecords;
  int? totalPages;
  List<Data>? data;

  PaymentHistoryModel(
      {this.page,
        this.pageSize,
        this.totalRecords,
        this.totalPages,
        this.data});

  PaymentHistoryModel.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    pageSize = json['pageSize'];
    totalRecords = json['totalRecords'];
    totalPages = json['totalPages'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['page'] = this.page;
    data['pageSize'] = this.pageSize;
    data['totalRecords'] = this.totalRecords;
    data['totalPages'] = this.totalPages;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? paymentId;
  double? amount;
  String? paymentDate;
  String? userId;
  String? userName;
  String? userEmail;
  String? userMobile;

  Data(
      {this.paymentId,
        this.amount,
        this.paymentDate,
        this.userId,
        this.userName,
        this.userEmail,
        this.userMobile});

  Data.fromJson(Map<String, dynamic> json) {
    paymentId = json['paymentId'];
    amount = json['amount'];
    paymentDate = json['paymentDate'];
    userId = json['userId'];
    userName = json['userName'];
    userEmail = json['userEmail'];
    userMobile = json['userMobile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['paymentId'] = this.paymentId;
    data['amount'] = this.amount;
    data['paymentDate'] = this.paymentDate;
    data['userId'] = this.userId;
    data['userName'] = this.userName;
    data['userEmail'] = this.userEmail;
    data['userMobile'] = this.userMobile;
    return data;
  }
}
