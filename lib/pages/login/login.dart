import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:basecam/app_path.dart';
import 'package:basecam/ui/theme.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              Text(
                "Login here",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                "Create an account so you can explore features",
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 44),

              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  hintText: "Email",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: "Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Forgot password
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // TODO: Forgot password
                  },
                  child: Text(
                    "Forgot your password?",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              FilledButton(onPressed: onSignIn, child: const Text("Sign in")),
              const SizedBox(height: 16),

              TextButton(
                onPressed: () => context.replace(AppPath.registration.path),
                child: Text(
                  "Create new account",
                  textAlign: TextAlign.center,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 32),

              Text(
                "Or continue with",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _socialButton(
                    SvgPicture.asset(
                      'assets/icons/google.svg',
                      width: 24,
                      height: 24,
                    ),
                    onGoogle,
                  ),
                  const SizedBox(width: 16),
                  _socialButton(
                    SvgPicture.asset(
                      'assets/icons/facebook.svg',
                      width: 24,
                      height: 24,
                    ),
                    onFacebook,
                  ),
                  const SizedBox(width: 16),
                  _socialButton(
                    SvgPicture.asset(
                      'assets/icons/apple.svg',
                      width: 24,
                      height: 24,
                    ),
                    onApple,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _socialButton(Widget child, VoidCallback onTap) {
    return Material(
      color: ThemeColors.grey2Color,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: SizedBox(width: 56, height: 56, child: Center(child: child)),
      ),
    );
  }

  void onSignIn() {
    // TODO: Логіка реєстрації
    context.go(AppPath.root.path);
  }

  void onGoogle() {
    // TODO: Google sign-in
  }

  void onFacebook() {
    // TODO: Facebook sign-in
  }

  void onApple() {
    // TODO: Apple sign-in
  }
}
