import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kitlocker/core/auth/auth_state.dart';
import 'package:kitlocker/core/auth/auth_state_provider.dart';
import 'package:kitlocker/core/auth/username_validator.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  final _signupEmailController = TextEditingController();
  final _signupPasswordController = TextEditingController();
  final _signupUsernameController = TextEditingController();
  final _signupFormKey = GlobalKey<FormState>();

  final _signinEmailController = TextEditingController();
  final _signinPasswordController = TextEditingController();
  final _signinFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _signupEmailController.dispose();
    _signupPasswordController.dispose();
    _signupUsernameController.dispose();
    _signinEmailController.dispose();
    _signinPasswordController.dispose();
    super.dispose();
  }

  void _submitSignup() {
    if (_signupFormKey.currentState!.validate()) {
      ref.read(authStateProvider.notifier).register(
            email: _signupEmailController.text.trim(),
            password: _signupPasswordController.text,
            username: _signupUsernameController.text.trim(),
          );
    }
  }

  void _submitSignin() {
    if (_signinFormKey.currentState!.validate()) {
      ref.read(authStateProvider.notifier).signIn(
            email: _signinEmailController.text.trim(),
            password: _signinPasswordController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final isLoading = authState is AuthLoading;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TabBar(
              controller: _tabController,
              tabs: const [
                Tab(key: Key('signup_tab'), text: 'Kayıt Ol'),
                Tab(key: Key('signin_tab'), text: 'Giriş Yap'),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _SignupForm(
                    formKey: _signupFormKey,
                    emailController: _signupEmailController,
                    passwordController: _signupPasswordController,
                    usernameController: _signupUsernameController,
                    isLoading: isLoading,
                    onSubmit: _submitSignup,
                    authError: authState is AuthError ? authState.message : null,
                  ),
                  _SigninForm(
                    formKey: _signinFormKey,
                    emailController: _signinEmailController,
                    passwordController: _signinPasswordController,
                    isLoading: isLoading,
                    onSubmit: _submitSignin,
                    authError: authState is AuthError ? authState.message : null,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SignupForm extends StatelessWidget {
  const _SignupForm({
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.usernameController,
    required this.isLoading,
    required this.onSubmit,
    required this.authError,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController usernameController;
  final bool isLoading;
  final VoidCallback onSubmit;
  final String? authError;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 24),
            TextFormField(
              key: const Key('signup_email_field'),
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: 'E-posta'),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'E-posta gerekli' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              key: const Key('signup_password_field'),
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Şifre'),
              validator: (v) =>
                  (v == null || v.length < 6) ? 'En az 6 karakter gerekli' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              key: const Key('signup_username_field'),
              controller: usernameController,
              decoration: const InputDecoration(labelText: 'Kullanıcı adı'),
              validator: (v) => UsernameValidator.validate(v ?? ''),
            ),
            if (authError != null) ...[
              const SizedBox(height: 12),
              Text(authError!, style: const TextStyle(color: Colors.red)),
            ],
            const SizedBox(height: 24),
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    key: const Key('signup_submit_button'),
                    onPressed: onSubmit,
                    child: const Text('Kayıt Ol'),
                  ),
          ],
        ),
      ),
    );
  }
}

class _SigninForm extends StatelessWidget {
  const _SigninForm({
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.isLoading,
    required this.onSubmit,
    required this.authError,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isLoading;
  final VoidCallback onSubmit;
  final String? authError;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 24),
            TextFormField(
              key: const Key('signin_email_field'),
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: 'E-posta'),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'E-posta gerekli' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              key: const Key('signin_password_field'),
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Şifre'),
              validator: (v) =>
                  (v == null || v.isEmpty) ? 'Şifre gerekli' : null,
            ),
            if (authError != null) ...[
              const SizedBox(height: 12),
              Text(authError!, style: const TextStyle(color: Colors.red)),
            ],
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                key: const Key('forgot_password_button'),
                onPressed: () {},
                child: const Text('Şifremi unuttum'),
              ),
            ),
            const SizedBox(height: 16),
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    key: const Key('signin_submit_button'),
                    onPressed: onSubmit,
                    child: const Text('Giriş Yap'),
                  ),
          ],
        ),
      ),
    );
  }
}
