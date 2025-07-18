import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:secure_store/secure_store.dart';

import '../ui/index.dart';
import '../wallet_state/wallet_provider.dart';

const minPasswordLength = 6;

Future<String?> showPasswordModal(BuildContext context) async {
  return showBottomModal<String>(
    isScrollControlled: true,
    useSafeArea: true,
    context: context,
    builder: (context) => const ModalLayout(child: PasswordScreen()),
  );
}

class CreatePasswordScreen extends HookConsumerWidget {
  const CreatePasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final password = useState('');
    final isButtonEnabled = password.value.length >= minPasswordLength;

    return Layout2(
      sideMargin: sideMargin,
      children: [
        const SimpleHeader(
          title: 'Create Password',
        ),
        Text(
          "Create a secure numeric password. Use a unique combination of digits to protect your assets.",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        TextInput(
          onChanged: (value) => password.value = value,
          autofocus: true,
          obscureText: true,
          hintText: 'Enter your password',
        ),
        const Spacer(),
        PrimaryButton(
          onPressed: isButtonEnabled
              ? () async {
                  // await createInitialPassword(password.value);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ConfirmPasswordScren(
                        initialPassword: password.value,
                      ),
                    ),
                  );
                }
              : null,
          label: "Continue",
        ),
      ],
    );
  }
}

class ConfirmPasswordScren extends HookConsumerWidget {
  final String? initialPassword;

  const ConfirmPasswordScren({Key? key, this.initialPassword})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final password = useState('');
    final isLoading = useState(false);
    final isButtonEnabled = password.value.length >= minPasswordLength;

    return Layout2(
      sideMargin: sideMargin,
      children: [
        const SimpleHeader(
          title: 'Confirm Password',
        ),
        Text(
          "Confirm your password. Only you can access your funds.",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        TextInput(
          onChanged: (value) => password.value = value,
          obscureText: true,
          autofocus: true,
          hintText: 'Confirm your password',
        ),
        const Spacer(),
        PrimaryButton(
          isLoading: isLoading.value,
          onPressed: isButtonEnabled
              ? () async {
                  if (initialPassword == null) {
                    Navigator.of(context).pop(password.value);
                  }
                  if (password.value != initialPassword) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Passwords don't match"),
                      ),
                    );
                    return;
                  }
                  isLoading.value = true;
                  await ref.read(walletsProvider.notifier).addWallet(
                        secureStore: PasswordStore(password: password.value),
                        seedPhrase: 'daf',
                      );
                  isLoading.value = false;
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).popUntil((route) => route.isFirst);
                }
              : null,
          label: "Continue",
        ),
      ],
    );
  }
}

class PasswordScreen extends HookConsumerWidget {
  final void Function(String password)? callback;
  const PasswordScreen({Key? key, this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final password = useState('');
    final isButtonEnabled = password.value.length >= minPasswordLength;
    final onPressed =
        callback ?? (password) => Navigator.of(context).pop(password);

    return Column(
      children: [
        const ModalHeader(title: "Enter your password"),
        const SizedBox(height: sideMargin),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: sideMargin),
          child: TextInput(
            hintText: 'Your password',
            onChanged: (value) => password.value = value,
            autofocus: true,
            obscureText: true,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        const SizedBox(height: sideMargin),
        const Spacer(),
        const SizedBox(height: sideMargin),
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: sideMargin, vertical: sideMargin * 1.5),
          child: PrimaryButton(
            onPressed: isButtonEnabled
                ? () async {
                    onPressed(password.value);
                  }
                : null,
            label: "Continue",
          ),
        ),
      ],
    );
  }
}
