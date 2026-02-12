// class Members {
//   final String id;
//   final String name;
//   final String email;
//   final String role;
//   final double amount; // Recurring donation amount
//   Members(
//       {required this.id,
//         required this.name,
//         required this.email,
//         required this.role,
//         required this.amount
//       });
// }

class Members {
  int? status;
  String? message;
  Data? data;

  Members({this.status, this.message, this.data});

  Members.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }

}

class Data {
  int? page;
  int? pageSize;
  int? totalRecords;
  int? totalPages;
  List<Datum>? data;

  Data(
      {this.page,
        this.pageSize,
        this.totalRecords,
        this.totalPages,
        this.data});

  Data.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    pageSize = json['pageSize'];
    totalRecords = json['totalRecords'];
    totalPages = json['totalPages'];
    if (json['data'] != null) {
      data = <Datum>[];
      json['data'].forEach((v) {
        data!.add(new Datum.fromJson(v));
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

class Datum {
  String? id;
  String? name;
  String? email;
  String? contactNumber;
  String? passwordHash;
  bool? isEmailVerified;
  String? createdAt;
  String? fireBaseId;

  Datum(
      {this.id,
        this.name,
        this.email,
        this.contactNumber,
        this.passwordHash,
        this.isEmailVerified,
        this.createdAt,
        this.fireBaseId
      });

  Datum.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    contactNumber = json['contactNumber'];
    passwordHash = json['passwordHash'];
    isEmailVerified = json['isEmailVerified'];
    createdAt = json['createdAt'];
    fireBaseId = json['fireBaseId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['contactNumber'] = this.contactNumber;
    data['passwordHash'] = this.passwordHash;
    data['isEmailVerified'] = this.isEmailVerified;
    data['createdAt'] = this.createdAt;
    data['fireBaseId'] = this.fireBaseId;
    return data;
  }

}
