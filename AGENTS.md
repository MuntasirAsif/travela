# AGENTS.md

Flutter app (Dart 3.12, Flutter 3.44 stable) using Clean Architecture, Riverpod 3, go_router, Retrofit+Dio, ScreenUtil.

## Read this first

- `rules.txt` (repo root) is the authoritative conventions doc. It specifies the full feature-file checklist, API call flow, theme system, and mandatory rules. Follow it; summarize only the essentials here.
- `flutter-take-home-task.md` (repo root) is the live task spec: a property search screen with debounced autocomplete + SSE streaming results. The active work builds that feature; follow its requirements exactly (README must be written by the user, not AI).

## Commands

- Codegen after ANY change to `rest_client.dart` or models with `@JsonSerializable`:
  `dart run build_runner build` (build_runner 2.15+ removed `--delete-conflicting-outputs`; the flag is ignored if passed)
- Format every edited file: `dart format .`
- Analyze: `flutter analyze`
- Verify file-size rule: `find lib/ -name "*.dart" -exec wc -l {} + | sort -nr | head -20`

## Structure

- `lib/core/` = shared infra (routes, service/network, service/cache, static/theme, const, gen). NOT feature-specific.
- `lib/src/feature/<feature>/` = `data/` (models `@JsonSerializable` + repo impls), `domain/` (abstract repo interfaces + Riverpod providers), `presentation/` (view_model/ StateNotifier + view/ screens).
- `lib/src/widgets/` = shared reusable widgets.
- Dependency flow is inward only: view → view_model → domain repo interface ← data impl ← core service. Views NEVER import `data/`; features never import other features.
- Active features: `splash` (boot screen → `/search`) and `property_search` (the take-home task; currently just a screen shell).

## Mandatory rules that differ from defaults

- Riverpod only — never `setState()`. Widgets needing state are `ConsumerWidget`/`ConsumerStatefulWidget`.
- Max 150 lines per file in `src/feature/`. Split into `<feature>_part/` or `_widgets/` subfolders; shared widgets go to `src/widgets/`.
- `ViewModels` extend `StateNotifier` and are registered with `StateNotifierProvider.autoDispose`; use `AsyncValue.guard()` where applicable. Screens call `ref.read(provider.notifier)` and watch with `ref.watch`.
- Snake_case files, PascalCase classes, providers suffixed `...Provider`.
- ScreenUtil design size is 375×812 (set in `main.dart`): use `.w/.h/.sp/.r`, never fixed pixels.

## Generated files — never edit by hand

`*.g.dart` (retrofit `rest_client.g.dart`, json models), `assets.gen.dart` (FlutterGen). `assets.gen.dart` references `assets/icons/*.svg` that do NOT exist on disk yet — only `assets/images/app_icon.png` is present and wired via pubspec (`assets/images/`). flutter_gen is NOT configured, so `assets.gen.dart` cannot be regenerated; only add assets it already covers.

## Network

Two independent API stacks coexist:

1. **Dev API** (`core/service/network/endpoints.dart` → `Endpoints.base = http://10.10.10.3:5000/api`): Retrofit `rest_client.dart` + `Api.call()` wrapper (`api_handler.dart`) + `dioProvider` with `TokenManager` (global 401/refresh/redirect-to-login). Return `Future<HttpResponse<T>>`, unwrap with `.data`. Don't duplicate refresh logic.
2. **Search API** (`Endpoints.searchBase = https://search.travela.xyz/api`, public, NO auth): used by the take-home task only. SSE streaming does NOT go through Retrofit/`Api.call()` — use a dedicated no-auth dio with `ResponseType.stream` + a per-search `CancelToken`, and read the body as a line-by-line stream. Do not add `TokenManager` to it; disable `receiveTimeout` (idle gaps between SSE events would kill the stream).

## Cache / DI gotchas

- All cache keys live in the `CacheKey` enum in `core/service/cache/cache_service.dart`; add new keys there. `shared_preference_service.dart` is a `part` of `cache_service.dart`.
- `sharedPreferencesProvider` throws `UnimplementedError` unless overridden. `main.dart` overrides it via `ProviderScope(overrides: ...)`. Tests must do the same (or `SharedPreferences.setMockInitialValues`).

## Theme

- Brand/base color is `#E1217E` (defined in `primitive.dart` as `_Primitive.brand` → `primary`, `active`, `info`, `secondary`).
- Access via `context.color.*`, `context.textStyle.*`, `context.spacing/padding/margin/radius.*`. New theme extensions must be registered in `theme_data.dart` `extensions:` list or the app throws in debug.

## Routing

- Paths in `core/routes/route_const.dart` (splash + search are wired; `onBoarding`/`login`/`homeScreen` are stale unused constants — remove when touched), screen imports in `core/routes/part_of.dart`, GoRoutes in `route_config.dart` (`part of part_of.dart`). Boot: splash → `context.go(RouteConst.search)` after 800ms.
- Bottom nav (future) uses `StatefulShellRoute.indexedStack` and needs `GlobalObjectKey` per branch. Use `context.go()` for bottom-nav, `context.push()` for stack navigation.

## Take-home task status (5 sequential parts, one at a time, splash first, then UI before API)

### Part 1 — Foundation & boot (splash + routing) ✅ DONE
- [x] `pubspec.yaml`: add `pretty_dio_logger: ^1.3.1`; run `flutter pub get`.
- [x] `android/app/src/main/AndroidManifest.xml`: add INTERNET permission.
- [x] `dio_client.dart`: swap `LogInterceptor` → `PrettyDioLogger` (logLevel: debug).
- [x] `endpoints.dart`: add `searchBase = 'https://search.travela.xyz/api'`.
- [x] Recreate minimal `SplashScreen` in `lib/src/feature/splash/presentation/view/` (no ViewModel, per rules.txt) — on first frame `context.pushReplacement(RouteConst.search)`.
- [x] `route_const.dart`: add `search = '/search'`.
- [x] Create `lib/src/feature/property_search/` skeleton + minimal `PropertySearchScreen` (Scaffold shell) so routes compile.
- [x] `part_of.dart` + `route_config.dart`: splash → `SplashScreen`, add search `GoRoute`.
- [x] Delete stale `test/widget_test.dart`.
- [x] Verify: `pub get` → `flutter analyze` → app boots to splash → navigates to search shell.

### Part 2 — UI (the screen) ⏳ NEXT (design first, mock data, no network)
- [ ] Define UI-rendering models: `Location`, `SearchItem` (`@JsonSerializable`, needed by the autocomplete field + result card). Run build_runner codegen.
- [ ] `view/widgets/`: location autocomplete field, filter row (date range → `YYYY-MM-DD`, guest stepper, price `RangeSlider` → `min-max`), `SearchResultCard` (`CachedNetworkImage` + placeholder/fallback, title, address, price + struck `offer_price`, reviews, hotel/featured chips), results list.
- [ ] `PropertySearchScreen` renders every state (loading / streaming / done banner / empty / error+retry) with live "N stays" header, backed by **mock streaming data** (canned items with delays, no network).
- [ ] Verify: `dart format .` → `flutter analyze`.

### Part 3 — Data layer (SSE + repository) — the API calls
- [ ] `MetaEvent` model + plain `SseFrame`. Run build_runner codegen.
- [ ] `core/service/network/sse_parser.dart`: pure `Stream<List<int>>` → `Stream<SseFrame>` (event/data frames, blank-line separators, `\r\n`).
- [ ] Abstract `PropertySearchRepository` (domain) + dio impl (data): `searchDioProvider` (searchBase, no TokenManager, PrettyDioLogger, `receiveTimeout` disabled, per-search `CancelToken`); autocomplete `GET /popular-locations?q=`; SSE `GET /search/stream` via `ResponseType.stream`.
- [ ] Domain repository provider.
- [ ] Verify: codegen → `flutter analyze`.

### Part 4 — ViewModels (state)
- [ ] `PropertySearchState` (idle/loading/streaming/done/error + items/totalCount/errorMessage) + `PropertySearchViewModel` (`StateNotifier`, `StateNotifierProvider.autoDispose`, `ref.onDispose` cancel, new search cancels previous via CancelToken + subscription, retry). Swap the Part 2 mock data source for the real repository.
- [ ] `LocationSearchViewModel`: 350ms debounce, suggestions, selected `Location`.
- [ ] Verify: `flutter analyze`.

### Part 5 — Tests & final verification
- [ ] `test/unit/sse_parser_test.dart` (documented parser-testing approach).
- [ ] Final gate: `dart format .` → `flutter analyze` → `flutter test` → manual run note (endpoint is live).
- [ ] Remaining to you: README, git, screen recording.

## Testing

- No tests exist (`test/widget_test.dart` was deleted — it was the stale counter smoke test). rules.txt prescribes `test/unit/` + `test/widget/` mirroring `lib/` with `_test.dart` suffix.
- SSE parser test goes in `test/unit/` and is pure (no network, no Riverpod overrides needed).
