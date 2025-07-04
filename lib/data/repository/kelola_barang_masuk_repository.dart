import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:pempekapp/data/models/request/admin/kelola_barang_masuk_request_model.dart';
import 'package:pempekapp/data/models/response/kelola_barang_masuk_response_model.dart';
import 'package:pempekapp/data/services/service_http_client.dart';

class KelolaBarangRepository {
  final ServiceHttpClient _http;

  KelolaBarangRepository(this._http);

  Future<Either<String, List<KelolaBarangMasukResponseModel>>> getAll() async {
    try {
      final response = await _http.get('barang-masuk');
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final result = data
            .map((e) => KelolaBarangMasukResponseModel.fromMap(e))
            .toList();
        return Right(result);
      } else {
        final res = jsonDecode(response.body);
        return Left(res['message'] ?? 'Gagal mengambil data barang');
      }
    } catch (e) {
      log("Error getAll KelolaBarang: $e");
      return Left("Terjadi kesalahan sistem");
    }
  }

  Future<Either<String, KelolaBarangMasukResponseModel>> getById(int id) async {
    try {
      final response = await _http.get('barang-masuk/$id');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final result = KelolaBarangMasukResponseModel.fromMap(data);
        return Right(result);
      } else {
        final res = jsonDecode(response.body);
        return Left(res['message'] ?? 'Gagal mengambil detail barang');
      }
    } catch (e) {
      log("Error getById KelolaBarang: $e");
      return Left("Terjadi kesalahan sistem");
    }
  }

  Future<Either<String, KelolaBarangMasukResponseModel>> create(
    KelolaBarangMasukRequestModel request,
  ) async {
    try {
      final response = await _http.postWithToken(
        'barang-masuk',
        request.toMap(),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final result = KelolaBarangMasukResponseModel.fromMap(data);
        return Right(result);
      } else {
        final res = jsonDecode(response.body);
        return Left(res['message'] ?? 'Gagal menambahkan barang');
      }
    } catch (e) {
      log("Error create KelolaBarang: $e");
      return Left("Terjadi kesalahan sistem");
    }
  }

  Future<Either<String, KelolaBarangMasukResponseModel>> update(
    int id,
    KelolaBarangMasukRequestModel request,
  ) async {
    try {
      final response = await _http.putWithToken(
        'barang-masuk/$id',
        request.toMap(),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final result = KelolaBarangMasukResponseModel.fromMap(data);
        return Right(result);
      } else {
        final res = jsonDecode(response.body);
        return Left(res['message'] ?? 'Gagal memperbarui barang');
      }
    } catch (e) {
      log("Error update KelolaBarang: $e");
      return Left("Terjadi kesalahan sistem");
    }
  }

  Future<Either<String, String>> delete(int id) async {
    try {
      final response = await _http.deleteWithToken('barang-masuk/$id');
      if (response.statusCode == 200) {
        return Right("Barang berhasil dihapus");
      } else {
        final res = jsonDecode(response.body);
        return Left(res['message'] ?? 'Gagal menghapus barang');
      }
    } catch (e) {
      log("Error delete KelolaBarang: $e");
      return Left("Terjadi kesalahan sistem");
    }
  }
}
