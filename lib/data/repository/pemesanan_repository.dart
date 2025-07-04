import 'dart:convert';
import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:pempekapp/data/models/request/customer/pemesanan_request_model.dart';
import 'package:pempekapp/data/models/response/pemesanan_response_model.dart';
import 'package:pempekapp/data/services/service_http_client.dart';

class PemesananRepository {
  final ServiceHttpClient _serviceHttpClient;

  PemesananRepository(this._serviceHttpClient);

  /// Ambil semua pemesanan (untuk admin atau customer berdasarkan role)
  Future<Either<String, List<PemesananResponseModel>>> getAll() async {
    try {
      final response = await _serviceHttpClient.get('pemesanan');

      if (response.statusCode == 200) {
        final List<dynamic> body = jsonDecode(response.body);
        final result = body
            .map((item) => PemesananResponseModel.fromMap(item))
            .toList();
        return Right(result);
      } else {
        return Left('Gagal memuat data pemesanan');
      }
    } catch (e) {
      log('Error getAll pemesanan: $e');
      return Left('Terjadi kesalahan sistem.');
    }
  }

  /// Ambil detail satu pemesanan
  Future<Either<String, PemesananResponseModel>> getById(int id) async {
    try {
      final response = await _serviceHttpClient.get('pemesanan/$id');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Right(PemesananResponseModel.fromMap(data));
      } else {
        return Left('Gagal memuat detail pemesanan');
      }
    } catch (e) {
      log('Error getById pemesanan: $e');
      return Left('Terjadi kesalahan sistem.');
    }
  }

  /// NOTE: Fungsi create() untuk pemesanan tidak lagi digunakan.
  /// Semua pemesanan dibuat sebagai bagian dari transaksi.

  /// Update pemesanan (jika perlu untuk admin)
  Future<Either<String, String>> update(
    int id,
    PemesananRequestModel model,
  ) async {
    try {
      final response = await _serviceHttpClient.putWithToken(
        'pemesanan/$id',
        model.toMap(),
      );

      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return Right('Pemesanan berhasil diupdate');
      } else {
        return Left(responseData['message'] ?? 'Gagal update pemesanan');
      }
    } catch (e) {
      log('Error update pemesanan: $e');
      return Left('Terjadi kesalahan sistem.');
    }
  }

  /// Hapus pemesanan (untuk admin)
  Future<Either<String, String>> delete(int id) async {
    try {
      final response = await _serviceHttpClient.deleteWithToken(
        'pemesanan/$id',
      );

      if (response.statusCode == 200) {
        return Right('Pemesanan berhasil dihapus');
      } else {
        return Left('Gagal menghapus pemesanan');
      }
    } catch (e) {
      log('Error delete pemesanan: $e');
      return Left('Terjadi kesalahan sistem.');
    }
  }
}
