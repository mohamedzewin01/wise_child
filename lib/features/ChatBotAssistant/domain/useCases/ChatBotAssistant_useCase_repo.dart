import 'package:wise_child/core/common/api_result.dart';
import 'package:wise_child/features/ChatBotAssistant/domain/entities/directions.dart';
import 'package:wise_child/features/ChatBotAssistant/domain/entities/questions_entity.dart';


abstract class ChatBotAssistantUseCaseRepo {
  Future<Result<DirectionsEntity?>> getDirections();
Future<Result<QuestionsEntity?>> getQuestions();
}
