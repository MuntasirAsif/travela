import '../../data/model/location.dart';

class LocationSearchState {
  final String query;
  final List<Location> suggestions;
  final bool isLoading;
  final Location? selected;

  const LocationSearchState({
    this.query = '',
    this.suggestions = const [],
    this.isLoading = false,
    this.selected,
  });

  LocationSearchState copyWith({
    String? query,
    List<Location>? suggestions,
    bool? isLoading,
    Location? selected,
  }) {
    return LocationSearchState(
      query: query ?? this.query,
      suggestions: suggestions ?? this.suggestions,
      isLoading: isLoading ?? this.isLoading,
      selected: selected ?? this.selected,
    );
  }
}
