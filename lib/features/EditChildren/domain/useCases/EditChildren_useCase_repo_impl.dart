import '../repositories/EditChildren_repository.dart';
import 'package:injectable/injectable.dart';
import '../useCases/EditChildren_useCase_repo.dart';

@Injectable(as: EditChildrenUseCaseRepo)
class EditChildrenUseCase implements EditChildrenUseCaseRepo {
  final EditChildrenRepository repository;

  EditChildrenUseCase(this.repository);

  // Future<Result<T>> call(...) async {
  //   return await repository.get...();
  // }
}
