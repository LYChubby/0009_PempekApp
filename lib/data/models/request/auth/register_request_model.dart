import 'dart:convert';

class RegisterRequestModel {
  final String? name;
  final String? email;
  final String? password;
  final String? passwordConfirmation;
  final String? noHp;
  final String? alamat;
  final String? role;

  RegisterRequestModel({
    this.name,
    this.email,
    this.password,
    this.passwordConfirmation,
    this.noHp,
    this.alamat,
    this.role,
  });

  factory RegisterRequestModel.fromJson(String str) =>
      RegisterRequestModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory RegisterRequestModel.fromMap(Map<String, dynamic> json) =>
      RegisterRequestModel(
        name: json["name"],
        email: json["email"],
        password: json["password"],
        passwordConfirmation: json["password_confirmation"],
        noHp: json["no_hp"],
        alamat: json["alamat"],
        role: json["role"],
      );

  Map<String, dynamic> toMap() => {
    "name": name,
    "email": email,
    "password": password,
    "password_confirmation": passwordConfirmation,
    "no_hp": noHp,
    "alamat": alamat,
    "role": role,
  };
}
