import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:injectable/injectable.dart';
import '../../domain/useCases/Onboarding_useCase_repo.dart';

part 'Onboarding_state.dart';

@injectable
class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit(this._onboardingUseCaseRepo) : super(OnboardingInitial());
  final OnboardingUseCaseRepo _onboardingUseCaseRepo;
}
