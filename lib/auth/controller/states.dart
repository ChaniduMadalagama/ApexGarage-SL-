import 'package:apexgarage_sl/auth/auth.dart';

/// Represents the abstract base class for authentication states.
abstract class AuthState {
  const AuthState();
}

/// Represents the initial authentication state.
class AuthInitial extends AuthState {}

/// Represents the authentication state when loading.
class AuthLoading extends AuthState {}

/// Represents the authentication state when authentication is successful.
class AuthSuccess extends AuthState {
  const AuthSuccess({required this.session});
  final Session session;
}

/// Represents the state when an authentication code has been resent.
class AuthCodeResent extends AuthState {}

/// Represents the state when the resending of the authentication code fails.
class AuthCodeResendFailed extends AuthState {
  /// The error message associated with the code resending failure.
  const AuthCodeResendFailed(this.message);

  /// The error message associated with the code resending failure.
  final String message;
}

/// Represents the state when an authentication code has been verified.
class AuthCodeVerified extends AuthState {
  const AuthCodeVerified({required this.session});
  final Session session;
}

/// Represents the state when the code verification fails during the authentication process.
class AuthCodeVerificationFailed extends AuthState {
  /// The error message associated with the code verification failure.
  const AuthCodeVerificationFailed(this.message);
  
  /// The error message associated with the code verification failure.
  final String message;
}

/// Represents the state when the submission of the forgot password form fails.
class AuthForgotPasswordSubmitFailed extends AuthState {
  /// Creates an instance of [AuthForgotPasswordSubmitFailed] with the given [message].
  const AuthForgotPasswordSubmitFailed(this.message);

  /// The error message associated with the failed submission.
  final String message;
}

/// Represents the state when the submission of the forgot password form is successful.
class AuthForgotPasswordSubmitSuccess extends AuthState {}

/// Represents the authentication state when authentication fails.
class AuthFailed extends AuthState {
  const AuthFailed(this.message);
  final String message;
}

/// Represents the authentication state when logging out.
class AuthLogout extends AuthState {}
