import 'dart:convert';

class MenuRequestModel {
  final String? keterangan;
  final int? jumlah;
  final DateTime? tanggal;

  MenuRequestModel({this.keterangan, this.jumlah, this.tanggal});

  factory MenuRequestModel.fromJson(String str) =>
      MenuRequestModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory MenuRequestModel.fromMap(Map<String, dynamic> json) =>
      MenuRequestModel(
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
