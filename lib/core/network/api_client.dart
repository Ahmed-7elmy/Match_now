import 'package:dio/dio.dart';

import '../config/env.dart';
import '../constants/api_constants.dart';
import 'interceptors/api_interceptor.dart';

class ApiClient {
  ApiClient()
    : dio = Dio(
        BaseOptions(
          baseUrl: Env.footballApiBaseUrl,
          connectTimeout: ApiConstants.connectTimeout,
          receiveTimeout: ApiConstants.receiveTimeout,
        ),
      )..interceptors.add(ApiInterceptor());

  final Dio dio;
}
