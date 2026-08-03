import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repository/property_search_repository_impl.dart';
import '../../data/search_dio.dart';
import '../repository/property_search_repository.dart';

final propertySearchRepositoryProvider = Provider<PropertySearchRepository>(
  (ref) => PropertySearchRepositoryImpl(ref.watch(searchDioProvider)),
);
