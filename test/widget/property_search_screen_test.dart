import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:travela/core/service/cache/cache_service.dart';
import 'package:travela/core/service/network/sse_parser.dart';
import 'package:travela/main.dart';
import 'package:travela/src/feature/property_search/data/model/location.dart';
import 'package:travela/src/feature/property_search/data/model/search_item.dart';
import 'package:travela/src/feature/property_search/domain/model/search_filters.dart';
import 'package:travela/src/feature/property_search/domain/provider/property_search_repository_provider.dart';
import 'package:travela/src/feature/property_search/domain/repository/property_search_repository.dart';
import 'package:travela/src/feature/property_search/presentation/view_model/property_search_provider.dart';
import 'package:travela/src/feature/property_search/presentation/view_model/property_search_state.dart';
import 'package:travela/src/feature/splash/presentation/view/splash_screen.dart';

const _coxsBazar = Location(
  id: 42,
  name: "Cox's Bazar",
  order: 1,
  lat: 21.4272,
  lng: 92.0058,
  within: 15.0,
  tier1: 5.0,
  tier2: 10.0,
);

const _testItems = <SearchItem>[
  SearchItem(
    id: 501,
    title: 'Sea View Studio',
    address: "Kolatoli, Cox's Bazar",
    price: 3200,
    offerPrice: 2800,
    reviewsAvg: 4.7,
    reviewsCount: 38,
    bedroom: 1,
    beds: 2,
    bathroom: 1,
    maxGuest: 3,
  ),
  SearchItem(
    id: 502,
    title: 'Beachfront Resort & Spa',
    address: "Sugandha Beach, Cox's Bazar",
    price: 9500,
    reviewsAvg: 4.9,
    reviewsCount: 124,
    isHotel: true,
    bedroom: 2,
    beds: 3,
    bathroom: 2,
    maxGuest: 5,
  ),
  SearchItem(
    id: 503,
    title: 'Cozy Family Cottage',
    address: "Himchari, Cox's Bazar",
    price: 1800,
    offerPrice: 1500,
    bedroom: 2,
    beds: 2,
    bathroom: 1,
    maxGuest: 4,
  ),
  SearchItem(
    id: 504,
    title: 'Lagoon View Villa',
    address: 'Inani Beach Road',
    price: 6800,
    reviewsAvg: 4.5,
    reviewsCount: 21,
    bedroom: 3,
    beds: 4,
    bathroom: 2,
    maxGuest: 6,
  ),
  SearchItem(
    id: 505,
    title: 'Sunset Guest House',
    address: 'Laboni Point',
    price: 1400,
    reviewsAvg: 4.2,
    reviewsCount: 57,
    isHotel: true,
    bedroom: 1,
    beds: 1,
    bathroom: 1,
    maxGuest: 2,
  ),
  SearchItem(
    id: 506,
    title: 'Ocean Breeze Apartment',
    address: 'Marine Drive Road',
    price: 4200,
    offerPrice: 3900,
    reviewsAvg: 4.6,
    reviewsCount: 45,
    bedroom: 2,
    beds: 2,
    bathroom: 2,
    maxGuest: 4,
  ),
];

class _FakeSearchRepository implements PropertySearchRepository {
  @override
  Future<List<Location>> searchLocations(String query) async => const [
    _coxsBazar,
  ];

  @override
  Stream<SseFrame> streamSearch(SearchFilters filters) async* {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    yield const SseFrame(event: 'meta', data: '{"total_count": 6}');
    for (final item in _testItems) {
      await Future<void>.delayed(const Duration(milliseconds: 100));
      yield SseFrame(event: 'item', data: jsonEncode(item.toJson()));
    }
    yield const SseFrame(event: 'done', data: '{}');
  }
}

void main() {
  testWidgets('boots splash -> search and streams results without errors', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          propertySearchRepositoryProvider.overrideWithValue(
            _FakeSearchRepository(),
          ),
        ],
        child: const MyApp(),
      ),
    );

    await tester.pump();

    expect(find.byType(SplashScreen), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 900));
    await tester.pump();
    await tester.pump();

    expect(find.text('Search stays'), findsOneWidget);
    expect(find.text('Opening results…'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 150));
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('Sea View Studio'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 600));
    expect(find.text('6 stays'), findsOneWidget);
    expect(find.text('Sea View Studio'), findsWidgets);

    expect(tester.takeException(), isNull);
  });

  testWidgets('loads the next page when scrolled to the bottom', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          propertySearchRepositoryProvider.overrideWithValue(
            _PaginatedSearchRepository(),
          ),
        ],
        child: const MyApp(),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 900));
    await tester.pump();
    await tester.pump();

    for (var i = 0; i < 40; i++) {
      await tester.pump(const Duration(milliseconds: 20));
    }

    final container = ProviderScope.containerOf(
      tester.element(find.byType(MyApp)),
    );
    var state = container.read(propertySearchViewModelProvider);
    expect(state.status, PropertySearchStatus.done);
    expect(state.items.length, 20);
    expect(state.hasMore, isTrue);

    await tester.drag(
      find.byType(ListView),
      const Offset(0, -5000),
      warnIfMissed: false,
    );
    await tester.pump();

    for (var i = 0; i < 60; i++) {
      await tester.pump(const Duration(milliseconds: 20));
    }

    state = container.read(propertySearchViewModelProvider);
    expect(state.items.length, 30);
    expect(state.hasMore, isFalse);
    expect(state.status, PropertySearchStatus.done);
    expect(tester.takeException(), isNull);
  });
}

class _PaginatedSearchRepository implements PropertySearchRepository {
  @override
  Future<List<Location>> searchLocations(String query) async => const [
    _coxsBazar,
  ];

  @override
  Stream<SseFrame> streamSearch(SearchFilters filters) async* {
    const perPage = 20;
    final isLastPage = filters.page == 2;
    final start = (filters.page - 1) * perPage + 1;
    final end = isLastPage ? 30 : perPage;
    await Future<void>.delayed(const Duration(milliseconds: 10));
    yield SseFrame(
      event: 'meta',
      data: jsonEncode({
        'total_count': 30,
        'pagination': {
          'page': filters.page,
          'limit': perPage,
          'total_count': 30,
          'next': isLastPage ? null : 2,
          'total_page': 2,
        },
      }),
    );
    for (var i = start; i <= end; i++) {
      await Future<void>.delayed(const Duration(milliseconds: 10));
      yield SseFrame(
        event: 'item',
        data: jsonEncode({
          'id': i,
          'title': 'Stay $i',
          'address': 'Address $i',
          'price': 1000 + i,
        }),
      );
    }
    yield const SseFrame(event: 'done', data: '{}');
  }
}
