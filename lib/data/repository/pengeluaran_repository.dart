import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:pempekapp/data/models/request/admin/pengeluaran_request_model.dart';
import 'package:pempekapp/data/models/response/pengeluaran_response_model.dart';
import 'package:pempekapp/data/services/service_http_client.dart';

class PengeluaranRepository {
  final ServiceHttpClient _http;

  PengeluaranRepository(this._http);

  Future<Either<String, List<PengeluaranResponseModel>>> getAll() async {
    try {
      final response = await _http.get('pengeluaran');
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final result = data
            .map((e) => PengeluaranResponseModel.fromMap(e))
            .toList();
        return Right(result);
      } else {
        final res = jsonDecode(response.body);
        return Left(res['message'] ?? 'Gagal mengambil data pengeluaran');
      }
    } catch (e) {
      log("Error getAll Pengeluaran: $e");
      return Left("Terjadi kesalahan sistem");
    }
  }

  Future<Either<String, String>> create(PengeluaranRequestModel request) async {
    try {
      final response = await _http.postWithToken(
        'pengeluaran',
        request.toMap(),
      );

      if (response.statusCode == 201) {
        return Right("Pengeluaran berhasil ditambahkan");
      } else {
        final res = jsonDecode(response.body);
        return Left(res['message'] ?? 'Gagal menambahkan pengeluaran');
      }
    } catch (e) {
      log("Error create Pengeluaran: $e");
      return Left("Terjadi kesalahan sistem");
    }
  }

  Future<Either<String, String>> update(
    int id,
    PengeluaranRequestModel request,
  ) async {
    try {
      final response = await _http.putWithToken(
        'pengeluaran/$id',
        request.toMap(),
      );

      if (response.statusCode == 200) {
        return Right("Pengeluaran berhasil diperbarui");
      } else {
        final res = jsonDecode(response.body);
        return Left(res['message'] ?? 'Gagal memperbarui pengeluaran');
      }
    } catch (e) {
      log("Error update Pengeluaran: $e");
      return Left("Terjadi kesalahan sistem");
    }
  }

  Future<Either<String, String>> delete(int id) async {
    try {
      final response = await _http.deleteWithToken('pengeluaran/$id');
      if (response.statusCode == 200) {
        return Right("Pengeluaran berhasil dihapus");
      } else {
        final res = jsonDecode(response.body);
        return Left(res['message'] ?? 'Gagal menghapus pengeluaran');
      }
    } catch (e) {
      log("Error delete Pengeluaran: $e");
      return Left("Terjadi kesalahan sistem");
    }
  }
}
