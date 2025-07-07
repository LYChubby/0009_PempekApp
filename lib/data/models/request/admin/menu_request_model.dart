import 'dart:convert';

import 'package:image_picker/image_picker.dart';

class MenuRequestModel {
  final String? nama;
  final String? deskripsi;
  final int? harga;
  final dynamic gambar;
  final XFile? gambarFile;

  MenuRequestModel({
    this.nama,
    this.deskripsi,
    this.harga,
    this.gambar,
    this.gambarFile,
  });

  factory MenuRequestModel.fromJson(String str) =>
      MenuRequestModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory MenuRequestModel.fromMap(Map<String, dynamic> json) =>
      MenuRequestModel(
        nama: json["nama"],
        deskripsi: json["deskripsi"],
        harga: json["harga"],
        gambar: json["gambar"],
      );

  Map<String, dynamic> toMap() => {
    "nama": nama,
    "deskripsi": deskripsi,
    "harga": harga,
    "gambar": gambar,
  };

  Map<String, String> toMultipartMap() {
    return {
      'nama': nama ?? '',
      'harga': harga?.toString() ?? '',
      'deskripsi': deskripsi ?? '',
      if (gambar != null) 'gambar': gambar!,
    };
  }
}
