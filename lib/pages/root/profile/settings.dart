import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:settings_ui/settings_ui.dart';

import 'package:basecam/app_path.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool notificationsEnabled = false;
  bool darkMode = false;
  bool _signingOut = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        child: SettingsList(
          platform: DevicePlatform.iOS,
          applicationType: ApplicationType.cupertino,
          sections: [
            SettingsSection(
              tiles: [
                SettingsTile.switchTile(
                  title: const Text('Notifications'),
                  initialValue: notificationsEnabled,
                  onToggle: (value) {
                    setState(() {
                      notificationsEnabled = value;
                    });
                  },
                ),
                SettingsTile.navigation(
                  title: const Text('Language'),
                  value: const Text('Eng'),
                  onPressed: (_) {
                    // TODO: open language page
                  },
                ),
                SettingsTile.navigation(
                  title: const Text('Units of Measurement'),
                  value: const Text('Km'),
                  onPressed: (_) {
                    // TODO: open units page
                  },
                ),
                SettingsTile.switchTile(
                  title: const Text('Dark mode'),
                  initialValue: darkMode,
                  onToggle: (value) {
                    setState(() {
                      darkMode = value;
                    });
                  },
                ),
              ],
            ),
            SettingsSection(
              tiles: [
                SettingsTile.navigation(
                  title: const Text('Privacy Policy'),
                  onPressed: (_) {},
                ),
                SettingsTile.navigation(
                  title: const Text('User agreement'),
                  onPressed: (_) {},
                ),
              ],
            ),
            SettingsSection(
              tiles: [
                SettingsTile.navigation(
                  title: const Text('Support'),
                  onPressed: (_) {
                    context.go(AppPath.support.path);
                  },
                ),
              ],
            ),
            SettingsSection(
              tiles: [
                SettingsTile.navigation(
                  leading: const Icon(Icons.logout),
                  title: const Text('Log out'),
                  onPressed: _signingOut
                      ? null
                      : (_) async {
                          setState(() => _signingOut = true);
                          try {
                            await FirebaseAuth.instance.signOut();
                            if (!mounted) return;
                            // Navigate to login screen (replace current stack)
                            context.go(AppPath.login.path);
                          } catch (e) {
                            if (!mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Sign out failed: $e')),
                            );
                          } finally {
                            if (mounted) setState(() => _signingOut = false);
                          }
                        },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
