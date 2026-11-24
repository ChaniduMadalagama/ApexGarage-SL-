import 'package:apexgarage_sl/auth/auth.dart';
import 'package:apexgarage_sl/utils/utils.dart';

/// This class represents a repository for authentication-related operations.
/// It extends the [ApiClient] class.
class AuthRepository extends ApiClient {
  AuthRepository() : super();

  /// Registers a new user with the provided [request] data.
  /// Returns a [Future] that completes with a [Session] object if the registration is successful.
  /// Throws an [Exception] if the registration fails.
  Future<Session> register(RegisterRequestModel request) async {
    try {
      // TODO(ishanga): Remove the following section after implementing the API call. Use the `post` method to make the API call.
      // return Session if successful, throw Exception if failed
      final tempPayload = {
        'result': true,
        'message': 'User registered successfully',
        'payload': {
          'id': '1',
          'access_token': 'token',
          'created_at': DateTime.now().toIso8601String(),
          'is_email_verified': false,
          'is_profile_completed': false,
        },
      };
      final response = Response<dynamic>(requestOptions: RequestOptions(path: '/register'), data: tempPayload);
      // real API call goes here

      final apiResponse = ApiResponse.fromJson(response.data as Map<String, dynamic>);
      if (apiResponse is ApiFailureResponse) {
        throw Exception(apiResponse.message);
      } else {
        return Session.fromJson(apiResponse.data as Map<String, dynamic>);
      }
    } on Exception catch (e) {
      return onError(e);
    }
  }

  /// Logs in a user with the provided [request] data.
  /// Returns a [Future] that completes with a [Session] object if the login is successful.
  /// Throws an [Exception] if the login fails.
  Future<Session> logIn(LogInRequestModel request) async {
    try {
      // TODO(ishanga): Remove the following section after implementing the API call. Use the `post` method to make the API call.
      // return Session if successful, throw Exception if failed
      final tempPayload = {
        'result': true,
        'message': 'User logged in successfully',
        'payload': {
          'id': '1',
          'access_token': 'token',
          'created_at': DateTime.now().toIso8601String(),
          'is_email_verified': false,
          'is_profile_completed': false,
        },
      };
      final response = Response<dynamic>(requestOptions: RequestOptions(path: '/login'), data: tempPayload);
      // real API call goes here

      final apiResponse = ApiResponse.fromJson(response.data as Map<String, dynamic>);
      if (apiResponse is ApiFailureResponse) {
        throw Exception(apiResponse.message);
      } else {
        return Session.fromJson(apiResponse.data as Map<String, dynamic>);
      }
    } on Exception catch (e) {
      return onError(e);
    }
  }

  /// Logs out the current user.
  /// Returns a [Future] that completes with a [bool] value indicating whether the logout is successful.
  /// Throws an [Exception] if the logout fails.
  Future<bool> logOut({required String token}) async {
    try {
      // TODO(ishanga): Remove the following section after implementing the API call. Use the `post` method to make the API call.
      // return Session if successful, throw Exception if failed
      final tempPayload = {
        'result': true,
        'message': 'User logged out successfully',
      };
      final response = Response<dynamic>(requestOptions: RequestOptions(path: '/logout'), data: tempPayload);
      // real API call goes here

      final apiResponse = ApiResponse.fromJson(response.data as Map<String, dynamic>);
      if (apiResponse is ApiFailureResponse) {
        throw Exception(apiResponse.message);
      } else {
        return true;
      }
    } on Exception catch (e) {
      return onError(e);
    }
  }

  /// Resend the verification code for email verification during registration.
  /// Returns a [Future] that completes with a [bool] value indicating whether the resend is successful.
  /// Throws an [Exception] if the resend fails.
  Future<bool> resendVerifyCode({required String token}) async {
    try {
      // TODO(ishanga): Remove the following section after implementing the API call. Use the `post` method to make the API call.
      // return Session if successful, throw Exception if failed
      final tempPayload = {
        'result': true,
        'message': 'Verification code resent successfully',
      };
      final response = Response<dynamic>(requestOptions: RequestOptions(path: '/resend-code', headers: {'x-access-token': token}), data: tempPayload);
      // real API call goes here

      final apiResponse = ApiResponse.fromJson(response.data as Map<String, dynamic>);
      if (apiResponse is ApiFailureResponse) {
        throw Exception(apiResponse.message);
      } else {
        return true;
      }
    } on Exception catch (e) {
      return onError(e);
    }
  }

  /// Verifies the user's email with the provided [code].
  /// Returns a [Future] that completes with a [Session] object if the verification is successful.
  /// Throws an [Exception] if the verification fails.
  Future<Session> verifyEmail({required String code, required String token}) async {
    try {
      // TODO(ishanga): Remove the following section after implementing the API call. Use the `post` method to make the API call.
      // return Session if successful, throw Exception if failed
      final tempPayload = {
        'result': true,
        'message': 'Email verified successfully',
        'payload': {
          'id': '1',
          'access_token': 'token',
          'created_at': DateTime.now().toIso8601String(),
          'is_email_verified': true,
          'is_profile_completed': false,
        },
      };
      final response = Response<dynamic>(requestOptions: RequestOptions(path: '/verify-email', headers: {'x-access-token': token}), data: tempPayload);
      // real API call goes here

      final apiResponse = ApiResponse.fromJson(response.data as Map<String, dynamic>);
      if (apiResponse is ApiFailureResponse) {
        throw Exception(apiResponse.message);
      } else {
        return Session.fromJson(apiResponse.data as Map<String, dynamic>);
      }
    } on Exception catch (e) {
      return onError(e);
    }
  }
  
  /// Retrieves the current user as a [Session] object.
  ///
  /// This method makes an API call to retrieve the details of the current user
  /// using the provided [token]. It returns a [Session] object representing
  /// the current user's session.
  ///
  /// Throws an [Exception] if the API response is a failure, with the
  /// corresponding error message.
  ///
  /// Throws an [Exception] if an error occurs during the API call.
  Future<Session> getCurrentUserAsSession({required String token}) async {
    try {
      // TODO(ishanga): Remove the following section after implementing the API call. Use the `post` method to make the API call.
      // return Session if successful, throw Exception if failed
      final tempPayload = {
        'result': true,
        'message': 'User details retrieved successfully',
        'payload': {
          'id': '1',
          'access_token': 'token',
          'created_at': DateTime.now().toIso8601String(),
          'is_email_verified': true,
          'is_profile_completed': true,
        },
      };
      final response = Response<dynamic>(requestOptions: RequestOptions(path: '/profile', headers: {'x-access-token': token}), data: tempPayload);
      // real API call goes here
      final apiResponse = ApiResponse.fromJson(response.data as Map<String, dynamic>);
      if (apiResponse is ApiFailureResponse) {
        throw Exception(apiResponse.message);
      } else {
        return Session.fromJson(apiResponse.data as Map<String, dynamic>);
      }
    } on Exception catch (e) {
      return onError(e);
    }
  }
}
