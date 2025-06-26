import 'dart:convert';

class PemesananRequestModel {
  final int? userId;
  final int? menuId;
  final int? jumlah;
  final int? hargaSatuan;
  final int? totalHarga;
  final String? pengiriman;
  final String? pembayaran;
  final String? statusBayar;

  PemesananRequestModel({
    this.userId,
    this.menuId,
    this.jumlah,
    this.hargaSatuan,
    this.totalHarga,
    this.pengiriman,
    this.pembayaran,
    this.statusBayar,
  });

  factory PemesananRequestModel.fromJson(String str) =>
      PemesananRequestModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PemesananRequestModel.fromMap(Map<String, dynamic> json) =>
      PemesananRequestModel(
        userId: json["user_id"],
        menuId: json["menu_id"],
        jumlah: json["jumlah"],
        hargaSatuan: json["harga_satuan"],
        totalHarga: json["total_harga"],
        pengiriman: json["pengiriman"],
        pembayaran: json["pembayaran"],
        statusBayar: json["status_bayar"],
      );

  Map<String, dynamic> toMap() => {
    "user_id": userId,
    "menu_id": menuId,
    "jumlah": jumlah,
    "harga_satuan": hargaSatuan,
    "total_harga": totalHarga,
    "pengiriman": pengiriman,
    "pembayaran": pembayaran,
    "status_bayar": statusBayar,
  };
}
