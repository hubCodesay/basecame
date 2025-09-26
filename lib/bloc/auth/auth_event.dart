// file: lib/registration/bloc/auth_event.dart
part of 'auth_bloc.dart'; // Will be created next

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthSignInWithGoogleRequested extends AuthEvent {}

class AuthSignInAsGuestRequested extends AuthEvent {}

class AuthSignOutRequested extends AuthEvent {}

// You might also have an internal event if the BLoC needs to react to
// something like an authentication status change from an underlying service.
// class _AuthUserChanged extends AuthEvent {
//   final User? user;
//   const _AuthUserChanged(this.user);
//   @override List<Object?> get props => [user];
// }
