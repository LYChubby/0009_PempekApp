import 'dart:convert';
import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:pempekapp/data/models/response/pembayaran_response_model.dart';
import 'package:pempekapp/data/services/service_http_client.dart';

class RiwayatPesananRepository {
  final ServiceHttpClient _http;

  RiwayatPesananRepository(this._http);

  Future<Either<String, List<PembayaranResponseModel>>>
  getRiwayatPesanan() async {
    try {
      final response = await _http.get("riwayat-transaksi");

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        final List<PembayaranResponseModel> riwayat = jsonList
            .map((item) => PembayaranResponseModel.fromMap(item))
            .toList();
        return Right(riwayat);
      } else {
        final res = jsonDecode(response.body);
        return Left(res['message'] ?? "Gagal mengambil data riwayat pesanan");
      }
    } catch (e) {
      log("Riwayat Error: $e");
      return Left("Terjadi kesalahan sistem saat mengambil riwayat pesanan");
    }
  }
}
