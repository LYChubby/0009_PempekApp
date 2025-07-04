import 'dart:convert';

class KelolaBarangMasukRequestModel {
  final String? namaBarang;
  final String? jumlah;
  final String? tanggalMasuk;

  KelolaBarangMasukRequestModel({
    this.namaBarang,
    this.jumlah,
    this.tanggalMasuk,
  });

  factory KelolaBarangMasukRequestModel.fromJson(String str) =>
      KelolaBarangMasukRequestModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory KelolaBarangMasukRequestModel.fromMap(Map<String, dynamic> json) =>
      KelolaBarangMasukRequestModel(
        namaBarang: json["nama_barang"],
        jumlah: json["jumlah"],
        tanggalMasuk: json["tanggal_masuk"],
      );

  Map<String, dynamic> toMap() => {
    "nama_barang": namaBarang,
    "jumlah": jumlah,
    "tanggal_masuk": tanggalMasuk,
  };
}
