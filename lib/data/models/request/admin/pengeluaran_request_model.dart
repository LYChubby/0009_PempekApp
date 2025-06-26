import 'dart:convert';

class PengeluaranRequestModel {
  final String? keterangan;
  final int? jumlah;
  final DateTime? tanggal;

  PengeluaranRequestModel({this.keterangan, this.jumlah, this.tanggal});

  factory PengeluaranRequestModel.fromJson(String str) =>
      PengeluaranRequestModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PengeluaranRequestModel.fromMap(Map<String, dynamic> json) =>
      PengeluaranRequestModel(
        keterangan: json["keterangan"],
        jumlah: json["jumlah"],
        tanggal: json["tanggal"] == null
            ? null
            : DateTime.parse(json["tanggal"]),
      );

  Map<String, dynamic> toMap() => {
    "keterangan": keterangan,
    "jumlah": jumlah,
    "tanggal":
        "${tanggal!.year.toString().padLeft(4, '0')}-${tanggal!.month.toString().padLeft(2, '0')}-${tanggal!.day.toString().padLeft(2, '0')}",
  };
}
