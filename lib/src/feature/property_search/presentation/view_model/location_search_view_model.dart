import 'dart:async';

import 'package:flutter_riverpod/legacy.dart';

import '../../data/model/location.dart';
import 'location_search_state.dart';

class LocationSearchViewModel extends StateNotifier<LocationSearchState> {
  LocationSearchViewModel({
    required Future<List<Location>> Function(String query) lookup,
    Location? initialSelected,
  }) : _locationLookup = lookup,
       super(
         LocationSearchState(
           query: initialSelected?.name ?? '',
           selected: initialSelected,
         ),
       );

  final Future<List<Location>> Function(String query) _locationLookup;
  Timer? _debounce;
  bool _disposed = false;

  void onQueryChanged(String query) {
    _debounce?.cancel();
    if (query.trim().isEmpty) {
      state = state.copyWith(
        query: query,
        suggestions: const [],
        isLoading: false,
      );
      return;
    }
    state = state.copyWith(query: query, isLoading: true);
    _debounce = Timer(const Duration(milliseconds: 350), () async {
      final results = await _locationLookup(query);
      if (_disposed || state.query != query) return;
      state = state.copyWith(suggestions: results, isLoading: false);
    });
  }

  void select(Location location) {
    _debounce?.cancel();
    state = state.copyWith(
      query: location.name,
      suggestions: const [],
      isLoading: false,
      selected: location,
    );
  }

  void clearSelection() {
    _debounce?.cancel();
    state = const LocationSearchState();
  }

  void clearSuggestions() {
    _debounce?.cancel();
    state = state.copyWith(suggestions: const [], isLoading: false);
  }

  @override
  void dispose() {
    _disposed = true;
    _debounce?.cancel();
    super.dispose();
  }
}
