import 'dart:convert';

class MenuRequestModel {
  final int? pemesananId;
  final String? buktiBayar;
  final String? status;

  MenuRequestModel({this.pemesananId, this.buktiBayar, this.status});

  factory MenuRequestModel.fromJson(String str) =>
      MenuRequestModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory MenuRequestModel.fromMap(Map<String, dynamic> json) =>
      MenuRequestModel(
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
