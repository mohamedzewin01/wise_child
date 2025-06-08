import 'package:injectable/injectable.dart';
import 'package:wise_child/core/common/api_result.dart';
import 'package:wise_child/features/ChatBotAssistant/data/datasources/ChatBotAssistant_datasource_repo.dart';
import 'package:wise_child/features/ChatBotAssistant/domain/entities/questions_entity.dart';
import '../../domain/repositories/ChatBotAssistant_repository.dart';

@Injectable(as: ChatBotAssistantRepository)
class ChatBotAssistantRepositoryImpl implements ChatBotAssistantRepository {
  final ChatBotAssistantDatasourceRepo _chatBotAssistantDatasourceRepo;

  ChatBotAssistantRepositoryImpl(this._chatBotAssistantDatasourceRepo);

  @override
  Future<Result<QuestionsEntity?>> getQuestions() {
return _chatBotAssistantDatasourceRepo.getQuestions();
  }
  // implementation
}
