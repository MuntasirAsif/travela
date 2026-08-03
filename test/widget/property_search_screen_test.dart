import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:travela/core/service/cache/cache_service.dart';
import 'package:travela/core/service/network/sse_parser.dart';
import 'package:travela/main.dart';
import 'package:travela/src/feature/property_search/data/model/location.dart';
import 'package:travela/src/feature/property_search/data/mock/mock_items.dart';
import 'package:travela/src/feature/property_search/data/mock/mock_locations.dart';
import 'package:travela/src/feature/property_search/domain/model/search_filters.dart';
import 'package:travela/src/feature/property_search/domain/provider/property_search_repository_provider.dart';
import 'package:travela/src/feature/property_search/domain/repository/property_search_repository.dart';
import 'package:travela/src/feature/splash/presentation/view/splash_screen.dart';

class _FakeSearchRepository implements PropertySearchRepository {
  @override
  Future<List<Location>> searchLocations(String query) async => const [
    MockLocations.coxsBazar,
  ];

  @override
  Stream<SseFrame> streamSearch(SearchFilters filters) async* {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    yield const SseFrame(event: 'meta', data: '{"total_count": 6}');
    for (final item in MockItems.all) {
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
    expect(find.text('All 6 stays loaded'), findsOneWidget);
    expect(find.text('Sea View Studio'), findsWidgets);

    expect(tester.takeException(), isNull);
  });
}
