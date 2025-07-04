// lib/features/Auth/domain/useCases/forgot_password_usecase.dart
import 'package:injectable/injectable.dart';
import 'package:wise_child/core/common/api_result.dart';
import '../repositories/forgot_password_repository.dart';

@injectable
class ForgotPasswordUseCase {
  final ForgotPasswordRepository _repository;

  ForgotPasswordUseCase(this._repository);


  Future<Result<void>> sendPasswordResetEmail(String email) async {
    // Validate email format before making repository call
    if (email.isEmpty) {
      return  Fail(Exception('Email cannot be empty'));
    }

    if (!_isValidEmailFormat(email)) {
      return  Fail(Exception('Invalid email format'));
    }

    try {
      return await _repository.sendPasswordResetEmail(email.trim().toLowerCase());
    } catch (e) {
      return Fail(Exception('Failed to send reset email: $e'));
    }
  }

  /// Validates email format using RegExp
  bool _isValidEmailFormat(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}
