part of 'NewChildren_cubit.dart';

@immutable
sealed class NewChildrenState {}

final class NewChildrenInitial extends NewChildrenState {}
final class NewChildrenLoading extends NewChildrenState {}
final class NewChildrenSuccess extends NewChildrenState {
  final AddChildEntity addChildEntity;

  NewChildrenSuccess(this.addChildEntity);
}
final class NewChildrenFailure extends NewChildrenState {
  final Exception exception;

  NewChildrenFailure(this.exception);
}
final class UpdateImage extends NewChildrenState {}
final class UpdateBirthDate extends NewChildrenState {}


final class UploadImageLoading extends NewChildrenState {}
final class UploadImageSuccess extends NewChildrenState {
  final UploadImageEntity? uploadImageEntity;

  UploadImageSuccess(this.uploadImageEntity);
}
final class UploadImageFailure extends NewChildrenState {
  final Exception exception;

  UploadImageFailure(this.exception);
}