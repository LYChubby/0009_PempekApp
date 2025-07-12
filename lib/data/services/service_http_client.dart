import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ServiceHttpClient {
  final String baseurl = 'http://10.0.2.2:8000/api/';
  final String storageUrl =
      'http://10.0.2.2:8000/storage/'; // Replace with your actual base URL
  final String storagePdfUrl = 'http://10.0.2.2:8000/api/'; // Replace with
  final secureStorage = FlutterSecureStorage();

  // POST
  Future<http.Response> post(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse('$baseurl$endpoint');
    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );
      return response;
    } catch (e) {
      throw Exception('POST Request Failed: $e');
    }
  }

  // POST WITH TOKEN
  Future<http.Response> postWithToken(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    // Buat VAR Token Yang Baca Dari Secure Storage
    final token = await secureStorage.read(key: 'authToken');
    final url = Uri.parse('$baseurl$endpoint');
    try {
      final response = await http.post(
        url,
        headers: {
          // Tambahkan Header Authorization dengan Token
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );
      return response;
    } catch (e) {
      throw Exception('POST Request With Token Failed: $e');
    }
  }

  // PUT
  Future<http.Response> putWithToken(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    final token = await secureStorage.read(key: 'authToken');
    final url = Uri.parse('$baseurl$endpoint');
    try {
      final response = await http.put(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );
      return response;
    } catch (e) {
      throw Exception('PUT Request Failed: $e');
    }
  }

  // DELETE
  Future<http.Response> deleteWithToken(String endpoint) async {
    final token = await secureStorage.read(key: 'authToken');
    final url = Uri.parse('$baseurl$endpoint');
    try {
      final response = await http.delete(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({}), // Body can be empty for DELETE requests
      );
      return response;
    } catch (e) {
      throw Exception('DELETE Request Failed: $e');
    }
  }

  // GET
  Future<http.Response> get(String endpoint) async {
    final token = await secureStorage.read(key: 'authToken');
    final url = Uri.parse('$baseurl$endpoint');
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );
      return response;
    } catch (e) {
      throw Exception('GET Request Failed: $e');
    }
  }

  // MULTIPART POST WITH TOKEN
  Future<http.StreamedResponse> multipartPostWithToken({
    required String endpoint,
    required Map<String, String> fields,
    String? fileFieldName,
    String? filePath,
  }) async {
    final token = await secureStorage.read(key: 'authToken');
    final uri = Uri.parse('$baseurl$endpoint');
    final request = http.MultipartRequest('POST', uri);

    request.headers.addAll({
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    });

    request.fields.addAll(fields);

    // Optional file upload
    if (fileFieldName != null && filePath != null && filePath.isNotEmpty) {
      final file = await http.MultipartFile.fromPath(fileFieldName, filePath);
      request.files.add(file);
    }

    try {
      final response = await request.send();
      return response;
    } catch (e) {
      throw Exception('Multipart POST failed: $e');
    }
  }

  // MULTIPART PUT WITH TOKEN
  Future<http.StreamedResponse> multipartPutWithToken({
    required String endpoint,
    required Map<String, String> fields,
    String? fileFieldName,
    String? filePath,
  }) async {
    final token = await secureStorage.read(key: 'authToken');
    final uri = Uri.parse('$baseurl$endpoint');
    final request = http.MultipartRequest('POST', uri);

    request.headers.addAll({
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    });

    fields['_method'] = 'PUT';

    request.fields.addAll(fields);

    // Optional file upload
    if (fileFieldName != null && filePath != null && filePath.isNotEmpty) {
      final file = await http.MultipartFile.fromPath(fileFieldName, filePath);
      request.files.add(file);
    }

    try {
      final response = await request.send();
      return response;
    } catch (e) {
      throw Exception('Multipart PUT failed: $e');
    }
  }
}
