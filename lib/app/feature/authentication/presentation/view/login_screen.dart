import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/failures.dart';
import '../riverpod/auth_provider.dart';

part '../widget/login_form.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: authState.when(
        data: (result) => result.fold(
          (failure) => Center(child: Text(_mapFailure(failure))),
          (user) => user != null
              ? Center(child: Text('Welcome, ${user.name}!'))
              : _LoginForm(emailCtrl: _emailCtrl, passCtrl: _passCtrl),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  String _mapFailure(Failure failure) {
    if (failure is ServerFailure) return 'Server failure';
    if (failure is CacheFailure) return 'Cache failure';
    return 'Unexpected error';
  }
}
