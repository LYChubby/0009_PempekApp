import 'dart:convert';

class PengeluaranResponseModel {
  final int? id;
  final String? keterangan;
  final int? jumlah;
  final DateTime? tanggal;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  PengeluaranResponseModel({
    this.id,
    this.keterangan,
    this.jumlah,
    this.tanggal,
    this.createdAt,
    this.updatedAt,
  });

  factory PengeluaranResponseModel.fromJson(String str) =>
      PengeluaranResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PengeluaranResponseModel.fromMap(Map<String, dynamic> json) =>
      PengeluaranResponseModel(
        id: json["id"],
        keterangan: json["keterangan"],
        jumlah: json["jumlah"],
        tanggal: json["tanggal"] == null
            ? null
            : DateTime.parse(json["tanggal"]),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toMap() => {
    "id": id,
    "keterangan": keterangan,
    "jumlah": jumlah,
    "tanggal":
        "${tanggal!.year.toString().padLeft(4, '0')}-${tanggal!.month.toString().padLeft(2, '0')}-${tanggal!.day.toString().padLeft(2, '0')}",
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
