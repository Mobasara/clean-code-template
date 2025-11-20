import 'package:auto_route/auto_route.dart';

import 'app_guard.dart';
import 'app_route.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen,Route')  // or 'Page,Route' if you use @RoutePage()
class AppRouter extends RootStackRouter {

  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: SplashRoute.page, initial: true),
    AutoRoute(page: OnBoardRoute.page),
    AutoRoute(page: LoginRoute.page),
    AutoRoute(
      page: HomeRoute.page,
      guards: [AppGuard()],
    ),
  ];
}
