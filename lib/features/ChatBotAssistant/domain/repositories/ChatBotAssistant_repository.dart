import 'package:wise_child/core/common/api_result.dart';
import 'package:wise_child/features/ChatBotAssistant/data/models/request/get_filtered_questions_request.dart';
import 'package:wise_child/features/ChatBotAssistant/domain/entities/directions.dart';
import 'package:wise_child/features/ChatBotAssistant/domain/entities/questions_entity.dart';

abstract class ChatBotAssistantRepository {
  Future<Result<DirectionsEntity?>> getDirections();

  // Future<Result<QuestionsEntity?>> getQuestions();

  Future<Result<QuestionsEntity?>> getFilteredQuestions(
    GetFilteredQuestionsRequest getFilteredQuestionsRequest,
  );
}
