import 'package:flutter_riverpod/legacy.dart';

import '../../data/mock/property_search_mock.dart';
import 'location_search_state.dart';
import 'location_search_view_model.dart';

final locationSearchViewModelProvider =
    StateNotifierProvider.autoDispose<
      LocationSearchViewModel,
      LocationSearchState
    >(
      (ref) => LocationSearchViewModel(
        lookup: PropertySearchMock.searchLocations,
        initialSelected: PropertySearchMock.primaryLocation,
      ),
    );
