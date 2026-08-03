import 'package:flutter_riverpod/legacy.dart';

import 'search_filters.dart';

final searchFiltersProvider = StateProvider.autoDispose<SearchFilters>(
  (ref) => const SearchFilters(),
);
