import 'package:auto_route/annotations.dart';
import 'package:clean_code_template/app/core/utils/context.dart';
import 'package:clean_code_template/app/feature/authentication/presentation/view/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../riverpod/splash_provider.dart';

@RoutePage()
class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSplashActive = ref.watch(splashProvider);

    ref.listen<bool>(splashProvider, (previous, next) {
      if (previous == true && next == false) {
        context.pushReplacement(LoginScreen());
      }
    });

    return Scaffold(
      body: AnimatedOpacity(
        duration: const Duration(milliseconds: 800),
        opacity: isSplashActive ? 1.0 : 0.0,
        child: Container(
          alignment: Alignment.center,
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedScale(
                scale: isSplashActive ? 1.0 : 0.8,
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeInOut,
                child: FlutterLogo(size: 32),
              ),
              const SizedBox(height: 20),
              const Text(
                'My Flutter Temples',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
