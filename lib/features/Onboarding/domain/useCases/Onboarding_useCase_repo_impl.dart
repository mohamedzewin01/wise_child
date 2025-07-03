import '../repositories/Onboarding_repository.dart';
import 'package:injectable/injectable.dart';
import '../useCases/Onboarding_useCase_repo.dart';

@Injectable(as: OnboardingUseCaseRepo)
class OnboardingUseCase implements OnboardingUseCaseRepo {
  final OnboardingRepository repository;

  OnboardingUseCase(this.repository);

  // Future<Result<T>> call(...) async {
  //   return await repository.get...();
  // }
}
