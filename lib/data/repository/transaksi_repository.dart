import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:pempekapp/data/models/request/transaksi/transaksi_request_model.dart';
import 'package:pempekapp/data/services/service_http_client.dart';

class TransaksiRepository {
  final ServiceHttpClient _http;

  TransaksiRepository(this._http);

  Future<Either<String, int>> create(TransaksiRequestModel model) async {
    try {
      final response = await _http.post('checkout', model.toMap());
      final responseData = jsonDecode(response.body);

      if (response.statusCode == 201) {
        final transaksiId = responseData['data']['id'];
        return Right(transaksiId);
      } else {
        return Left(responseData['message'] ?? 'Gagal membuat transaksi');
      }
    } catch (e) {
      return Left('Terjadi kesalahan: ${e.toString()}');
    }
  }
}
