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
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
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
        data!.add(Datum.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['page'] = page;
    data['pageSize'] = pageSize;
    data['totalRecords'] = totalRecords;
    data['totalPages'] = totalPages;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['contactNumber'] = contactNumber;
    data['passwordHash'] = passwordHash;
    data['isEmailVerified'] = isEmailVerified;
    data['createdAt'] = createdAt;
    data['fireBaseId'] = fireBaseId;
    return data;
  }

}
