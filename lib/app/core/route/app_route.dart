import 'package:auto_route/auto_route.dart';

import '../data/data.dart';
import 'app_route.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: SplashRoute.page, initial: true),
    AutoRoute(page: OnboardingRoute.page),
    AutoRoute(page: LoginRoute.page),
    AutoRoute(
      page: HomeRoute.page,
      guards: [AppGuard()],
    ),
  ];

  @override
  List<AutoRouteGuard> get guards => [];
}
