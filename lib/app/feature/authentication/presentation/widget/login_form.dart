part of '../view/login_screen.dart';

class _LoginForm extends ConsumerWidget {
  const _LoginForm({required this.emailCtrl, required this.passCtrl});

  final TextEditingController emailCtrl;
  final TextEditingController passCtrl;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: emailCtrl,
            decoration: const InputDecoration(labelText: 'Email'),
          ),
          TextField(
            controller: passCtrl,
            decoration: const InputDecoration(labelText: 'Password'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              await ref
                  .read(authProvider.notifier)
                  .login(emailCtrl.text.trim(), passCtrl.text.trim());
            },
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }
}
