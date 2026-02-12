class CampaignModel {
  int? status;
  String? message;
  List<Data>? data;

  CampaignModel({this.status, this.message, this.data});

  CampaignModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? id;
  String? title;
  String? description;
  double? targetAmount;
  double? raisedAmount;
  String? startDate;
  String? endDate;
  bool? isActive;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.id,
        this.title,
        this.description,
        this.targetAmount,
        this.raisedAmount,
        this.startDate,
        this.endDate,
        this.isActive,
        this.createdAt,
        this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    targetAmount = json['targetAmount'];
    raisedAmount = json['raisedAmount'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    isActive = json['isActive'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['targetAmount'] = this.targetAmount;
    data['raisedAmount'] = this.raisedAmount;
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    data['isActive'] = this.isActive;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
