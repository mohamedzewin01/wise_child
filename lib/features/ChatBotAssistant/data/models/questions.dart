//
//
//
//
// // class Question {
// //   final String id;
// //   final String question;
// //   final QuestionType type;
// //   final List<String>? options;
// //   final String? followUpQuestion;
// //   final String? countPrompt;
// //
// //   Question({
// //     required this.id,
// //     required this.question,
// //     required this.type,
// //     this.options,
// //     this.followUpQuestion,
// //     this.countPrompt,
// //   });
// // }
//
// import '../../../../test.dart';

import 'package:wise_child/features/ChatBotAssistant/data/models/response/questions_dto.dart';

import '../../domain/entities/questions_entity.dart';

class ChatMessage {
  final String text;
  final bool isBot;
  final Questions? question;
  final bool isTyping;

  ChatMessage({
    required this.text,
    required this.isBot,
    this.question,
    this.isTyping = false,
  });
}
//


QuestionType questionTypeFromString(String? type) {
  switch (type) {
    case 'text':
      return QuestionType.text;
    case 'singleChoice':
      return QuestionType.singleChoice;
    case 'multipleChoice':
      return QuestionType.multipleChoice;
    case 'sequential':
      return QuestionType.sequential;
    default:
      throw Exception('Unknown question type: $type');
  }
}





class Answer {
  final String questionId;
  final String? textAnswer;
  final String? selectedOption;
  final List<String>? selectedOptions;
  final List<String>? sequentialAnswers;

  Answer({
    required this.questionId,
    this.textAnswer,
    this.selectedOption,
    this.selectedOptions,
    this.sequentialAnswers,
  });
}