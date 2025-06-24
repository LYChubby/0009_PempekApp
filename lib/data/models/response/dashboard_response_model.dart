import 'dart:convert';

class DashboardResponseModel {
  final int? totalPenjualan;
  final String? totalPemasukan;
  final int? totalPengeluaran;
  final int? balance;

  DashboardResponseModel({
    this.totalPenjualan,
    this.totalPemasukan,
    this.totalPengeluaran,
    this.balance,
  });

  factory DashboardResponseModel.fromJson(String str) =>
      DashboardResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DashboardResponseModel.fromMap(Map<String, dynamic> json) =>
      DashboardResponseModel(
        totalPenjualan: json["total_penjualan"],
        totalPemasukan: json["total_pemasukan"],
        totalPengeluaran: json["total_pengeluaran"],
        balance: json["balance"],
      );

  Map<String, dynamic> toMap() => {
    "total_penjualan": totalPenjualan,
    "total_pemasukan": totalPemasukan,
    "total_pengeluaran": totalPengeluaran,
    "balance": balance,
  };
}
