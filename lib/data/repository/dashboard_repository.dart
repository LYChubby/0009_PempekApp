import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:pempekapp/data/services/service_http_client.dart';
import 'package:pempekapp/data/models/response/dashboard_response_model.dart';

class DashboardRepository {
  final ServiceHttpClient _http;

  DashboardRepository(this._http);

  Future<Either<String, DashboardResponseModel>> getRekap() async {
    try {
      final response = await _http.get('dashboard-admin');
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final result = DashboardResponseModel.fromMap(jsonData);
        return Right(result);
      } else {
        final res = jsonDecode(response.body);
        return Left(res['message'] ?? "Gagal memuat data dashboard");
      }
    } catch (e) {
      log("Dashboard Get Error: $e");
      return Left("Terjadi kesalahan sistem");
    }
  }
}
