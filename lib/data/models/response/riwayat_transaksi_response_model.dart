import 'dart:convert';

class RiwayatTransaksiResponseModel {
  final int? idPemesanan;
  final String? menu;
  final int? jumlah;
  final int? hargaSatuan;
  final int? totalHarga;
  final String? pengiriman;
  final String? pembayaranMetode;
  final String? statusBayar;
  final String? statusPembayaran;
  final String? buktiPembayaran;
  final DateTime? tanggalPesan;
  final DateTime? tanggalBayar;

  RiwayatTransaksiResponseModel({
    this.idPemesanan,
    this.menu,
    this.jumlah,
    this.hargaSatuan,
    this.totalHarga,
    this.pengiriman,
    this.pembayaranMetode,
    this.statusBayar,
    this.statusPembayaran,
    this.buktiPembayaran,
    this.tanggalPesan,
    this.tanggalBayar,
  });

  factory RiwayatTransaksiResponseModel.fromJson(String str) =>
      RiwayatTransaksiResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory RiwayatTransaksiResponseModel.fromMap(Map<String, dynamic> json) =>
      RiwayatTransaksiResponseModel(
        idPemesanan: json["id_pemesanan"],
        menu: json["menu"],
        jumlah: json["jumlah"],
        hargaSatuan: json["harga_satuan"],
        totalHarga: json["total_harga"],
        pengiriman: json["pengiriman"],
        pembayaranMetode: json["pembayaran_metode"],
        statusBayar: json["status_bayar"],
        statusPembayaran: json["status_pembayaran"],
        buktiPembayaran: json["bukti_pembayaran"],
        tanggalPesan: json["tanggal_pesan"] == null
            ? null
            : DateTime.parse(json["tanggal_pesan"]),
        tanggalBayar: json["tanggal_bayar"] == null
            ? null
            : DateTime.parse(json["tanggal_bayar"]),
      );

  Map<String, dynamic> toMap() => {
    "id_pemesanan": idPemesanan,
    "menu": menu,
    "jumlah": jumlah,
    "harga_satuan": hargaSatuan,
    "total_harga": totalHarga,
    "pengiriman": pengiriman,
    "pembayaran_metode": pembayaranMetode,
    "status_bayar": statusBayar,
    "status_pembayaran": statusPembayaran,
    "bukti_pembayaran": buktiPembayaran,
    "tanggal_pesan": tanggalPesan?.toIso8601String(),
    "tanggal_bayar": tanggalBayar?.toIso8601String(),
  };
}
