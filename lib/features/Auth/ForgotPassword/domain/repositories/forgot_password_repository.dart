
import 'package:wise_child/core/common/api_result.dart';


abstract class ForgotPasswordRepository {

  Future<Result<void>> sendPasswordResetEmail(String email);
  

  Future<Result<bool>> verifyEmailExists(String email);
}
