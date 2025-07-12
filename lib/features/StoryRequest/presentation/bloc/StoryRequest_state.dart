part of 'StoryRequest_cubit.dart';

@immutable
sealed class StoryRequestState {}

final class StoryRequestInitial extends StoryRequestState {}
final class StoryRequestLoading extends StoryRequestState {}
final class StoryRequestSuccess extends StoryRequestState {
  final AddStoryRequestsEntity addStoryRequestsEntity;
  StoryRequestSuccess(this.addStoryRequestsEntity);
}
final class StoryRequestFailure extends StoryRequestState {
  final Exception exception;

  StoryRequestFailure(this.exception);
}

final class GetChildrenUserLoading extends StoryRequestState {}
final class GetChildrenUserSuccess extends StoryRequestState {
 final GetUserChildrenEntity getUserChildrenEntity;
  GetChildrenUserSuccess(this.getUserChildrenEntity);
}
final class GetChildrenUserFailure extends StoryRequestState {
  final Exception exception;

  GetChildrenUserFailure(this.exception);
}
