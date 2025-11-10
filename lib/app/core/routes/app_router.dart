import 'package:clean_code_template/app/feature/authentication/presentation/view/login_screen.dart';
import 'package:clean_code_template/app/feature/home/presentation/view/home_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../feature/onBoard/presentation/views/on_board_screen.dart';
import '../../feature/shared/provider/onboarding_provider.dart';
import '../../feature/splash/presentation/views/splash_screen.dart';
import 'route_names.dart';

part 'app_router.g.dart';

@riverpod
GoRouter goRouter(Ref ref) {
  final asyncOnboardComplete = ref.watch(onboardingCompleteProvider);

  return GoRouter(
    initialLocation: RouteNames.splash,
    // refreshListenable: GoRouterRefreshStream(
    //   ref.watch(onboardingCompleteProvider.future).asStream(),
    // ),
    redirect: (context, state) {
      if (asyncOnboardComplete.isLoading) return null;

      final onboardComplete = asyncOnboardComplete.value ?? false;
      final isLoggedIn = false;

      if (state.uri.toString() == RouteNames.splash) return null;

      if (!onboardComplete && state.uri.toString() != RouteNames.onboard) {
        return RouteNames.onboard;
      }

      if (onboardComplete &&
          !isLoggedIn &&
          state.uri.toString() != RouteNames.login) {
        return RouteNames.login;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: RouteNames.splash,
        name: RouteNames.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: RouteNames.onboard,
        name: RouteNames.onboard,
        builder: (context, state) => const OnBoardScreen(),
      ),
      GoRoute(
        path: RouteNames.login,
        name: RouteNames.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: RouteNames.home,
        name: RouteNames.home,
        builder: (context, state) => const HomeScreen(),
      ),
    ],
  );
}
