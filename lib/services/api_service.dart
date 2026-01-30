import 'package:dio/dio.dart';

class ApiService {
  ApiService({Dio? client})
    : _client =
          client ??
          Dio(BaseOptions(connectTimeout: const Duration(seconds: 10)));

  final Dio _client;

  Future<Response<dynamic>> get(String path, {Map<String, dynamic>? query}) {
    return _client.get(path, queryParameters: query);
  }

  Future<Response<dynamic>> post(String path, {Object? data}) {
    return _client.post(path, data: data);
  }
}

