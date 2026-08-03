# AGENTS.md

Flutter app (Dart 3.12, Flutter 3.44 stable) using Clean Architecture, Riverpod 3, go_router, Retrofit+Dio, ScreenUtil.

## Read this first

- `rules.txt` (repo root) is the authoritative conventions doc. It specifies the full feature-file checklist, API call flow, theme system, and mandatory rules. Follow it; summarize only the essentials here.

## Commands

- Codegen after ANY change to `rest_client.dart`, models with `@JsonSerializable`, or endpoint defs:
  `dart run build_runner build --delete-conflicting-outputs`
- Format every edited file: `dart format .`
- Analyze: `flutter analyze`
- Verify file-size rule: `find lib/ -name "*.dart" -exec wc -l {} + | sort -nr | head -20`

## Structure

- `lib/core/` = shared infra (routes, service/network, service/cache, static/theme, const, gen). NOT feature-specific.
- `lib/src/feature/<feature>/` = `data/` (models `@JsonSerializable` + repo impls), `domain/` (abstract repo interfaces + Riverpod providers), `presentation/` (view_model/ StateNotifier + view/ screens).
- `lib/src/widgets/` = shared reusable widgets.
- Dependency flow is inward only: view → view_model → domain repo interface ← data impl ← core service. Views NEVER import `data/`; features never import other features.

## Mandatory rules that differ from defaults

- Riverpod only — never `setState()`. Widgets needing state are `ConsumerWidget`/`ConsumerStatefulWidget`.
- Max 150 lines per file in `src/feature/`. Split into `<feature>_part/` or `_widgets/` subfolders; shared widgets go to `src/widgets/`.
- `ViewModels` extend `StateNotifier<AsyncValue<void>>`; use `AsyncValue.guard()`. Screens call `ref.read(provider.notifier)` and watch with `ref.watch`.
- Snake_case files, PascalCase classes, providers suffixed `...Provider`.
- ScreenUtil design size is 375×812 (set in `main.dart`): use `.w/.h/.sp/.r`, never fixed pixels.

## Generated files — never edit by hand

`*.g.dart` (retrofit `rest_client.g.dart`, json models), `assets.gen.dart` (FlutterGen). `assets.gen.dart` references assets (icons/images) but `pubspec.yaml` currently has NO `assets:` section and no flutter_gen config — adding assets requires wiring that up first.

## Network

- Base URL is a local dev server: `http://10.10.10.3:5000/api` (`core/service/network/endpoints.dart`). Not reachable from emulators without host config.
- Add endpoints to `endpoints.dart`, Retrofit methods to `rest_client.dart`, call through the `Api.call()` wrapper (`api_handler.dart`) from ViewModels, return `Future<HttpResponse<T>>` (unwrap with `.data`).
- `TokenManager` interceptor globally handles 401 + token refresh + redirect to login. Don't duplicate refresh logic.

## Cache / DI gotchas

- All cache keys live in the `CacheKey` enum in `core/service/cache/cache_service.dart`; add new keys there. `shared_preference_service.dart` is a `part` of `cache_service.dart`.
- `sharedPreferencesProvider` throws `UnimplementedError` unless overridden. `main.dart` overrides it via `ProviderScope(overrides: ...)`. Tests must do the same (or `SharedPreferences.setMockInitialValues`).

## Theme

- Access via `context.color.*`, `context.textStyle.*`, `context.spacing/padding/margin/radius.*`. New theme extensions must be registered in `theme_data.dart` `extensions:` list or the app throws in debug.

## Routing

- Paths in `core/routes/route_const.dart`, screen imports in `core/routes/part_of.dart`, GoRoutes in `route_config.dart`. Bottom nav uses `StatefulShellRoute.indexedStack` and needs `GlobalObjectKey` per branch. Use `context.go()` for bottom-nav, `context.push()` for stack navigation.

## Testing

- Only `test/widget_test.dart` exists — it is the stale default counter smoke test and does not match the current `MyApp` router; do not treat it as a meaningful baseline. rules.txt prescribes `test/unit/` + `test/widget/` mirroring `lib/` with `_test.dart` suffix; nothing exists there yet.
