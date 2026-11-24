import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:apexgarage_sl/auth/auth.dart';
import 'package:apexgarage_sl/utils/utils.dart';

class AuthService extends AuthRepository {
  AuthService() : super();

  final StreamController<AuthState> _authStateSubject = StreamController<AuthState>.broadcast();
  final Box<String> _storage = Hive.box<String>(GetIt.instance<AppSettings>().sessionSecretKey); // Need to open first before using, see bootstrap.dart

  Stream<AuthState> get onAuthStateChanges => _authStateSubject.stream;

  /// Logs in the user with the provided [email] and [password].
  /// 
  /// This method sets the authentication state to [AuthLoading] and then attempts to log in the user using the provided credentials.
  /// It retrieves the device platform and device ID from the [AppSettings] instance using [GetIt] and creates a [LogInRequestModel] with the email, password, device ID, and device platform.
  /// The method then calls the [logIn] function to send the login request and awaits the response.
  /// If the login is successful, the session is saved using [_saveSession] and the authentication state is set to [AuthSuccess] with the session response.
  /// If an error occurs during the login process, the authentication state is set to [AuthFailed] with the error message.
  /// 
  /// Throws an exception if any error occurs during the login process.
  Future<void> login(String email, String password) async {
    _authStateSubject.add(AuthLoading());
    try {
      final devicePlatform = GetIt.instance<AppSettings>().getDevicePlatform();
      final deviceId = await GetIt.instance<AppSettings>().getDeviceId();
      final request = LogInRequestModel(
        email: email,
        password: password,
        deviceId: deviceId,
        deviceType: devicePlatform,
      );

      final response = await logIn(request);
      await _saveSession(response);
      _authStateSubject.add(AuthSuccess(session: response));
    } catch (e) {
      _authStateSubject.add(AuthFailed(e.toString()));
    }
  }

  /// Signs up a user with the provided [email], [password], and [phone].
  /// This method updates the authentication state by adding [AuthLoading] to the [_authStateSubject].
  /// It then creates a [RegisterRequestModel] with the provided parameters and sends a registration request.
  /// If the registration is successful, the session is saved and [AuthSuccess] with the session is added to the [_authStateSubject].
  /// If an error occurs during the registration process, [AuthFailed] with the error message is added to the [_authStateSubject].
  /// Throws an exception if any error occurs during the process.
  Future<void> signUp(String email, String password, String phone) async {
    _authStateSubject.add(AuthLoading());
    try {
      final devicePlatform = GetIt.instance<AppSettings>().getDevicePlatform();
      final deviceId = await GetIt.instance<AppSettings>().getDeviceId();
      final request = RegisterRequestModel(
        email: email,
        password: password,
        deviceId: deviceId,
        deviceType: devicePlatform,
      );

      final response = await register(request);
      await _saveSession(response);
      _authStateSubject.add(AuthSuccess(session: response));
    } catch (e) {
      log('Sign up failed: $e', name: 'AuthService');
      _authStateSubject.add(AuthFailed(e.toString()));
    }
  }

  /// Verifies the given [code] for email verification.
  /// 
  /// This method updates the authentication state to [AuthLoading] and then proceeds to verify the email using the provided [code].
  /// If the verification is successful, the session is saved and the authentication state is updated to [AuthCodeVerified].
  /// If the verification fails, the authentication state is updated to [AuthCodeVerificationFailed] with the error message.
  /// 
  /// Throws an [Exception] if no session is found.
  Future<void> verify(String code) async {
    _authStateSubject.add(AuthLoading());
    try {
      var session = await _getSession();
      if (session == null) {
        throw Exception('No session found');
      }

      final response = await verifyEmail(
        code: code,
        token: session.accessToken,
      );
      /// Preserve the access token from the previous session and update the session with the new data
      session = session.syncPreserveAccessToken(response);
      await _saveSession(session);
      _authStateSubject.add(AuthCodeVerified(session: session));
    } catch (e) {
      log('Verification failed: $e', name: 'AuthService');
      _authStateSubject.add(AuthCodeVerificationFailed(e.toString()));
    }
  }

  /// Resend the verification code for the user.
  ///
  /// This method sends a new verification code to the user's email address
  /// or phone number. It updates the authentication state to [AuthLoading]
  /// while the code is being resent. If the session is not found, it throws
  /// an exception with the message 'No session found'. After successfully
  /// resending the code, it updates the authentication state to [AuthCodeResent].
  /// If an exception occurs during the process, it updates the authentication
  /// state to [AuthCodeResendFailed] with the error message.
  ///
  /// Throws an [Exception] if there is an error while resending the code.
  Future<void> resendVerificationCode() async {
    _authStateSubject.add(AuthLoading());
    try {
      final session = await _getSession();
      if (session == null) {
        throw Exception('No session found');
      }

      await resendVerifyCode(token: session.accessToken);
      _authStateSubject.add(AuthCodeResent());
    } catch (e) {
      log('Resend verification code failed: $e', name: 'AuthService');
      _authStateSubject.add(AuthCodeResendFailed(e.toString()));
    }
  }

  /// Sends a forgot password request for the given [email].
  /// 
  /// This method simulates a forgot password request by delaying for 2 seconds.
  /// If the [email] matches the demo email, it emits an [AuthForgotPasswordSubmitSuccess] event.
  /// Otherwise, it throws an [Exception] with the message 'Invalid email' and emits an [AuthForgotPasswordSubmitFailed] event.
  /// 
  /// Throws an [Exception] if an error occurs during the process.
  Future<void> forgotPassword(String email) async {
    _authStateSubject.add(AuthLoading());
    try {
      /// This is just a demo forgot password request
      /// Replace with actual forgot password request
      const demoEmail = 'demo@demo.com';
      await Future.delayed(const Duration(seconds: 2), () {});
      if (email == demoEmail) {
        _authStateSubject.add(AuthForgotPasswordSubmitSuccess());
        return;
      } else {
        throw Exception('Invalid email');
      }
    } catch (e) {
      log('Forgot password failed: $e', name: 'AuthService');
      _authStateSubject.add(AuthForgotPasswordSubmitFailed(e.toString()));
    }
  }

  /// Logs out the user.
  ///
  /// This method sets the [_authStateSubject] to [AuthLoading] state
  /// If the logout is successful, it sets the [_authStateSubject] to [AuthInitial] state.
  /// If an error occurs during the logout process, it sets the [_authStateSubject] to [AuthFailed] state with the error message.
  ///
  /// Throws an exception if an error occurs during the logout process.
  Future<void> logout() async {
    _authStateSubject.add(AuthLoading());
    try {
      final session = await _getSession();
      if (session == null) {
        throw Exception('No session found');
      }
      
      await logOut(token: session.accessToken);
      await _deleteSession();
      _authStateSubject.add(AuthLogout());
    } catch (e) {
      log('Logout failed: $e', name: 'AuthService');
      _authStateSubject.add(AuthFailed(e.toString()));
    }
  }

  /// Saves the session to storage.
  ///
  /// [session] - The session object to be saved.
  ///
  /// Returns a [Future] that completes when the session is saved.
  Future<void> _saveSession(Session session) async {
    await _storage.put('session', jsonEncode(session.toJson()));
  }

  /// Retrieves the session from storage.
  ///
  /// Returns a [Future] that completes with the session object, or `null` if no session is found.
  Future<Session?> _getSession() async {
    final session = _storage.get('session');
    if (session == null) {
      return null;
    }
    return Session.fromJson(jsonDecode(session) as Map<String, dynamic>);
  }

  /// Deletes the session from storage.
  ///
  /// Returns a [Future] that completes when the session is deleted.
  Future<void> _deleteSession() async {
    await _storage.delete('session');
  }

  /// Refreshes the user session.
  ///
  /// This method retrieves the current user session and updates it by syncing it with the server.
  /// If the session is successfully synced, the updated session is saved and the [AuthSuccess] event is emitted.
  /// If an error occurs during the sync process, the user is logged out and the [AuthInitial] event is emitted.
  /// If there is no existing session, the [AuthInitial] event is emitted.
  ///
  /// Throws an error if there is an issue while syncing the user session.
  Future<void> refreshSession() async {
    var session = await _getSession();
    if (session != null) {
      try {
        final response = await getCurrentUserAsSession(token: session.accessToken);
        session = session.syncPreserveAccessToken(response);
        _authStateSubject.add(AuthSuccess(session: session));
        /// We need to save the session again to trigger the session change listener in the [App] in app.dart
        await _saveSession(session);
      } catch (_) {
        /// If an error occurs while syncing the user session, we log out the user
        log('Error syncing user session', name: 'AuthService');
        await _deleteSession();
        _authStateSubject.add(AuthInitial());
      }
    } else {
      _authStateSubject.add(AuthInitial());
    }
  }
}
