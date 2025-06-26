import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

import 'package:pempekapp/data/models/response/menu_response_model.dart';
import 'package:pempekapp/data/models/request/admin/menu_request_model.dart';
import 'package:pempekapp/data/services/service_http_client.dart';

class MenuRepository {
  final ServiceHttpClient _client;

  MenuRepository(this._client);

  Future<Either<String, List<MenuResponseModel>>> fetchAllMenu() async {
    try {
      final response = await _client.get("menu");

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final List<MenuResponseModel> menuList = data
            .map((e) => MenuResponseModel.fromMap(e))
            .toList();

        return Right(menuList);
      } else {
        return Left("Gagal memuat data menu");
      }
    } catch (e) {
      log("Fetch Menu Error: $e");
      return Left("Terjadi kesalahan saat memuat data menu");
    }
  }

  Future<Either<String, MenuResponseModel>> fetchMenuDetail(int id) async {
    try {
      final response = await _client.get("menu/$id");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Right(MenuResponseModel.fromMap(data));
      } else {
        return Left("Menu tidak ditemukan");
      }
    } catch (e) {
      log("Fetch Menu Detail Error: $e");
      return Left("Terjadi kesalahan saat memuat detail menu");
    }
  }

  Future<Either<String, String>> createMenu(MenuRequestModel model) async {
    try {
      final response = await _client.postWithToken("menu", model.toMap());

      if (response.statusCode == 201) {
        return Right("Menu berhasil ditambahkan");
      } else {
        final data = jsonDecode(response.body);
        return Left(data["message"] ?? "Gagal menambahkan menu");
      }
    } catch (e) {
      log("Create Menu Error: $e");
      return Left("Terjadi kesalahan saat menambahkan menu");
    }
  }

  Future<Either<String, String>> updateMenu(
    int id,
    MenuRequestModel model,
  ) async {
    try {
      final response = await _client.putWithToken("menu/$id", model.toMap());

      if (response.statusCode == 200) {
        return Right("Menu berhasil diperbarui");
      } else {
        final data = jsonDecode(response.body);
        return Left(data["message"] ?? "Gagal memperbarui menu");
      }
    } catch (e) {
      log("Update Menu Error: $e");
      return Left("Terjadi kesalahan saat memperbarui menu");
    }
  }

  Future<Either<String, String>> deleteMenu(int id) async {
    try {
      final response = await _client.deleteWithToken("menu/$id");

      if (response.statusCode == 200) {
        return Right("Menu berhasil dihapus");
      } else {
        final data = jsonDecode(response.body);
        return Left(data["message"] ?? "Gagal menghapus menu");
      }
    } catch (e) {
      log("Delete Menu Error: $e");
      return Left("Terjadi kesalahan saat menghapus menu");
    }
  }
}
