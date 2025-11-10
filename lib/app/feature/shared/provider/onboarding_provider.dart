import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/data/local/local_data.dart';

part 'onboarding_provider.g.dart';

@riverpod
Future<bool> onboardingComplete(Ref ref) async {
  final local = ref.watch(localDataProvider);
  return local.getOnboardingComplete();
}
