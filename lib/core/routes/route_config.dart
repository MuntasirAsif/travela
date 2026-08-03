part of 'part_of.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final navigatorKey = ref.watch(navigatorKeyProvider);

  return GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: RouteConst.splash,
    routes: <RouteBase>[
      GoRoute(
        path: RouteConst.splash,
        pageBuilder: (context, state) => buildTransitionPage(
          child: const SplashScreen(),
          key: state.pageKey,
          type: AppTransitionType.fade,
        ),
      ),
      GoRoute(
        path: RouteConst.search,
        pageBuilder: (context, state) => buildTransitionPage(
          child: const PropertySearchScreen(),
          key: state.pageKey,
          type: AppTransitionType.fade,
        ),
      ),
    ],
  );
});
