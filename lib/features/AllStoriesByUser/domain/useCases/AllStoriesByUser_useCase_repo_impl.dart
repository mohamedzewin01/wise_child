import 'package:wise_child/core/common/api_result.dart';

import 'package:wise_child/features/AllStoriesByUser/domain/entities/all_stories_enities.dart';

import '../repositories/AllStoriesByUser_repository.dart';
import 'package:injectable/injectable.dart';
import '../useCases/AllStoriesByUser_useCase_repo.dart';

@Injectable(as: AllStoriesByUserUseCaseRepo)
class AllStoriesByUserUseCase implements AllStoriesByUserUseCaseRepo {
  final AllStoriesByUserRepository repository;

  AllStoriesByUserUseCase(this.repository);

  @override
  Future<Result<UserStoriesEntity?>> getUserStories() {
    return repository.getUserStories();
  }


}
