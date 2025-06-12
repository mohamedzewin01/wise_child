// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'questions_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuestionsDto _$QuestionsDtoFromJson(Map<String, dynamic> json) => QuestionsDto(
  status: json['status'] as String?,
  message: json['message'] as String?,
  questions: (json['questions'] as List<dynamic>?)
      ?.map((e) => Questions.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$QuestionsDtoToJson(QuestionsDto instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'questions': instance.questions,
    };

Questions _$QuestionsFromJson(Map<String, dynamic> json) => Questions(
  id: (json['id'] as num?)?.toInt(),
  question: json['question'] as String?,
  type: questionTypeFromString(json['type'] as String?),
  followUpQuestion: json['followUpQuestion'] as String?,
  countPrompt: json['countPrompt'] as String?,
  options: (json['options'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$QuestionsToJson(Questions instance) => <String, dynamic>{
  'id': instance.id,
  'question': instance.question,
  'type': _$QuestionTypeEnumMap[instance.type]!,
  'followUpQuestion': instance.followUpQuestion,
  'countPrompt': instance.countPrompt,
  'options': instance.options,
};

const _$QuestionTypeEnumMap = {
  QuestionType.text: 'text',
  QuestionType.singleChoice: 'singleChoice',
  QuestionType.multipleChoice: 'multipleChoice',
  QuestionType.sequential: 'sequential',
  QuestionType.image: 'image',
  QuestionType.yesOrNo: 'yesOrNo',
};
