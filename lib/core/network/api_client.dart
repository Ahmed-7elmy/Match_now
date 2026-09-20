import 'package:dio/dio.dart';

import '../config/app_config.dart';
import '../constants/api_constants.dart';
import 'interceptors/api_interceptor.dart';

class ApiClient {
  ApiClient({Dio? dio}) {
    _dio =
        dio ??
        Dio(
          BaseOptions(
            baseUrl: AppConfig.apiBaseUrl, //elly fe constants
            connectTimeout: ApiConstants.connectTimeout,
            receiveTimeout: ApiConstants.receiveTimeout,
            sendTimeout: ApiConstants.sendTimeout,
            responseType: ResponseType.json,
            headers: {'Accept': 'application/json'},
          ),
        );

    _dio.interceptors.add(ApiInterceptor());
  }

  late final Dio _dio;

  Future<Response<dynamic>> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
  }) async {
    return _dio.get(endpoint, queryParameters: queryParameters);
  }
}
