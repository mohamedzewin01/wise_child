import 'package:wise_child/core/common/api_result.dart';
import 'package:wise_child/features/ChatBotAssistant/data/models/request/get_filtered_questions_request.dart';
import 'package:wise_child/features/ChatBotAssistant/domain/entities/directions.dart';

import 'package:wise_child/features/ChatBotAssistant/domain/entities/questions_entity.dart';

import '../repositories/ChatBotAssistant_repository.dart';
import 'package:injectable/injectable.dart';
import '../useCases/ChatBotAssistant_useCase_repo.dart';

@Injectable(as: ChatBotAssistantUseCaseRepo)
class ChatBotAssistantUseCase implements ChatBotAssistantUseCaseRepo {
  final ChatBotAssistantRepository repository;

  ChatBotAssistantUseCase(this.repository);

//   @override
//   Future<Result<QuestionsEntity?>> getQuestions() {
// return repository.getQuestions();
//   }

  @override
  Future<Result<DirectionsEntity?>> getDirections() {
return repository.getDirections();
  }

  @override
  Future<Result<QuestionsEntity?>> getFilteredQuestions(GetFilteredQuestionsRequest getFilteredQuestionsRequest) {
   return repository.getFilteredQuestions(getFilteredQuestionsRequest);
  }


}
