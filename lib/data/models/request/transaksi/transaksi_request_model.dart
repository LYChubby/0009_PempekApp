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
          json["items"].map((x) => PemesananRequestModel.fromMap(x)),
        ),
      );

  Map<String, dynamic> toMap() => {
    "user_id": userId,
    "pengiriman": pengiriman,
    "metode_pembayaran": metodePembayaran,
    "items": detail.map((e) => e.toMap()).toList(),
  };

  Map<String, String> toMultipartMap() {
    final Map<String, String> map = {
      'user_id': userId.toString(),
      'pengiriman': pengiriman,
      'metode_pembayaran': metodePembayaran,
    };

    for (int i = 0; i < detail.length; i++) {
      map['items[$i][menu_id]'] = detail[i].menuId.toString();
      map['items[$i][jumlah]'] = detail[i].jumlah.toString();
      map['items[$i][harga_satuan]'] = detail[i].hargaSatuan.toString();
      map['items[$i][total_harga]'] = detail[i].totalHarga.toString();
    }

    return map;
  }
}
