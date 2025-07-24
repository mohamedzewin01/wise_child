import '../repositories/Notifications_repository.dart';
import 'package:injectable/injectable.dart';
import '../useCases/Notifications_useCase_repo.dart';

@Injectable(as: NotificationsUseCaseRepo)
class NotificationsUseCase implements NotificationsUseCaseRepo {
  final NotificationsRepository repository;

  NotificationsUseCase(this.repository);

  // Future<Result<T>> call(...) async {
  //   return await repository.get...();
  // }
}
