import '../repositories/Store_repository.dart';
import 'package:injectable/injectable.dart';
import '../useCases/Store_useCase_repo.dart';

@Injectable(as: StoreUseCaseRepo)
class StoreUseCase implements StoreUseCaseRepo {
  final StoreRepository repository;

  StoreUseCase(this.repository);

  // Future<Result<T>> call(...) async {
  //   return await repository.get...();
  // }
}
