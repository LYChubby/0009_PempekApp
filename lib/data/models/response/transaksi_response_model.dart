import 'dart:convert';
import 'pemesanan_response_model.dart';

class TransaksiResponseModel {
  final int? id;
  final int? userId;
  final String? pengiriman;
  final String? metodePembayaran;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<PemesananResponseModel>? pemesanan;

  TransaksiResponseModel({
    this.id,
    this.userId,
    this.pengiriman,
    this.metodePembayaran,
    this.createdAt,
    this.updatedAt,
    this.pemesanan,
  });

  factory TransaksiResponseModel.fromJson(String str) =>
      TransaksiResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory TransaksiResponseModel.fromMap(Map<String, dynamic> json) =>
      TransaksiResponseModel(
        id: json["id"],
        userId: json["user_id"],
        pengiriman: json["pengiriman"],
        metodePembayaran: json["metode_pembayaran"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        pemesanan: json["pemesanan"] == null
            ? null
            : List<PemesananResponseModel>.from(
                json["pemesanan"].map((x) => PemesananResponseModel.fromMap(x)),
              ),
      );

  Map<String, dynamic> toMap() => {
    "id": id,
    "user_id": userId,
    "pengiriman": pengiriman,
    "metode_pembayaran": metodePembayaran,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "pemesanan": pemesanan?.map((x) => x.toMap()).toList(),
  };
}
