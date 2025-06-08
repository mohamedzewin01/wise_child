import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:injectable/injectable.dart';
import 'package:wise_child/core/common/api_result.dart';
import 'package:wise_child/features/ChatBotAssistant/domain/entities/questions_entity.dart';
import '../../domain/useCases/ChatBotAssistant_useCase_repo.dart';

part 'ChatBotAssistant_state.dart';

@injectable
class ChatBotAssistantCubit extends Cubit<ChatBotAssistantState> {
  ChatBotAssistantCubit(this._chatBotAssistantUseCaseRepo) : super(ChatBotAssistantInitial());
  final ChatBotAssistantUseCaseRepo _chatBotAssistantUseCaseRepo;

  Future<void> getQuestions() async {
    emit(ChatBotAssistantLoading());
    final result = await _chatBotAssistantUseCaseRepo.getQuestions();
    switch (result) {
      case Success<QuestionsEntity?>():
        {
          if (!isClosed) {
            emit(ChatBotAssistantSuccess(result.data!));
          }
        }
      case Fail<QuestionsEntity?>():
        {
          if (!isClosed) {
            emit(ChatBotAssistantFailure(result.exception));
          }
        }
    }
  }
}
