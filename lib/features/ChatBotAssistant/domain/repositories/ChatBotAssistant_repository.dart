import 'package:wise_child/core/common/api_result.dart';
import 'package:wise_child/features/ChatBotAssistant/domain/entities/questions_entity.dart';

abstract class ChatBotAssistantRepository {
  Future<Result<QuestionsEntity?>> getQuestions();

}
