import 'dart:convert';

class UserModel {
  final String name;
  final String email;
  final String password;
  final String bikeStatus;
  final String? bikeBrand;
  final String? bikeModel;
  final String? bikeCc;
  final String? bikeYear;
  final String? bikeRegistration;

  UserModel({
    required this.name,
    required this.email,
    required this.password,
    required this.bikeStatus,
    this.bikeBrand,
    this.bikeModel,
    this.bikeCc,
    this.bikeYear,
    this.bikeRegistration,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'bikeStatus': bikeStatus,
      'bikeBrand': bikeBrand,
      'bikeModel': bikeModel,
      'bikeCc': bikeCc,
      'bikeYear': bikeYear,
      'bikeRegistration': bikeRegistration,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      bikeStatus: map['bikeStatus'] ?? 'Don\'t have bike',
      bikeBrand: map['bikeBrand'],
      bikeModel: map['bikeModel'],
      bikeCc: map['bikeCc'],
      bikeYear: map['bikeYear'],
      bikeRegistration: map['bikeRegistration'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source));
}
