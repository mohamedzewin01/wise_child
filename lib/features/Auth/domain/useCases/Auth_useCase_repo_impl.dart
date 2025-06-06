import 'package:firebase_auth/firebase_auth.dart';
import 'package:wise_child/core/common/api_result.dart';
import 'package:wise_child/features/Auth/domain/entities/user_entity.dart';
import '../repositories/Auth_repository.dart';
import 'package:injectable/injectable.dart';
import '../useCases/Auth_useCase_repo.dart';

@Injectable(as: AuthUseCaseRepo)
class AuthUseCase implements AuthUseCaseRepo {
  final AuthRepository repository;

  AuthUseCase(this.repository);

  @override
  Future<Result<UserSignUpEntity?>> signIn(String email, String password) {
   return repository.signIn(email, password);
  }

  @override
  Future<Result<UserSignUpEntity?>> signUp(
      String? firstName,
      String? lastName,
      String email,
      String password,
      ) {
    return repository.signUp(firstName, lastName, email, password);
  }

  @override
  Future<Result<UserSignUpEntity?>> signInWithGoogle() {
    return repository.signInWithGoogle();
  }



}
