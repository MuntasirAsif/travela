import '../../../../../core/service/network/sse_parser.dart';
import '../../data/model/location.dart';
import '../model/search_filters.dart';

abstract class PropertySearchRepository {
  Future<List<Location>> searchLocations(String query);

  Stream<SseFrame> streamSearch(SearchFilters filters);
}
