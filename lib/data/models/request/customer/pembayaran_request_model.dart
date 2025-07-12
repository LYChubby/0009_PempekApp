import 'dart:convert';
import 'package:image_picker/image_picker.dart';

class PembayaranRequestModel {
  final int? transaksiId;
  final String? buktiBayar;
  final String? status;
  final XFile? buktiBayarFile;

  PembayaranRequestModel({
    this.transaksiId,
    this.buktiBayar,
    this.status,
    this.buktiBayarFile,
  });

  PembayaranRequestModel copyWith({
    int? transaksiId,
    String? buktiBayar,
    String? status,
    XFile? buktiBayarFile,
  }) {
    return PembayaranRequestModel(
      transaksiId: transaksiId ?? this.transaksiId,
      buktiBayar: buktiBayar ?? this.buktiBayar,
      status: status ?? this.status,
      buktiBayarFile: buktiBayarFile ?? this.buktiBayarFile,
    );
  }

  factory PembayaranRequestModel.fromJson(String str) =>
      PembayaranRequestModel.fromMap(json.decode(str));

  factory PembayaranRequestModel.fromMap(Map<String, dynamic> json) =>
      PembayaranRequestModel(
        transaksiId: json["transaksi_id"],
        buktiBayar: json["bukti_bayar"],
        status: json["status"],
      );

  Map<String, dynamic> toMap() => {
    "transaksi_id": transaksiId,
    "status": status ?? "pending",
  };

  Map<String, String> toMultipartMap() => {
    'transaksi_id': transaksiId?.toString() ?? '',
    'status': status ?? 'pending',
  };
}
