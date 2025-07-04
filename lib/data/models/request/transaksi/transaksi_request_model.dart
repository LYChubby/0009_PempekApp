import 'dart:convert';
import 'package:pempekapp/data/models/request/customer/pemesanan_request_model.dart';

class TransaksiRequestModel {
  final int userId;
  final String pengiriman;
  final String metodePembayaran;
  final List<PemesananRequestModel> detail;

  TransaksiRequestModel({
    required this.userId,
    required this.pengiriman,
    required this.metodePembayaran,
    required this.detail,
  });

  factory TransaksiRequestModel.fromJson(String str) =>
      TransaksiRequestModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory TransaksiRequestModel.fromMap(Map<String, dynamic> json) =>
      TransaksiRequestModel(
        userId: json["user_id"],
        pengiriman: json["pengiriman"],
        metodePembayaran: json["metode_pembayaran"],
        detail: List<PemesananRequestModel>.from(
          json["detail"].map((x) => PemesananRequestModel.fromMap(x)),
        ),
      );

  Map<String, dynamic> toMap() => {
    "user_id": userId,
    "pengiriman": pengiriman,
    "metode_pembayaran": metodePembayaran,
    "detail": detail.map((e) => e.toMap()).toList(),
  };
}
