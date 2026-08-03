import 'dart:async';

import 'package:flutter_riverpod/legacy.dart';

import '../../data/mock/property_search_mock.dart';
import 'property_search_state.dart';
import 'search_filters.dart';

class PropertySearchViewModel extends StateNotifier<PropertySearchState> {
  PropertySearchViewModel() : super(const PropertySearchState());

  StreamSubscription<void>? _subscription;
  SearchFilters? _lastFilters;

  void startMockSearch(SearchFilters filters) {
    _subscription?.cancel();
    _lastFilters = filters;
    final items = PropertySearchMock.items;
    state = PropertySearchState(
      status: PropertySearchStatus.loading,
      totalCount: items.length,
    );

    var index = 0;
    _subscription = Stream<void>.periodic(const Duration(milliseconds: 450))
        .take(items.length + 1)
        .listen((_) {
          if (index >= items.length) {
            state = state.copyWith(status: PropertySearchStatus.done);
            return;
          }
          final next = items[index++];
          state = state.copyWith(
            status: PropertySearchStatus.streaming,
            items: [...state.items, next],
          );
        });
  }

  void retry() {
    final filters = _lastFilters;
    if (filters != null) startMockSearch(filters);
  }

  void simulateError(String message) {
    _subscription?.cancel();
    state = state.copyWith(
      status: PropertySearchStatus.error,
      errorMessage: message,
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
