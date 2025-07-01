import '../repositories/Child_repository.dart';
import 'package:injectable/injectable.dart';
import '../useCases/Child_useCase_repo.dart';

@Injectable(as: ChildUseCaseRepo)
class ChildUseCase implements ChildUseCaseRepo {
  final ChildRepository repository;

  ChildUseCase(this.repository);

  // Future<Result<T>> call(...) async {
  //   return await repository.get...();
  // }
}
