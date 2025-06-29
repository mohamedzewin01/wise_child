part of 'EditProfile_cubit.dart';

@immutable
sealed class EditProfileState {}

final class EditProfileInitial extends EditProfileState {}

final class EditProfileLoading extends EditProfileState {}

final class EditProfileDataLoaded extends EditProfileState {
  final EditProfileEntity userEntity;

  EditProfileDataLoaded(this.userEntity);
}

final class EditProfileSuccess extends EditProfileState {
  final EditProfileEntity editProfileEntity;

  EditProfileSuccess(this.editProfileEntity);
}

final class EditProfileFailure extends EditProfileState {
  final Exception exception;

  EditProfileFailure(this.exception);
}

final class EditProfileValidationError extends EditProfileState {
  final String errorMessage;

  EditProfileValidationError(this.errorMessage);
}