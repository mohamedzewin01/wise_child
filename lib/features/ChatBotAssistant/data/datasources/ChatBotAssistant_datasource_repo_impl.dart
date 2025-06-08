import 'package:wise_child/core/api/api_extentions.dart';
import 'package:wise_child/core/common/api_result.dart';

import 'package:wise_child/features/ChatBotAssistant/domain/entities/questions_entity.dart';

import 'ChatBotAssistant_datasource_repo.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/api/api_manager/api_manager.dart';

@Injectable(as: ChatBotAssistantDatasourceRepo)
class ChatBotAssistantDatasourceRepoImpl implements ChatBotAssistantDatasourceRepo {
  final ApiService apiService;
  ChatBotAssistantDatasourceRepoImpl(this.apiService);

  @override
  Future<Result<QuestionsEntity?>> getQuestions() {
   return executeApi(() async{
     var questions = await apiService.getQuestions();
     return questions?.toQuestionsEntity();
   },);
  }
}
