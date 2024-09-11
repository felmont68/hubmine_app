import 'dart:convert';

class User {
  String token;
  int idUser;
  String firstName;
  String lastName;
  String email;
  String phoneNumber;
  String businessName;
  String businessType;
  String rfc;
  String profilePhoto;
  int typeUser;
  int statusAccountId;
  int customerTypeID;
  User(
      {required this.token,
      required this.idUser,
      required this.firstName,
      required this.lastName,
      required this.email,
      required this.phoneNumber,
      required this.businessName,
      required this.businessType,
      required this.rfc,
      required this.profilePhoto,
      required this.typeUser,
      required this.statusAccountId,
      required this.customerTypeID});

  Map<String, dynamic> toMap() {
    return {
      'token': token,
      'idUser': idUser,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phoneNumber': phoneNumber,
      "businessName": businessName,
      "profilePhoto": profilePhoto,
      "businessType": businessType,
      'typeUser': typeUser,
      "statusAccountId": statusAccountId,
      "customerTypeID": customerTypeID,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
        token: map['token'] ?? '',
        idUser: map['id']?.toInt() ?? 0,
        firstName: map['first_name'] ?? '',
        lastName: map['last_name'] ?? '',
        phoneNumber: map['phone_number'] ?? '',
        businessName: map['business_name'] ?? '',
        businessType: map['business_type'] ?? '',
        rfc: map['rfc'] ?? '',
        profilePhoto: map['profile_photo'] ?? '',
        email: map['email'] ?? '',
        typeUser: map['user_type_id']?.toInt() ?? 0,
        statusAccountId: map['status_account_id'] ?? 0,
        customerTypeID: map['customer_type_id'] ?? 0);
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));
}
