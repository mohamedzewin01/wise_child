import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:injectable/injectable.dart';
import 'package:wise_child/core/common/api_result.dart';
import 'package:wise_child/features/ChatBotAssistant/data/models/request/get_filtered_questions_request.dart';
import 'package:wise_child/features/ChatBotAssistant/domain/entities/questions_entity.dart';
import '../../domain/useCases/ChatBotAssistant_useCase_repo.dart';

part 'ChatBotAssistant_state.dart';

@injectable
class ChatBotAssistantCubit extends Cubit<ChatBotAssistantState> {
  ChatBotAssistantCubit(this._chatBotAssistantUseCaseRepo) : super(ChatBotAssistantInitial());
  final ChatBotAssistantUseCaseRepo _chatBotAssistantUseCaseRepo;


  static ChatBotAssistantCubit get(context) => BlocProvider.of(context);
  // Future<void> getQuestions() async {
  //   emit(ChatBotAssistantLoading());
  //   final result = await _chatBotAssistantUseCaseRepo.getQuestions();
  //   switch (result) {
  //     case Success<QuestionsEntity?>():
  //       {
  //         if (!isClosed) {
  //           emit(ChatBotAssistantSuccess(result.data!));
  //         }
  //       }
  //     case Fail<QuestionsEntity?>():
  //       {
  //         if (!isClosed) {
  //           emit(ChatBotAssistantFailure(result.exception));
  //         }
  //       }
  //   }
  // }
  Future<void> getQuestions({required String? directionsId}) async {
    emit(ChatBotAssistantLoading());
    GetFilteredQuestionsRequest getFilteredQuestionsRequest = GetFilteredQuestionsRequest(
    directions: directionsId
    );
    final result = await _chatBotAssistantUseCaseRepo.getFilteredQuestions(getFilteredQuestionsRequest);
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

