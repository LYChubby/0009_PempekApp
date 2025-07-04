import 'dart:convert';

class PembayaranRequestModel {
  final int? transaksiId;
  final String? buktiBayar;
  final String? status;

  PembayaranRequestModel({this.transaksiId, this.buktiBayar, this.status});

  PembayaranRequestModel copyWith({
    int? transaksiId,
    String? buktiBayar,
    String? status,
  }) {
    return PembayaranRequestModel(
      transaksiId: transaksiId ?? this.transaksiId,
      buktiBayar: buktiBayar ?? this.buktiBayar,
      status: status ?? this.status,
    );
  }

  factory PembayaranRequestModel.fromJson(String str) =>
      PembayaranRequestModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PembayaranRequestModel.fromMap(Map<String, dynamic> json) =>
      PembayaranRequestModel(
        transaksiId: json["transaksi_id"],
        buktiBayar: json["bukti_bayar"],
        status: json["status"],
      );

  Map<String, dynamic> toMap() => {
    "transaksi_id": transaksiId,
    "bukti_bayar": buktiBayar,
    "status": status ?? "pending",
  };
}
