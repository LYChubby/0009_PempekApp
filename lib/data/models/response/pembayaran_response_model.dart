import 'dart:convert';

import 'package:pempekapp/data/models/response/transaksi_response_model.dart';

class PembayaranResponseModel {
  final int? id;
  final int? transaksiId;
  final String? buktiBayar;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final TransaksiResponseModel? transaksi;

  PembayaranResponseModel({
    this.id,
    this.transaksiId,
    this.buktiBayar,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.transaksi,
  });

  factory PembayaranResponseModel.fromJson(String str) =>
      PembayaranResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PembayaranResponseModel.fromMap(Map<String, dynamic> json) =>
      PembayaranResponseModel(
        id: json["id"],
        transaksiId: json["transaksi_id"],
        buktiBayar: json["bukti_bayar"],
        status: json["status"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        transaksi: json["transaksi"] == null
            ? null
            : TransaksiResponseModel.fromMap(json["transaksi"]),
      );

  Map<String, dynamic> toMap() => {
    "id": id,
    "transaksi_id": transaksiId,
    "bukti_bayar": buktiBayar,
    "status": status,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "transaksi": transaksi?.toMap(),
  };
}
