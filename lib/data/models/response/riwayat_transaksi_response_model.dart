import 'dart:convert';

class RiwayatTransaksiResponseModel {
  final int? idTransaksi;
  final String? namaUser;
  final String? pengiriman;
  final String? metodePembayaran;
  final String? statusBayar;
  final String? statusPembayaran;
  final String? statusPesanan;
  final String? buktiPembayaran;
  final DateTime? tanggalTransaksi;
  final DateTime? tanggalBayar;
  final List<Item>? items;

  RiwayatTransaksiResponseModel({
    this.idTransaksi,
    this.namaUser,
    this.pengiriman,
    this.metodePembayaran,
    this.statusBayar,
    this.statusPembayaran,
    this.statusPesanan,
    this.buktiPembayaran,
    this.tanggalTransaksi,
    this.tanggalBayar,
    this.items,
  });

  factory RiwayatTransaksiResponseModel.fromJson(String str) =>
      RiwayatTransaksiResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory RiwayatTransaksiResponseModel.fromMap(Map<String, dynamic> json) =>
      RiwayatTransaksiResponseModel(
        idTransaksi: json["id_transaksi"],
        namaUser: json["nama_user"],
        pengiriman: json["pengiriman"],
        metodePembayaran: json["metode_pembayaran"],
        statusBayar: json["status_bayar"],
        statusPembayaran: json["status_pembayaran"],
        statusPesanan: json["status_pesanan"],
        buktiPembayaran: json["bukti_pembayaran"],
        tanggalTransaksi: json["tanggal_transaksi"] == null
            ? null
            : DateTime.parse(json["tanggal_transaksi"]),
        tanggalBayar: json["tanggal_bayar"] == null
            ? null
            : DateTime.parse(json["tanggal_bayar"]),
        items: json["items"] == null
            ? []
            : List<Item>.from(json["items"]!.map((x) => Item.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
    "id_transaksi": idTransaksi,
    "nama_user": namaUser,
    "pengiriman": pengiriman,
    "metode_pembayaran": metodePembayaran,
    "status_bayar": statusBayar,
    "status_pembayaran": statusPembayaran,
    "status_pesanan": statusPesanan,
    "bukti_pembayaran": buktiPembayaran,
    "tanggal_transaksi": tanggalTransaksi?.toIso8601String(),
    "tanggal_bayar": tanggalBayar?.toIso8601String(),
    "items": items == null
        ? []
        : List<dynamic>.from(items!.map((x) => x.toMap())),
  };
}

class Item {
  final String? menu;
  final int? jumlah;
  final int? hargaSatuan;
  final int? totalHarga;

  Item({this.menu, this.jumlah, this.hargaSatuan, this.totalHarga});

  factory Item.fromJson(String str) => Item.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Item.fromMap(Map<String, dynamic> json) => Item(
    menu: json["menu"],
    jumlah: json["jumlah"],
    hargaSatuan: json["harga_satuan"],
    totalHarga: json["total_harga"],
  );

  Map<String, dynamic> toMap() => {
    "menu": menu,
    "jumlah": jumlah,
    "harga_satuan": hargaSatuan,
    "total_harga": totalHarga,
  };
}
