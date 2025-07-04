import 'dart:convert';
import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:pempekapp/data/models/response/riwayat_transaksi_response_model.dart';
import 'package:pempekapp/data/services/service_http_client.dart';

class RiwayatPesananRepository {
  final ServiceHttpClient _http;

  RiwayatPesananRepository(this._http);

  Future<Either<String, List<RiwayatTransaksiResponseModel>>>
  getRiwayatPesanan() async {
    try {
      final response = await _http.get("riwayat-transaksi");

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);

        final List<RiwayatTransaksiResponseModel> riwayat = jsonList
            .map((item) => RiwayatTransaksiResponseModel.fromMap(item))
            .toList();

        return Right(riwayat);
      } else {
        final res = jsonDecode(response.body);
        return Left(res['message'] ?? "Gagal mengambil data riwayat pesanan");
      }
    } catch (e, st) {
      log("Riwayat Error", error: e, stackTrace: st);
      return Left("Terjadi kesalahan sistem saat mengambil riwayat pesanan");
    }
  }

  Future<Either<String, bool>> updateStatusBayar(
    int id,
    String status,
    String statusPembayaran,
  ) async {
    try {
      final response = await _http.putWithToken("checkout/$id/", {
        'status_bayar': status,
        'status': statusPembayaran,
      });

      if (response.statusCode == 200) {
        return Right(true);
      } else {
        final res = jsonDecode(response.body);
        return Left(res['message'] ?? "Gagal memperbarui status bayar");
      }
    } catch (e) {
      log("Update StatusBayar Error", error: e);
      return Left("Terjadi kesalahan saat mengupdate status bayar");
    }
  }

  Future<Either<String, bool>> verifikasiPembayaran(
    int id,
    String status,
  ) async {
    try {
      final response = await _http.putWithToken("pembayaran/$id/", {
        'status': status,
      });

      if (response.statusCode == 200) {
        return Right(true);
      } else {
        final res = jsonDecode(response.body);
        return Left(res['message'] ?? "Gagal verifikasi pembayaran");
      }
    } catch (e) {
      log("Verifikasi Error", error: e);
      return Left("Terjadi kesalahan saat verifikasi pembayaran");
    }
  }

  Future<Either<String, bool>> deleteTransaksi(int id) async {
    try {
      final response = await _http.deleteWithToken("checkout/$id");

      if (response.statusCode == 200) {
        return Right(true);
      } else {
        final res = jsonDecode(response.body);
        return Left(res['message'] ?? "Gagal menghapus transaksi");
      }
    } catch (e) {
      log("Delete Transaksi Error", error: e);
      return Left("Terjadi kesalahan saat menghapus transaksi");
    }
  }
}
