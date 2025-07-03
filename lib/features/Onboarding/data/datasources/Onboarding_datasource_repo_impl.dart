import 'Onboarding_datasource_repo.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/api/api_manager/api_manager.dart';

@Injectable(as: OnboardingDatasourceRepo)
class OnboardingDatasourceRepoImpl implements OnboardingDatasourceRepo {
  final ApiService apiService;
  OnboardingDatasourceRepoImpl(this.apiService);
}
