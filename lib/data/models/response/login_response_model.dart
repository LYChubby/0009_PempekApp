import 'dart:convert';

class LoginResponseModel {
  final String? accessToken;
  final String? tokenType;
  final User? user;

  LoginResponseModel({this.accessToken, this.tokenType, this.user});

  factory LoginResponseModel.fromJson(String str) =>
      LoginResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory LoginResponseModel.fromMap(Map<String, dynamic> json) =>
      LoginResponseModel(
        accessToken: json["access_token"],
        tokenType: json["token_type"],
        user: json["user"] == null ? null : User.fromMap(json["user"]),
      );

  Map<String, dynamic> toMap() => {
    "access_token": accessToken,
    "token_type": tokenType,
    "user": user?.toMap(),
  };
}

class User {
  final int? id;
  final String? name;
  final String? email;
  final String? noHp;
  final String? alamat;
  final String? role;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  User({
    this.id,
    this.name,
    this.email,
    this.noHp,
    this.alamat,
    this.role,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(String str) => User.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory User.fromMap(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    noHp: json["no_hp"],
    alamat: json["alamat"],
    role: json["role"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "email": email,
    "no_hp": noHp,
    "alamat": alamat,
    "role": role,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
