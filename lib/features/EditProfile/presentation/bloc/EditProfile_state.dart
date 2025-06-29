part of 'EditProfile_cubit.dart';

@immutable
sealed class EditProfileState {}

final class EditProfileInitial extends EditProfileState {}
final class EditProfileLoading extends EditProfileState {}
final class EditProfileSuccess extends EditProfileState {
  final EditProfileEntity editProfileEntity;

  EditProfileSuccess(this.editProfileEntity);
}
final class EditProfileFailure extends EditProfileState {
  final Exception exception;

  EditProfileFailure(this.exception);
}
