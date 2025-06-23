import '../repositories/EditProfile_repository.dart';
import 'package:injectable/injectable.dart';
import '../useCases/EditProfile_useCase_repo.dart';

@Injectable(as: EditProfileUseCaseRepo)
class EditProfileUseCase implements EditProfileUseCaseRepo {
  final EditProfileRepository repository;

  EditProfileUseCase(this.repository);

  // Future<Result<T>> call(...) async {
  //   return await repository.get...();
  // }
}
