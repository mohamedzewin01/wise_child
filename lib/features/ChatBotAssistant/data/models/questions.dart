

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:wise_child/features/ChatBotAssistant/data/models/response/questions_dto.dart';

import '../../domain/entities/questions_entity.dart';

class ChatMessage {
  final String text;
  final bool isBot;
  final Questions? question;
  final bool isTyping;
  final Widget? imageWidget;
  final Widget? finalWidget;


  ChatMessage(   {
    required this.text,
    required this.isBot,
    this.question,
    this.isTyping = false,
    this.imageWidget,
    this.finalWidget,

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
    case 'image':
      return QuestionType.image;
    case 'yesOrNo':
      return QuestionType.yesOrNo;
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
  final File? imageFile;

  Answer({
    required this.questionId,
    this.textAnswer,
    this.selectedOption,
    this.selectedOptions,
    this.sequentialAnswers,
    this.imageFile,

  });
}

class SequentialState {
  final bool isInSequentialMode;
  final int sequentialCount;
  final int currentSequentialIndex;
  final List<String> sequentialAnswers;
  final String sequentialPrompt;

  const  SequentialState({
    this.isInSequentialMode = false,
    this.sequentialCount = 0,
    this.currentSequentialIndex = 0,
    this.sequentialAnswers = const [],
    this.sequentialPrompt = '',
  });

  SequentialState copyWith({
    bool? isInSequentialMode,
    int? sequentialCount,
    int? currentSequentialIndex,
    List<String>? sequentialAnswers,
    String? sequentialPrompt,
  }) {
    return SequentialState(
      isInSequentialMode: isInSequentialMode ?? this.isInSequentialMode,
      sequentialCount: sequentialCount ?? this.sequentialCount,
      currentSequentialIndex: currentSequentialIndex ?? this.currentSequentialIndex,
      sequentialAnswers: sequentialAnswers ?? this.sequentialAnswers,
      sequentialPrompt: sequentialPrompt ?? this.sequentialPrompt,
    );
  }

  static empty() {
    return SequentialState();
  }

}


class YesOrNoState {
  final bool isInSequentialMode;
  final int sequentialCount;
  final int currentSequentialIndex;
  final List<String> sequentialAnswers;
  final String sequentialPrompt;

  const  YesOrNoState({
    this.isInSequentialMode = false,
    this.sequentialCount = 0,
    this.currentSequentialIndex = 0,
    this.sequentialAnswers = const [],
    this.sequentialPrompt = '',
  });

  YesOrNoState copyWith({
    bool? isInSequentialMode,
    int? sequentialCount,
    int? currentSequentialIndex,
    List<String>? sequentialAnswers,
    String? sequentialPrompt,
  }) {
    return YesOrNoState(
      isInSequentialMode: isInSequentialMode ?? this.isInSequentialMode,
      sequentialCount: sequentialCount ?? this.sequentialCount,
      currentSequentialIndex: currentSequentialIndex ?? this.currentSequentialIndex,
      sequentialAnswers: sequentialAnswers ?? this.sequentialAnswers,
      sequentialPrompt: sequentialPrompt ?? this.sequentialPrompt,
    );
  }

  static empty() {
    return YesOrNoState();
  }

}