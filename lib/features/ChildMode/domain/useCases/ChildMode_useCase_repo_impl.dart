import '../repositories/ChildMode_repository.dart';
import 'package:injectable/injectable.dart';
import '../useCases/ChildMode_useCase_repo.dart';

@Injectable(as: ChildModeUseCaseRepo)
class ChildModeUseCase implements ChildModeUseCaseRepo {
  final ChildModeRepository repository;

  ChildModeUseCase(this.repository);

  // Future<Result<T>> call(...) async {
  //   return await repository.get...();
  // }
}
