import 'dart:convert';

class PembayaranRequestModel {
  final int? pemesananId;
  final String? buktiBayar;
  final String? status;

  PembayaranRequestModel({this.pemesananId, this.buktiBayar, this.status});

  factory PembayaranRequestModel.fromJson(String str) =>
      PembayaranRequestModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PembayaranRequestModel.fromMap(Map<String, dynamic> json) =>
      PembayaranRequestModel(
        pemesananId: json["pemesanan_id"],
        buktiBayar: json["bukti_bayar"],
        status: json["status"],
      );

  Map<String, dynamic> toMap() => {
    "pemesanan_id": pemesananId,
    "bukti_bayar": buktiBayar,
    "status": status,
  };
}
