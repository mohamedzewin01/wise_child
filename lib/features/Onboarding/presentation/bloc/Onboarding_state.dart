part of 'Onboarding_cubit.dart';

@immutable
sealed class OnboardingState {}

final class OnboardingInitial extends OnboardingState {}
final class OnboardingLoading extends OnboardingState {}
final class OnboardingSuccess extends OnboardingState {}
final class OnboardingFailure extends OnboardingState {
  final Exception exception;

  OnboardingFailure(this.exception);
}
