

import 'package:wise_child/features/ChatBotAssistant/data/models/response/questions_dto.dart';

class QuestionsEntity {

  final String? status;

  final String? message;

  final List<Questions>? questions;

  QuestionsEntity ({
    this.status,
    this.message,
    this.questions,
  });


}
enum QuestionType { text, singleChoice, multipleChoice, sequential,image }