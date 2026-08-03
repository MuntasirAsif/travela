import 'package:dio/dio.dart';

import '../../../../../core/service/network/endpoints.dart';
import '../../../../../core/service/network/sse_parser.dart';
import '../../domain/model/search_filters.dart';
import '../../domain/repository/property_search_repository.dart';
import '../model/location.dart';

class PropertySearchRepositoryImpl implements PropertySearchRepository {
  PropertySearchRepositoryImpl(this._dio);

  final Dio _dio;

  @override
  Future<List<Location>> searchLocations(String query) async {
    final response = await _dio.get(
      Endpoints.popularLocations,
      queryParameters: {'q': query},
    );
    final payload = response.data as Map<String, dynamic>;
    final data = payload['data'] as List<dynamic>;
    return data
        .map((item) => Location.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  @override
  Stream<SseFrame> streamSearch(SearchFilters filters) async* {
    final cancelToken = CancelToken();
    try {
      final response = await _dio.get(
        Endpoints.searchStream,
        queryParameters: filters.toQueryParameters(),
        options: Options(responseType: ResponseType.stream),
        cancelToken: cancelToken,
      );
      final body = response.data as ResponseBody;
      yield* parseSseStream(body.stream);
    } on DioException {
      if (!cancelToken.isCancelled) rethrow;
    } finally {
      if (!cancelToken.isCancelled) cancelToken.cancel();
    }
  }
}
