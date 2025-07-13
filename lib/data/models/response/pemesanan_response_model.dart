import 'dart:convert';

class PemesananResponseModel {
  final int? id;
  final int? userId;
  final int? menuId;
  final int? jumlah;
  final int? hargaSatuan;
  final int? totalHarga;
  final String? statusPesanan;
  final String? pengiriman;
  final String? metodePembayaran;
  final String? statusBayar;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final User? user;
  final Menu? menu;

  PemesananResponseModel({
    this.id,
    this.userId,
    this.menuId,
    this.jumlah,
    this.hargaSatuan,
    this.totalHarga,
    this.statusPesanan,
    this.pengiriman,
    this.metodePembayaran,
    this.statusBayar,
    this.createdAt,
    this.updatedAt,
    this.user,
    this.menu,
  });

  factory PemesananResponseModel.fromJson(String str) =>
      PemesananResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PemesananResponseModel.fromMap(Map<String, dynamic> json) =>
      PemesananResponseModel(
        id: json["id"],
        userId: json["user_id"],
        menuId: json["menu_id"],
        jumlah: json["jumlah"],
        hargaSatuan: json["harga_satuan"],
        totalHarga: json["total_harga"],
        statusPesanan: json["status_pesanan"],
        pengiriman: json["pengiriman"],
        metodePembayaran: json["metode_pembayaran"],
        statusBayar: json["status_bayar"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        user: json["user"] == null ? null : User.fromMap(json["user"]),
        menu: json["menu"] == null ? null : Menu.fromMap(json["menu"]),
      );

  Map<String, dynamic> toMap() => {
    "id": id,
    "user_id": userId,
    "menu_id": menuId,
    "jumlah": jumlah,
    "harga_satuan": hargaSatuan,
    "total_harga": totalHarga,
    "status_pesanan" : statusPesanan,
    "pengiriman": pengiriman,
    "metode_pembayaran": metodePembayaran,
    "status_bayar": statusBayar,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "user": user?.toMap(),
    "menu": menu?.toMap(),
  };
}

class Menu {
  final int? id;
  final String? nama;
  final String? deskripsi;
  final int? harga;
  final dynamic gambar;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Menu({
    this.id,
    this.nama,
    this.deskripsi,
    this.harga,
    this.gambar,
    this.createdAt,
    this.updatedAt,
  });

  factory Menu.fromJson(String str) => Menu.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Menu.fromMap(Map<String, dynamic> json) => Menu(
    id: json["id"],
    nama: json["nama"],
    deskripsi: json["deskripsi"],
    harga: json["harga"],
    gambar: json["gambar"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "nama": nama,
    "deskripsi": deskripsi,
    "harga": harga,
    "gambar": gambar,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

class User {
  final int? id;
  final String? name;
  final String? email;
  final String? noHp;
  final String? alamat;
  final String? role;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  User({
    this.id,
    this.name,
    this.email,
    this.noHp,
    this.alamat,
    this.role,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(String str) => User.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory User.fromMap(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    noHp: json["no_hp"],
    alamat: json["alamat"],
    role: json["role"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "email": email,
    "no_hp": noHp,
    "alamat": alamat,
    "role": role,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
