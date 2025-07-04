import 'package:firebase_auth/firebase_auth.dart';
import 'package:wise_child/core/common/api_result.dart';
import 'package:wise_child/features/Auth/singin_singup/domain/entities/user_entity.dart';


abstract class AuthDatasourceRepo {
  Future<Result<UserSignUpEntity?>> signIn(String email, String password);
  Future<Result<UserSignUpEntity?>> signUp(String? firstName,String? lastName,String email, String password);
  Future<Result<UserSignUpEntity?>> signInWithGoogle();

}
