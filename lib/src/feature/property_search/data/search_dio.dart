import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../../../core/service/network/endpoints.dart';

final searchDioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: Endpoints.searchBase,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: null,
      headers: {'Accept': 'text/event-stream'},
    ),
  );
  if (kDebugMode) {
    dio.interceptors.add(
      PrettyDioLogger(requestBody: true, responseBody: true),
    );
  }
  return dio;
});
