import 'dart:convert';

class KelolaBarangMasukResponseModel {
  final String? namaBarang;
  final String? jumlah;
  final String? tanggalMasuk;
  final DateTime? updatedAt;
  final DateTime? createdAt;
  final int? id;

  KelolaBarangMasukResponseModel({
    this.namaBarang,
    this.jumlah,
    this.tanggalMasuk,
    this.updatedAt,
    this.createdAt,
    this.id,
  });

  factory KelolaBarangMasukResponseModel.fromJson(String str) =>
      KelolaBarangMasukResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory KelolaBarangMasukResponseModel.fromMap(Map<String, dynamic> json) =>
      KelolaBarangMasukResponseModel(
        namaBarang: json["nama_barang"],
        jumlah: json["jumlah"],
        tanggalMasuk: json["tanggal_masuk"],
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        id: json["id"],
      );

  Map<String, dynamic> toMap() => {
    "nama_barang": namaBarang,
    "jumlah": jumlah,
    "tanggal_masuk": tanggalMasuk,
    "updated_at": updatedAt?.toIso8601String(),
    "created_at": createdAt?.toIso8601String(),
    "id": id,
  };
}
