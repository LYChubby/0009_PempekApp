import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:pempekapp/data/models/response/pembayaran_response_model.dart';
import 'package:pempekapp/data/services/service_http_client.dart';

class PembayaranRepository {
  final ServiceHttpClient _http;

  PembayaranRepository(this._http);

  /// Ambil semua pembayaran (admin & customer)
  Future<Either<String, List<PembayaranResponseModel>>> getAll() async {
    try {
      final response = await _http.get('pembayaran');

      if (response.statusCode == 200) {
        final List body = jsonDecode(response.body);
        final data = body
            .map((e) => PembayaranResponseModel.fromMap(e))
            .toList();
        return Right(data);
      } else {
        return Left("Gagal mengambil data pembayaran");
      }
    } catch (e) {
      log("Get Pembayaran Error: $e");
      return Left("Terjadi kesalahan sistem");
    }
  }

  /// Ambil detail pembayaran tertentu
  Future<Either<String, PembayaranResponseModel>> getById(int id) async {
    try {
      final response = await _http.get('pembayaran/$id');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Right(PembayaranResponseModel.fromMap(data));
      } else {
        return Left("Gagal mengambil detail pembayaran");
      }
    } catch (e) {
      log("Get Pembayaran by ID Error: $e");
      return Left("Terjadi kesalahan sistem");
    }
  }

  /// Buat pembayaran baru (upload bukti bayar)
  Future<Either<String, String>> create({
    required int pemesananId,
    required String buktiBayar,
  }) async {
    try {
      final response = await _http.multipartPostWithToken(
        endpoint: 'pembayaran',
        fields: {'pemesanan_id': pemesananId.toString()},
        fileFieldName: 'bukti_bayar',
        filePath: buktiBayar,
      );

      if (response.statusCode == 201) {
        return Right("Pembayaran berhasil diunggah");
      } else {
        final responseBody = await response.stream.bytesToString();
        final res = jsonDecode(responseBody);
        return Left(res['message'] ?? "Gagal upload pembayaran");
      }
    } catch (e) {
      log("Create Pembayaran Error: $e");
      return Left("Terjadi kesalahan sistem");
    }
  }

  /// Hapus pembayaran (admin)
  Future<Either<String, String>> delete(int id) async {
    try {
      final response = await _http.deleteWithToken('pembayaran/$id');

      if (response.statusCode == 200) {
        return Right("Pembayaran berhasil dihapus");
      } else {
        return Left("Gagal menghapus pembayaran");
      }
    } catch (e) {
      log("Delete Pembayaran Error: $e");
      return Left("Terjadi kesalahan sistem");
    }
  }

  /// Update pembayaran (admin)
  Future<Either<String, String>> update({
    required int id,
    String? buktiBayar,
  }) async {
    try {
      final response = await _http.multipartPutWithToken(
        endpoint: 'pembayaran/$id',
        fileFieldName: 'bukti_bayar',
        filePath: buktiBayar,
        fields: {}, // tambahkan jika ada field lain
      );

      if (response.statusCode == 200) {
        return Right("Pembayaran berhasil diupdate");
      } else {
        final responseBody = await response.stream.bytesToString();
        final res = jsonDecode(responseBody);
        return Left(res['message'] ?? "Gagal update pembayaran");
      }
    } catch (e) {
      log("Update Pembayaran Error: $e");
      return Left("Terjadi kesalahan sistem");
    }
  }
}
