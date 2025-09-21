class AuthNavCoordinator {
  /// When true, the global authStateChanges listener should ignore the next
  /// auth change (used when local code already handled navigation).
  bool ignoreNextAuthChange = false;

  void setIgnore() {
    ignoreNextAuthChange = true;
  }

  bool consumeIgnore() {
    final v = ignoreNextAuthChange;
    ignoreNextAuthChange = false;
    return v;
  }
}
