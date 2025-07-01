part of 'add_kids_favorite_image_cubit.dart';

@immutable
sealed class AddKidsFavoriteImageState {}

final class AddKidsFavoriteImageInitial extends AddKidsFavoriteImageState {}
final class AddKidsFavoriteImageLoading extends AddKidsFavoriteImageState {}
final class AddKidsFavoriteImageSuccess extends AddKidsFavoriteImageState {
  final AddKidsFavoriteImageEntity? getCategoriesStoriesEntity;

  AddKidsFavoriteImageSuccess(this.getCategoriesStoriesEntity);
}
final class AddKidsFavoriteImageFailure extends AddKidsFavoriteImageState {
  final Exception exception;

  AddKidsFavoriteImageFailure(this.exception);
}
