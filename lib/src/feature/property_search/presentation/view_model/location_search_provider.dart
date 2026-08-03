import 'package:flutter_riverpod/legacy.dart';

import '../../domain/provider/property_search_repository_provider.dart';
import 'location_search_state.dart';
import 'location_search_view_model.dart';

final locationSearchViewModelProvider =
    StateNotifierProvider.autoDispose<
      LocationSearchViewModel,
      LocationSearchState
    >((ref) {
      final repository = ref.watch(propertySearchRepositoryProvider);
      return LocationSearchViewModel(lookup: repository.searchLocations);
    });
