import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:basecam/app_path.dart';
import 'package:basecam/ui/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _loading = false;

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
                  hintText: "Password----",
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
                    _showForgotPasswordDialog();
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

              FilledButton(
                onPressed: _loading ? null : onSignIn,
                child: _loading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text("Sign in"),
              ),
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
                  const SizedBox(width: 10),
                  _socialButton(
                    SvgPicture.asset(
                      'assets/icons/facebook.svg',
                      width: 24,
                      height: 24,
                    ),
                    onFacebook,
                  ),
                  const SizedBox(width: 10),
                  _socialButton(
                    SvgPicture.asset(
                      'assets/icons/apple.svg',
                      width: 24,
                      height: 24,
                    ),
                    onApple,
                  ),
                  const SizedBox(height: 16),
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
        child: SizedBox(width: 60, height: 44, child: Center(child: child)),
      ),
    );
  }

  Future<void> onSignIn() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Enter email and password')));
      return;
    }

    setState(() => _loading = true);
    try {
      final cred = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final uid = cred.user?.uid;
      if (!mounted) return;
      if (uid != null) {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .get();
        if (!doc.exists) {
          // user signed in but no user document — offer to create
          _showUserNotFoundDialog(email);
          return;
        }
      }
      context.go(AppPath.root.path);
    } on FirebaseAuthException catch (e, st) {
      debugPrint('SignIn FirebaseAuthException: $e\n$st');
      if (!mounted) return;
      switch (e.code) {
        case 'user-not-found':
          _showUserNotFoundDialog(email);
          break;
        case 'wrong-password':
          _showWrongPasswordDialog(email);
          break;
        default:
          await showDialog<void>(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text('Login error'),
              content: Text(e.message ?? e.code),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
      }
    } catch (e, st) {
      debugPrint('SignIn unknown error: $e\n$st');
      if (!mounted) return;
      await showDialog<void>(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Login error'),
          content: Text(e.toString()),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _sendPasswordReset(String email) async {
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter email to reset password')),
      );
      return;
    }
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password reset email sent')),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message ?? e.code)));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  void _showForgotPasswordDialog() {
    final controller = TextEditingController(text: _emailController.text);
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset password'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Enter your email'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              _sendPasswordReset(controller.text.trim());
            },
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }

  void _showUserNotFoundDialog(String email) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('User not found'),
        content: const Text(
          'No account found for this email. Would you like to register or reset the password?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.push(AppPath.registration.path);
            },
            child: const Text('Register'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              _sendPasswordReset(email);
            },
            child: const Text('Reset password'),
          ),
        ],
      ),
    );
  }

  void _showWrongPasswordDialog(String email) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Wrong password'),
        content: const Text(
          'The password is incorrect. Would you like to reset it?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              _sendPasswordReset(email);
            },
            child: const Text('Reset password'),
          ),
        ],
      ),
    );
  }

  void onGoogle() {
    // TODO: Google sign-in
  }

  // _testDbConnection removed per user request

  void onFacebook() {
    // TODO: Facebook sign-in
  }

  void onApple() {
    // TODO: Apple sign-in
  }
}
