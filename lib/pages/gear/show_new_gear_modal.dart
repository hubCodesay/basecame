import 'package:flutter/material.dart';
import 'new_gear_page.dart';

/// Show the new-gear form as a modal dialog (fullscreen dialog on mobile).
///
/// Usage: call `await showNewGearModal(context);` from your button's onPressed.
Future<T?> showNewGearModal<T>(BuildContext context) {
  return Navigator.of(context).push<T>(
    MaterialPageRoute<T>(
      builder: (_) => const NewGearPage(),
      fullscreenDialog: true,
    ),
  );
}
