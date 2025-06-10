import 'dart:io';

import 'package:wise_child/features/ChatBotAssistant/data/models/questions.dart';
import 'package:wise_child/features/ChatBotAssistant/data/models/response/questions_dto.dart';

// import 'package:wise_child/features/ChatBotAssistant/presentation/new/models/chat_message.dart'  hide ChatMessage, Answer;
abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {
  final List<ChatMessage> messages;
  final List<Questions> questions;
  final List<Answer> answers;
  final int currentQuestionIndex;
  final String currentTextAnswer;
  final String? currentSingleChoice;
  final List<String> currentMultipleChoices;
  final SequentialState sequentialState;
  final YesOrNoState yesOrNoState;
  final bool isCompleted;
  final File? currentImageFile;

  ChatLoaded({
    required this.messages,
    required this.questions,
    required this.answers,
    required this.currentQuestionIndex,
    this.currentTextAnswer = '',
    this.currentSingleChoice,
    this.currentMultipleChoices = const [],
    this.sequentialState =const SequentialState(),
    this.isCompleted = false,
    this.currentImageFile,
    this.yesOrNoState = const YesOrNoState(),

  });

  ChatLoaded copyWith({
    List<ChatMessage>? messages,
    List<Questions>? questions,
    List<Answer>? answers,
    int? currentQuestionIndex,
    String? currentTextAnswer,
    String? currentSingleChoice,
    List<String>? currentMultipleChoices,
    SequentialState? sequentialState,
    bool? isCompleted,
    File? currentImageFile,

  }) {
    return ChatLoaded(
      messages: messages ?? this.messages,
      questions: questions ?? this.questions,
      answers: answers ?? this.answers,
      currentImageFile: currentImageFile ?? this.currentImageFile,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      currentTextAnswer: currentTextAnswer ?? this.currentTextAnswer,
      currentSingleChoice: currentSingleChoice ?? this.currentSingleChoice,
      currentMultipleChoices: currentMultipleChoices ?? this.currentMultipleChoices,
      sequentialState: sequentialState ?? this.sequentialState,
      isCompleted: isCompleted ?? this.isCompleted,

    );
  }
}


class OnImageSelected extends ChatState {}

class ChatError extends ChatState {
  final String message;
  ChatError(this.message);
}
