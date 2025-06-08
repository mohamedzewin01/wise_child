part of 'ChatBotAssistant_cubit.dart';

@immutable
sealed class ChatBotAssistantState {}

final class ChatBotAssistantInitial extends ChatBotAssistantState {}
final class ChatBotAssistantLoading extends ChatBotAssistantState {}
final class ChatBotAssistantSuccess extends ChatBotAssistantState {
  final QuestionsEntity? questionsEntity;

  ChatBotAssistantSuccess(this.questionsEntity);
}
final class ChatBotAssistantFailure extends ChatBotAssistantState {
  final Exception exception;

  ChatBotAssistantFailure(this.exception);
}
