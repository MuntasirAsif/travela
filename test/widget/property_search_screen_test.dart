import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:travela/core/service/cache/cache_service.dart';
import 'package:travela/main.dart';
import 'package:travela/src/feature/splash/presentation/view/splash_screen.dart';

void main() {
  testWidgets('boots splash -> search and streams mock results without errors', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
        child: const MyApp(),
      ),
    );

    expect(find.byType(SplashScreen), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 900));
    await tester.pump();
    await tester.pump();

    expect(find.text('Search stays'), findsOneWidget);
    expect(find.text('Opening results…'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump();
    expect(find.text('Sea View Studio'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 3200));
    await tester.pump();
    expect(find.text('All 6 stays loaded'), findsOneWidget);
    expect(find.text('Sea View Studio'), findsWidgets);

    expect(tester.takeException(), isNull);
  });
}
