import 'package:flutter/material.dart';
import 'dart:async';

import 'package:go_router/go_router.dart';
import 'package:basecam/app_path.dart';
import 'package:basecam/services/auth_nav_coordinator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _loading = false;
  // coordinator instance — you can provide via DI; for now create local singleton
  static final AuthNavCoordinator _coordinator = AuthNavCoordinator();

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
                "Create Account",
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
              const SizedBox(height: 32),
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
              TextField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: "Confirm Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _loading ? null : onSignUp,
                child: _loading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text("Sign up"),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => context.replace(AppPath.login.path),
                child: Text(
                  "Already have an account",
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
                  _socialButton("G", onGoogle),
                  const SizedBox(width: 16),
                  _socialButton("f", onFacebook),
                  const SizedBox(width: 16),
                  _socialButton("", onApple),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _socialButton(String text, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Future<void> onSignUp() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirm = _confirmPasswordController.text;
    if (email.isEmpty || password.isEmpty || confirm.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Fill all fields')));
      return;
    }
    if (password != confirm) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Passwords do not match')));
      return;
    }

    setState(() => _loading = true);

    // immediate processing feedback (long duration will be replaced)
    if (mounted) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Реєстрація...'),
          duration: Duration(minutes: 5),
        ),
      );
    }

    try {
      // Create user with timeout
      final cred = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .timeout(
            const Duration(seconds: 15),
            onTimeout: () {
              throw TimeoutException('Таймаут при створенні акаунту');
            },
          );

      final uid = cred.user?.uid;
      debugPrint('SignUp result: user=${uid ?? 'null'}');
      if (uid == null) throw Exception('UID не отримано');

      // Write Firestore user doc with timeout. Include structured fields
      // that other parts of the app expect; values can be updated later.
      final userRef = FirebaseFirestore.instance.collection('users').doc(uid);
      await userRef
          .set({
            'email': email,
            'displayName': null,
            'photoUrl': null,
            'createdAt': FieldValue.serverTimestamp(),
            // Basic profile map
            'profile': {'bio': '', 'phone': '', 'location': ''},
            // Reviews summary (kept in sync by Cloud Function or later updates)
            'reviewsSummary': {'rating': 5.0, 'reviewCount': 0},
            // Payout info placeholder (sensitive details should be handled server-side)
            'payoutInfo': {
              'method': null,
              'payoutEmail': null,
              'stripeAccountId': null,
              'lastPayoutAt': null,
            },
          })
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              throw TimeoutException('Таймаут при записі у Firestore');
            },
          );
      debugPrint('Wrote user doc for uid=$uid');

      // Verify write (with timeout)
      final snapshot = await userRef.get().timeout(
        const Duration(seconds: 8),
        onTimeout: () {
          throw TimeoutException('Таймаут при перевірці документу');
        },
      );
      debugPrint('Read back user doc for uid=$uid: exists=${snapshot.exists}');
      if (!snapshot.exists) {
        throw Exception('Не вдалося створити документ користувача');
      }

      if (!mounted) return;

      // success: stop loading and replace processing SnackBar with success
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Успішна реєстрація')));

      // Prevent global auth listener from reacting if you do local navigation
      _coordinator.setIgnore();

      // short pause so SnackBar is visible, then navigate
      await Future.delayed(const Duration(milliseconds: 700));
      if (!mounted) return;

      try {
        Navigator.of(context).pushReplacementNamed('/login');
      } catch (_) {
        try {
          context.replace(AppPath.login.path);
        } catch (_) {}
      }
    } on FirebaseAuthException catch (e, st) {
      debugPrint('SignUp FirebaseAuthException: $e\n$st');
      if (mounted) setState(() => _loading = false);
      if (!mounted) return;
      final message = _mapFirebaseAuthError(e);
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    } on TimeoutException catch (e) {
      debugPrint('SignUp Timeout: $e');
      if (mounted) setState(() => _loading = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message ?? e.toString())));
    } catch (e, st) {
      debugPrint('SignUp unknown error: $e\n$st');
      if (mounted) setState(() => _loading = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Помилка: ${e.toString()}')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _mapFirebaseAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'Пароль занадто простий. Вкажіть складніший пароль.';
      case 'invalid-email':
        return 'Невірний формат електронної пошти.';
      case 'email-already-in-use':
        return 'Ця адреса вже зареєстрована.';
      case 'network-request-failed':
        return 'Проблема з мережею. Перевірте з’єднання.';
      case 'operation-not-allowed':
        return 'Email/Password автентифікація вимкнена у Firebase Console.';
      case 'too-many-requests':
        return 'Забагато запитів. Спробуйте пізніше.';
      default:
        return e.message ?? 'Помилка автентифікації: ${e.code}';
    }
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
