part 'app_route.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter{
  @override
  RouteType get defaultRouteType = RouteType.material(), // .cupertino
  
  @override
  List<AutoRoute> get routes => [
    AutoRoute(SplashRoute.page),
  ];

  @override
  List<AutoRouteGuard> get guards => [];
}