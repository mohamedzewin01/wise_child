// lib/features/Auth/data/repositories_impl/forgot_password_repository_impl.dart
import 'package:injectable/injectable.dart';
import 'package:wise_child/core/common/api_result.dart';
import '../../domain/repositories/forgot_password_repository.dart';
import '../datasources/forgot_password_datasource.dart';

@Injectable(as: ForgotPasswordRepository)
class ForgotPasswordRepositoryImpl implements ForgotPasswordRepository {
  final ForgotPasswordDataSource _dataSource;

  ForgotPasswordRepositoryImpl(this._dataSource);

  @override
  Future<Result<void>> sendPasswordResetEmail(String email) async {
    try {
      return await _dataSource.sendPasswordResetEmail(email);
    } catch (e) {
      return Fail(Exception('Repository error: $e'));
    }
  }

  @override
  Future<Result<bool>> verifyEmailExists(String email) async {
    try {
      return await _dataSource.verifyEmailExists(email);
    } catch (e) {
      return Fail(Exception('Email verification error: $e'));
    }
  }
}
