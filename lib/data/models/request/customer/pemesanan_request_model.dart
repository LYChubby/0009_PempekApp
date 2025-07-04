import 'dart:convert';

class PemesananRequestModel {
  final int? menuId;
  final int? jumlah;
  final int? hargaSatuan;
  final int? totalHarga;

  PemesananRequestModel({
    this.menuId,
    this.jumlah,
    this.hargaSatuan,
    this.totalHarga,
  });

  factory PemesananRequestModel.fromJson(String str) =>
      PemesananRequestModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PemesananRequestModel.fromMap(Map<String, dynamic> json) =>
      PemesananRequestModel(
        menuId: json["menu_id"],
        jumlah: json["jumlah"],
        hargaSatuan: json["harga_satuan"],
        totalHarga: json["total_harga"],
      );

  Map<String, dynamic> toMap() => {
    "menu_id": menuId,
    "jumlah": jumlah,
    "harga_satuan": hargaSatuan,
    "total_harga": totalHarga,
  };
}
