// file: lib/registration/bloc/auth_state.dart
part of 'auth_bloc.dart'; // Will be created next

// User class (if not defined elsewhere)
class User extends Equatable {
  final String id;
  final String name;

  const User({required this.id, required this.name});

  @override
  List<Object?> get props => [id, name];

  static const empty = User(id: '', name: ''); // For unauthenticated state
}


abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final User user;

  const AuthSuccess({required this.user});

  @override
  List<Object?> get props => [user];
}

class AuthFailure extends AuthState {
  final String error;

  const AuthFailure({required this.error});

  @override
  List<Object?> get props => [error];
}
