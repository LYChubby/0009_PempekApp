import 'dart:convert';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:pempekapp/data/models/request/transaksi/transaksi_request_model.dart';
import 'package:pempekapp/data/services/service_http_client.dart';

class TransaksiRepository {
  final ServiceHttpClient _http;

  TransaksiRepository(this._http);

  Future<Either<String, int>> create({
    required TransaksiRequestModel model,
    File? buktiBayarFile,
  }) async {
    try {
      if (buktiBayarFile != null) {
        // Gunakan multipart request jika ada file bukti bayar
        final response = await _http.multipartPostWithToken(
          endpoint: "checkout",
          fields: model.toMultipartMap(),
          fileFieldName: "bukti_bayar",
          filePath: buktiBayarFile.path,
        );

        final responseData = await response.stream.bytesToString();
        final decodedData = jsonDecode(responseData);

        if (response.statusCode == 201) {
          final transaksiId = decodedData['data']['id'];
          return Right(transaksiId);
        } else {
          return Left(decodedData['message'] ?? 'Gagal membuat transaksi');
        }
      } else {
        // Gunakan request biasa jika tidak ada file
        final response = await _http.post('checkout', model.toMap());
        final responseData = jsonDecode(response.body);

        if (response.statusCode == 201) {
          final transaksiId = responseData['data']['id'];
          return Right(transaksiId);
        } else {
          return Left(responseData['message'] ?? 'Gagal membuat transaksi');
        }
      }
    } catch (e) {
      return Left('Terjadi kesalahan: ${e.toString()}');
    }
  }
}
