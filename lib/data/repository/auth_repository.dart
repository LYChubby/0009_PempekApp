import 'dart:convert';
import 'dart:developer';
import 'package:dartz/dartz.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pempekapp/data/models/request/auth/login_request_model.dart';
import 'package:pempekapp/data/models/request/auth/register_request_model.dart';
import 'package:pempekapp/data/models/response/login_response_model.dart';
import 'package:pempekapp/data/services/service_http_client.dart';

class AuthRepository {
  final ServiceHttpClient _serviceHttpClient;
  final secureStorage = FlutterSecureStorage();

  AuthRepository(this._serviceHttpClient);

  Future<Either<String, LoginResponseModel>> login(
    LoginRequestModel requestModel,
  ) async {
    try {
      final response = await _serviceHttpClient.post(
        "login",
        requestModel.toMap(),
      );
      final jsonResponse = json.decode(response.body);
      if (response.statusCode == 200) {
        final loginResponse = LoginResponseModel.fromMap(jsonResponse);
        await secureStorage.write(
          key: "authToken",
          value: loginResponse.accessToken,
        );
        await secureStorage.write(
          key: "userRole",
          value: loginResponse.user!.role,
        );
        return Right(loginResponse);
      } else {
        log("Login failed: ${jsonResponse['message']}");
        return Left(jsonResponse['message'] ?? "Login failed");
      }
    } catch (e) {
      log("Error in login: $e");
      return Left("An error occurred while logging in.");
    }
  }

  Future<Either<String, String>> register(
    RegisterRequestModel requestModel,
  ) async {
    try {
      final response = await _serviceHttpClient.post(
        "register",
        requestModel.toMap(),
      );
      final jsonResponse = json.decode(response.body);

      if (response.statusCode == 201) {
        log("Registration successful");
        return Right("Registration successful");
      } else {
        log("Registration failed: ${jsonResponse['message']}");
        return Left(jsonResponse['message'] ?? "Registration failed");
      }
    } catch (e) {
      log("Error in registration: $e");
      return Left("An error occurred while registering.");
    }
  }
}
