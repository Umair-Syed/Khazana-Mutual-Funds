import 'package:equatable/equatable.dart';
import 'package:khazana_mutual_funds/features/auth/domain/entities/user.dart';

enum AuthStateStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  otpSent,
  error,
}

class AuthState extends Equatable {
  final AuthStateStatus status;
  final User? user;
  final String? errorMessage;
  final String? email;

  const AuthState({
    this.status = AuthStateStatus.initial,
    this.user,
    this.errorMessage,
    this.email,
  });

  AuthState copyWith({
    AuthStateStatus? status,
    User? user,
    String? errorMessage,
    String? email,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage,
      email: email ?? this.email,
    );
  }

  @override
  List<Object?> get props => [status, user, errorMessage, email];
}
