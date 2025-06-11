import 'package:injectable/injectable.dart';
import 'package:wise_child/core/common/api_result.dart';
import 'package:wise_child/features/ChatBotAssistant/data/datasources/ChatBotAssistant_datasource_repo.dart';
import 'package:wise_child/features/ChatBotAssistant/data/models/request/get_filtered_questions_request.dart';
import 'package:wise_child/features/ChatBotAssistant/domain/entities/directions.dart';
import 'package:wise_child/features/ChatBotAssistant/domain/entities/questions_entity.dart';
import '../../domain/repositories/ChatBotAssistant_repository.dart';

@Injectable(as: ChatBotAssistantRepository)
class ChatBotAssistantRepositoryImpl implements ChatBotAssistantRepository {
  final ChatBotAssistantDatasourceRepo _chatBotAssistantDatasourceRepo;

  ChatBotAssistantRepositoryImpl(this._chatBotAssistantDatasourceRepo);

  // @override
  // Future<Result<QuestionsEntity?>> getQuestions() {
  //   return _chatBotAssistantDatasourceRepo.getQuestions();
  // }

  @override
  Future<Result<DirectionsEntity?>> getDirections() {
    return _chatBotAssistantDatasourceRepo.getDirections();
  }

  @override
  Future<Result<QuestionsEntity?>> getFilteredQuestions(
    GetFilteredQuestionsRequest getFilteredQuestionsRequest,
  ) {
    return _chatBotAssistantDatasourceRepo.getFilteredQuestions(
      getFilteredQuestionsRequest,
    );
  }

  // implementation
}
