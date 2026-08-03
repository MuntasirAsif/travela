import '../../data/model/search_item.dart';

enum PropertySearchStatus { idle, loading, streaming, done, error }

class PropertySearchState {
  final PropertySearchStatus status;
  final List<SearchItem> items;
  final int totalCount;
  final String? errorMessage;

  const PropertySearchState({
    this.status = PropertySearchStatus.idle,
    this.items = const [],
    this.totalCount = 0,
    this.errorMessage,
  });

  bool get isStreaming => status == PropertySearchStatus.streaming;
  bool get isDone => status == PropertySearchStatus.done;

  PropertySearchState copyWith({
    PropertySearchStatus? status,
    List<SearchItem>? items,
    int? totalCount,
    String? errorMessage,
  }) {
    return PropertySearchState(
      status: status ?? this.status,
      items: items ?? this.items,
      totalCount: totalCount ?? this.totalCount,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
