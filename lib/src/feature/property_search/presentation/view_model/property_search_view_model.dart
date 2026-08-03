import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../../../core/service/network/sse_parser.dart';
import '../../data/model/meta_event.dart';
import '../../data/model/search_item.dart';
import '../../domain/model/search_filters.dart';
import '../../domain/repository/property_search_repository.dart';
import 'property_search_state.dart';

class PropertySearchViewModel extends StateNotifier<PropertySearchState> {
  PropertySearchViewModel(this._repository)
    : super(const PropertySearchState());

  final PropertySearchRepository _repository;
  StreamSubscription<SseFrame>? _subscription;
  SearchFilters? _lastFilters;
  int _searchId = 0;

  void startSearch(SearchFilters filters) {
    final id = ++_searchId;
    _subscription?.cancel();
    _lastFilters = filters;
    state = const PropertySearchState(status: PropertySearchStatus.loading);

    _subscription = _repository
        .streamSearch(filters)
        .listen(
          (frame) => _handleFrame(id, frame),
          onError: (Object error) {
            if (id != _searchId) return;
            if (error is DioException &&
                error.type == DioExceptionType.cancel) {
              return;
            }
            state = state.copyWith(
              status: PropertySearchStatus.error,
              errorMessage: error is DioException
                  ? error.message
                  : error.toString(),
            );
          },
        );
  }

  void _handleFrame(int id, SseFrame frame) {
    if (id != _searchId) return;
    switch (frame.event) {
      case 'meta':
        final meta = _decode<MetaEvent>(frame.data, MetaEvent.fromJson);
        state = state.copyWith(
          status: PropertySearchStatus.streaming,
          totalCount: meta?.totalCount ?? state.totalCount,
        );
        break;
      case 'item':
        final item = _decode<SearchItem>(frame.data, SearchItem.fromJson);
        if (item == null) return;
        state = state.copyWith(
          status: PropertySearchStatus.streaming,
          items: [...state.items, item],
        );
        break;
      case 'done':
        state = state.copyWith(status: PropertySearchStatus.done);
        break;
      case 'error':
        state = state.copyWith(
          status: PropertySearchStatus.error,
          errorMessage: _errorMessage(frame.data),
        );
        break;
    }
  }

  T? _decode<T>(String raw, T Function(Map<String, dynamic>) fromJson) {
    try {
      final decoded = jsonDecode(raw);
      return decoded is Map<String, dynamic> ? fromJson(decoded) : null;
    } catch (_) {
      return null;
    }
  }

  String _errorMessage(String raw) {
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) {
        final message = decoded['message'] ?? decoded['detail'];
        if (message is String && message.isNotEmpty) return message;
      }
    } catch (_) {}
    return raw.isEmpty ? 'Something went wrong' : raw;
  }

  void retry() {
    final filters = _lastFilters;
    if (filters != null) startSearch(filters);
  }

  @override
  void dispose() {
    _searchId++;
    _subscription?.cancel();
    super.dispose();
  }
}
