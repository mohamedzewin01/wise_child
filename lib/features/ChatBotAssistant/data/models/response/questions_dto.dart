// import 'package:json_annotation/json_annotation.dart';
// import 'package:wise_child/features/ChatBotAssistant/domain/entities/questions_entity.dart';
//
// part 'questions_dto.g.dart';
//
// @JsonSerializable()
// class QuestionsDto {
//   @JsonKey(name: "status")
//   final String? status;
//   @JsonKey(name: "message")
//   final String? message;
//   @JsonKey(name: "questions")
//   final List<Questions>? questions;
//
//   QuestionsDto({this.status, this.message, this.questions});
//
//   factory QuestionsDto.fromJson(Map<String, dynamic> json) {
//     return _$QuestionsDtoFromJson(json);
//   }
//
//   Map<String, dynamic> toJson() {
//     return _$QuestionsDtoToJson(this);
//   }
//
//   QuestionsEntity toQuestionsEntity() {
//     return QuestionsEntity(
//       status: status,
//       message: message,
//       questions: questions,
//     );
//   }
// }
//
// @JsonSerializable()
// class Questions {
//   @JsonKey(name: "id")
//   final String? id;
//   @JsonKey(name: "question")
//   final String? question;
//   @JsonKey(name: "type")
//   final String? type;
//   @JsonKey(name: "followUpQuestion")
//   final dynamic? followUpQuestion;
//   @JsonKey(name: "countPrompt")
//   final dynamic? countPrompt;
//   @JsonKey(name: "options")
//   final List<String>? options;
//
//   Questions({
//     this.id,
//     this.question,
//     this.type,
//     this.followUpQuestion,
//     this.countPrompt,
//     this.options,
//   });
//
//   factory Questions.fromJson(Map<String, dynamic> json) {
//     return _$QuestionsFromJson(json);
//   }
//
//   Map<String, dynamic> toJson() {
//     return _$QuestionsToJson(this);
//   }
// }

import 'package:json_annotation/json_annotation.dart';
import 'package:wise_child/features/ChatBotAssistant/data/models/questions.dart';
import 'package:wise_child/features/ChatBotAssistant/domain/entities/questions_entity.dart';

part 'questions_dto.g.dart';

QuestionType questionTypeFromString(String type) {
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
      throw Exception('Unknown QuestionType: $type');
  }
}

@JsonSerializable()
class QuestionsDto {
  @JsonKey(name: "status")
  final String? status;
  @JsonKey(name: "message")
  final String? message;
  @JsonKey(name: "questions")
  final List<Questions>? questions;

  QuestionsDto({this.status, this.message, this.questions});

  factory QuestionsDto.fromJson(Map<String, dynamic> json) =>
      _$QuestionsDtoFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionsDtoToJson(this);

  QuestionsEntity toQuestionsEntity() {
    return QuestionsEntity(
      status: status,
      message: message,
      questions: questions,
    );
  }
}

@JsonSerializable()
class Questions {
  @JsonKey(name: "id")
  final String id;

  @JsonKey(name: "question")
  final String? question;

  @JsonKey(name: "type", fromJson: questionTypeFromString)
  final QuestionType type;

  @JsonKey(name: "followUpQuestion")
  final String? followUpQuestion;

  @JsonKey(name: "countPrompt")
  final String? countPrompt;

  @JsonKey(name: "options")
  final List<String>? options;

  Questions({
    required this.id,
    this.question,
    required this.type,
    this.followUpQuestion,
    this.countPrompt,
    this.options,
  });

  factory Questions.fromJson(Map<String, dynamic> json) =>
      _$QuestionsFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionsToJson(this);
}
