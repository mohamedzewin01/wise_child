import '../repositories/ChildDetailsPage_repository.dart';
import 'package:injectable/injectable.dart';
import '../useCases/ChildDetailsPage_useCase_repo.dart';

@Injectable(as: ChildDetailsPageUseCaseRepo)
class ChildDetailsPageUseCase implements ChildDetailsPageUseCaseRepo {
  final ChildDetailsPageRepository repository;

  ChildDetailsPageUseCase(this.repository);

  // Future<Result<T>> call(...) async {
  //   return await repository.get...();
  // }
}
