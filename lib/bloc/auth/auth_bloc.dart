// file: lib/registration/bloc/auth_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// Import events and states
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    // Register event handlers
    on<AuthSignInWithGoogleRequested>(_onSignInWithGoogleRequested);
    on<AuthSignInAsGuestRequested>(_onSignInAsGuestRequested);
    on<AuthSignOutRequested>(_onSignOutRequested);
  }

  Future<void> _onSignInWithGoogleRequested(
      AuthSignInWithGoogleRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());
    try {
      // Simulate network delay and successful authentication
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call
      const user = User(id: 'google_user_123', name: 'Google User Name (BLoC)');
      emit(AuthSuccess(user: user));
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }

  Future<void> _onSignInAsGuestRequested(
      AuthSignInAsGuestRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      const guestUser = User(id: 'guest_user_bloc', name: 'Guest (BLoC)');
      emit(AuthSuccess(user: guestUser));
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }

  Future<void> _onSignOutRequested(
      AuthSignOutRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());
    // Perform actual sign out logic with your registration service
    await Future.delayed(const Duration(milliseconds: 500));
    emit(AuthInitial()); // Back to initial state
  }
}
