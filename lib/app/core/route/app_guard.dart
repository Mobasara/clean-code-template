import 'package:auto_route/auto_route.dart';

import '../data/data.dart';

class AppGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final localData = getIt<LocalData>();

    final hasCompletedOnboarding = localData.getOnboardingComplete();
    final isLoggedIn = localData.getLoginStatus();

    if (!hasCompletedOnboarding) {
      resolver.redirectUntil(OnboardingRoute(), replace: true);
      return;
    }

    if (!isLoggedIn) {
      resolver.redirectUntil(LoginRoute(), replace: true);
      return;
    }

    resolver.next(true);
  }
}
