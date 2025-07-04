// lib/features/Auth/data/datasources/forgot_password_datasource.dart
import 'package:wise_child/core/common/api_result.dart';

/// Data source interface for forgot password functionality
abstract class ForgotPasswordDataSource {
  /// Sends a password reset email using Firebase Auth
  /// 
  /// [email] The email address to send the reset link to
  /// 
  /// Returns [Result<void>] indicating success or failure
  Future<Result<void>> sendPasswordResetEmail(String email);
  
  /// Verifies if the email exists in Firebase Auth (optional)
  /// 
  /// [email] The email address to verify
  /// 
  /// Returns [Result<bool>] indicating if email exists
  Future<Result<bool>> verifyEmailExists(String email);
}
