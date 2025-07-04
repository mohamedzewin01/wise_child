
import 'package:injectable/injectable.dart';
import 'package:wise_child/core/common/api_result.dart';

import 'package:wise_child/features/Auth/singin_singup/data/datasources/Auth_datasource_repo.dart';
import 'package:wise_child/features/Auth/singin_singup/domain/entities/user_entity.dart';
import '../../domain/repositories/Auth_repository.dart';

@Injectable(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthDatasourceRepo _authDatasourceRepo;

  AuthRepositoryImpl(this._authDatasourceRepo);

  @override
  Future<Result<UserSignUpEntity?>> signIn(String email, String password) {
    return _authDatasourceRepo.signIn(email, password);
  }

  @override
  Future<Result<UserSignUpEntity?>> signUp(
    String? firstName,
    String? lastName,
    String email,
    String password,
  ) {
    return _authDatasourceRepo.signUp(firstName, lastName, email, password);
  }

  @override
  Future<Result<UserSignUpEntity?>> signInWithGoogle() {
    return _authDatasourceRepo.signInWithGoogle();
  }


}
