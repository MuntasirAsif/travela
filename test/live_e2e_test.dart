import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:travela/core/service/cache/cache_service.dart';
import 'package:travela/core/service/network/sse_parser.dart';
import 'package:travela/main.dart';
import 'package:travela/src/feature/property_search/data/model/location.dart';
import 'package:travela/src/feature/property_search/data/repository/property_search_repository_impl.dart';
import 'package:travela/src/feature/property_search/domain/model/search_filters.dart';
import 'package:travela/src/feature/property_search/domain/provider/property_search_repository_provider.dart';
import 'package:travela/src/feature/property_search/domain/repository/property_search_repository.dart';
import 'package:travela/src/feature/property_search/presentation/view/widgets/search_result_card.dart';
import 'package:travela/src/feature/splash/presentation/view/splash_screen.dart';

class _LiveRepository implements PropertySearchRepository {
  final _inner = PropertySearchRepositoryImpl(
    Dio(
      BaseOptions(
        baseUrl: 'https://search.travela.xyz/api',
        receiveTimeout: null,
      ),
    ),
  );

  @override
  Future<List<Location>> searchLocations(String query) =>
      _inner.searchLocations(query);

  @override
  Stream<SseFrame> streamSearch(SearchFilters filters) =>
      _inner.streamSearch(filters);
}

void main() {
  testWidgets('live api end-to-end renders cards', (tester) async {
    HttpOverrides.global = null;

    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          propertySearchRepositoryProvider.overrideWithValue(
            _LiveRepository(),
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

    await tester.runAsync(
      () => Future<void>.delayed(const Duration(seconds: 10)),
    );
    await tester.pump();

    final cards = find.byType(SearchResultCard).evaluate().length;
    debugPrint('LIVE E2E: cards rendered = $cards');
    expect(cards, greaterThan(0));
    expect(tester.takeException(), isNull);
  }, timeout: const Timeout(Duration(minutes: 2)));
}
