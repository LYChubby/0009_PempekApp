import 'dart:convert';

class MenuResponseModel {
  final int? id;
  final String? nama;
  final String? deskripsi;
  final int? harga;
  final dynamic gambar;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  MenuResponseModel({
    this.id,
    this.nama,
    this.deskripsi,
    this.harga,
    this.gambar,
    this.createdAt,
    this.updatedAt,
  });

  factory MenuResponseModel.fromJson(String str) =>
      MenuResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory MenuResponseModel.fromMap(Map<String, dynamic> json) =>
      MenuResponseModel(
        id: json["id"],
        nama: json["nama"],
        deskripsi: json["deskripsi"],
        harga: json["harga"],
        gambar: json["gambar"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toMap() => {
    "id": id,
    "nama": nama,
    "deskripsi": deskripsi,
    "harga": harga,
    "gambar": gambar,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
