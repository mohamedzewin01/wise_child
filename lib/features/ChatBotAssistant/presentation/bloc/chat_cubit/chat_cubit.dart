// cubit/chat_cubit.dart
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wise_child/features/ChatBotAssistant/data/models/questions.dart';
import 'package:wise_child/features/ChatBotAssistant/data/models/response/questions_dto.dart';
import 'package:wise_child/features/ChatBotAssistant/domain/entities/questions_entity.dart';

import 'chat_state.dart';

// States

// Cubit
class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());


  static ChatCubit get(context) => BlocProvider.of(context);
  void initializeChat(List<Questions> questions) {
    final initialMessages = [
      ChatMessage(
        text: 'أهلاً وسهلاً! \n  سأقوم بطرح بعض الأسئلة عليك.\n  دعنا نبدأ!',
        isBot: true,
      ),
    ];

    emit(
      ChatLoaded(
        messages: initialMessages,
        questions: questions,
        answers: [],
        currentQuestionIndex: 0,
      ),
    );

    // Start asking first question after delay
    Future.delayed(Duration(milliseconds: 500), () {
      askNextQuestion();
    });
  }

  File? _currentImageFile;

  void askNextQuestion() {
    final currentState = state as ChatLoaded;

    if (currentState.currentQuestionIndex < currentState.questions.length) {
      final question =
          currentState.questions[currentState.currentQuestionIndex];

      // Add typing indicator
      final updatedMessages = List<ChatMessage>.from(currentState.messages)
        ..add(ChatMessage(text: '', isBot: true, isTyping: true));

      emit(currentState.copyWith(messages: updatedMessages));

      // Remove typing indicator and add actual question after delay
      Future.delayed(Duration(milliseconds: 2000), () {
        final finalMessages = List<ChatMessage>.from(currentState.messages)
          ..add(
            ChatMessage(
              text: question.question ?? '',
              isBot: true,
              question: question,
            ),
          );

        emit(
          currentState.copyWith(
            messages: finalMessages,
            currentTextAnswer: '',
            currentSingleChoice: null,
            currentMultipleChoices: [],
            currentImageFile: null,
            sequentialState: question.type == QuestionType.sequential
                ? SequentialState(
                    sequentialPrompt: question.followUpQuestion ?? '',
                  )
                : SequentialState(),
          ),
        );
      });
    } else {
      showResults();
    }
  }

  void updateTextAnswer(String text) {
    final currentState = state as ChatLoaded;
    emit(currentState.copyWith(currentTextAnswer: text));
  }

  void updateSingleChoice(String choice) {
    final currentState = state as ChatLoaded;
    emit(currentState.copyWith(currentSingleChoice: choice));
  }

  void setImage(File imageFile) {
    final currentState = state as ChatLoaded;
    emit(currentState.copyWith(currentImageFile: imageFile));
  }

  void updateMultipleChoice(String choice) {
    final currentState = state as ChatLoaded;
    final choices = List<String>.from(currentState.currentMultipleChoices);

    if (choices.contains(choice)) {
      choices.remove(choice);
    } else {
      choices.add(choice);
    }

    emit(currentState.copyWith(currentMultipleChoices: choices));
  }


  void submitAnswer() {
    final currentState = state as ChatLoaded;
    final currentQuestion =
        currentState.questions[currentState.currentQuestionIndex];

    if (currentQuestion.type == QuestionType.sequential) {
      _handleSequentialAnswer(currentQuestion);
      return;
    }

    late Answer answer;
    String displayText = '';
    Widget? imageWidget;

    switch (currentQuestion.type) {
      case QuestionType.text:
        if (currentState.currentTextAnswer.trim().isEmpty) return;
        answer = Answer(
          questionId: currentQuestion.id ?? 0,
          textAnswer: currentState.currentTextAnswer,
        );
        displayText = currentState.currentTextAnswer;
        break;

      case QuestionType.singleChoice:
        if (currentState.currentSingleChoice == null) return;
        answer = Answer(
          questionId: currentQuestion.id ?? 0,
          selectedOption: currentState.currentSingleChoice,
        );
        displayText = currentState.currentSingleChoice!;
        break;

      case QuestionType.multipleChoice:
        if (currentState.currentMultipleChoices.isEmpty) return;
        answer = Answer(
          questionId: currentQuestion.id ?? 0,
          selectedOptions: List.from(currentState.currentMultipleChoices),
        );
        displayText = currentState.currentMultipleChoices.join(', ');
        break;
      case QuestionType.image:
        if (currentState.currentImageFile == null) return;
        answer = Answer(
          questionId: currentQuestion.id ?? 0,
          imageFile: currentState.currentImageFile,
        );
        displayText = '✨ تم اضافة الصورة';
        imageWidget = Image.file(
          currentState.currentImageFile!,
          width: 200,
          height: 200,
        );
        break;

      case QuestionType.yesOrNo:
        break;
      case QuestionType.sequential:
        return;
    }

    _processAnswer(answer, displayText, imageWidget);
  }

  void _handleSequentialAnswer(Questions question) {
    final currentState = state as ChatLoaded;

    if (!currentState.sequentialState.isInSequentialMode) {
      // First answer: count
      final countText = currentState.currentTextAnswer.trim();
      if (countText.isEmpty) return;

      final count = int.tryParse(countText);
      if (count == null || count < 0) {
        showErrorMessage(' أُوبس! أدخل رقمًا صحيحًا من فضلك! 🙈');
        return;
      }

      final updatedMessages = List<ChatMessage>.from(currentState.messages)
        ..add(ChatMessage(text: countText, isBot: false));

      final newSequentialState = currentState.sequentialState.copyWith(
        sequentialCount: count,
        isInSequentialMode: true,
        currentSequentialIndex: 1,
        sequentialAnswers: [],
      );

      emit(
        currentState.copyWith(
          messages: updatedMessages,
          currentTextAnswer: '',
          sequentialState: newSequentialState,
        ),
      );

      if (count == 0) {
        final answer = Answer(
          questionId: question.id ?? 0,
          sequentialAnswers: [],
        );
        _processAnswer(answer, 'لا يوجد', null);
        return;
      }

      _askSequentialQuestionWithTyping(question);
    } else {
      // Answer to one of the sequential questions
      if (currentState.currentTextAnswer.trim().isEmpty) return;

      final updatedAnswers = List<String>.from(
        currentState.sequentialState.sequentialAnswers,
      )..add(currentState.currentTextAnswer.trim());

      final updatedMessages = List<ChatMessage>.from(currentState.messages)
        ..add(
          ChatMessage(
            text: currentState.currentTextAnswer.trim(),
            isBot: false,
          ),
        );

      final newSequentialState = currentState.sequentialState.copyWith(
        sequentialAnswers: updatedAnswers,
        currentSequentialIndex:
            currentState.sequentialState.currentSequentialIndex + 1,
      );

      emit(
        currentState.copyWith(
          messages: updatedMessages,
          currentTextAnswer: '',
          sequentialState: newSequentialState,
        ),
      );

      if (newSequentialState.currentSequentialIndex <=
          newSequentialState.sequentialCount) {
        _askSequentialQuestionWithTyping(question);
      } else {
        final answer = Answer(
          questionId: question.id ?? 0,
          sequentialAnswers: List.from(updatedAnswers),
        );

        _showTypingAndMessage('شكراً لك! 🙏 السؤال التالي:', () {
          final finalAnswers = List<Answer>.from(currentState.answers)
            ..add(answer);
          emit(
            currentState.copyWith(
              answers: finalAnswers,
              currentQuestionIndex: currentState.currentQuestionIndex + 1,
              sequentialState: SequentialState(),
            ),
          );
          askNextQuestion();
        });
      }
    }
  }

  void _askSequentialQuestionWithTyping(Questions question) {
    final currentState = state as ChatLoaded;

    // Add typing indicator
    final updatedMessages = List<ChatMessage>.from(currentState.messages)
      ..add(ChatMessage(text: '', isBot: true, isTyping: true));

    emit(currentState.copyWith(messages: updatedMessages));

    // Remove typing indicator and add question
    Future.delayed(Duration(milliseconds: 1500), () {
      final finalMessages =
          currentState.messages.where((msg) => !msg.isTyping).toList()..add(
            ChatMessage(
              text:
                  '${question.followUpQuestion} ${currentState.sequentialState.currentSequentialIndex}؟',
              isBot: true,
            ),
          );

      emit(currentState.copyWith(messages: finalMessages));
    });
  }

  void _processAnswer(Answer answer, String displayText, Widget? imageWidget) {
    final currentState = state as ChatLoaded;

    final updatedAnswers = List<Answer>.from(currentState.answers)..add(answer);
    final updatedMessages = List<ChatMessage>.from(currentState.messages)
      ..add(
        ChatMessage(imageWidget: imageWidget, text: displayText, isBot: false),
      );

    emit(
      currentState.copyWith(
        answers: updatedAnswers,
        messages: updatedMessages,
        currentImageFile: null,
        currentQuestionIndex: currentState.currentQuestionIndex + 1,
        currentTextAnswer: '',
        currentSingleChoice: null,
        currentMultipleChoices: [],
      ),
    );

    if (currentState.currentQuestionIndex + 1 < currentState.questions.length) {
      _showTypingAndMessage('شكراً لك! 🙏 السؤال التالي:', () {
        askNextQuestion();
      });
    } else {
      showResults();
    }
  }

  void _showTypingAndMessage(String message, VoidCallback onComplete) {
    final currentState = state as ChatLoaded;

    // Add typing indicator
    final updatedMessages = List<ChatMessage>.from(currentState.messages)
      ..add(ChatMessage(text: '', isBot: true, isTyping: true));

    emit(currentState.copyWith(messages: updatedMessages));

    // Remove typing indicator and add message
    Future.delayed(Duration(milliseconds: 1500), () {
      final finalMessages =
          currentState.messages.where((msg) => !msg.isTyping).toList()
            ..add(ChatMessage(text: message, isBot: true));

      emit(currentState.copyWith(messages: finalMessages));

      Future.delayed(Duration(milliseconds: 300), onComplete);
    });
  }

  void showErrorMessage(String message) {
    final currentState = state as ChatLoaded;
    final updatedMessages = List<ChatMessage>.from(currentState.messages)
      ..add(ChatMessage(text: message, isBot: true));

    emit(currentState.copyWith(messages: updatedMessages));
  }

  void showResults() {
    final currentState = state as ChatLoaded;

    _showTypingAndMessage(
      'شكراً لك! 🙏 لقد انتهينا من جميع الأسئلة. إليك ملخص إجاباتك: 📋✨',
      () {
        String summary = '';

        for (int i = 0; i < currentState.questions.length; i++) {
          final question = currentState.questions[i];
          final answer = currentState.answers.firstWhere(
            (a) => a.questionId == question.id,
          );

          summary += '${i + 1}. ${question.question}\n';

          switch (question.type) {
            case QuestionType.text:
              summary += 'الإجابة: ${answer.textAnswer}\n\n';
              break;
            case QuestionType.singleChoice:
              summary += 'الإجابة: ${answer.selectedOption}\n\n';
              break;
            case QuestionType.multipleChoice:
              summary += 'الإجابات: ${answer.selectedOptions?.join(', ')}\n\n';
              break;
            case QuestionType.sequential:
              if (answer.sequentialAnswers?.isEmpty ?? true) {
                summary += 'الإجابة: لا يوجد\n\n';
              } else {
                summary += 'الإجابات:\n';
                for (int j = 0; j < answer.sequentialAnswers!.length; j++) {
                  summary += '${j + 1}. ${answer.sequentialAnswers![j]}\n';
                }
                summary += '\n';
              }
            case QuestionType.image:
              if (answer.imageFile != null) {
                summary +=
                    'تم رفع صورة: ${answer.imageFile!.path.split('/').last}\n\n';
              } else {
                summary += 'لم يتم رفع صورة.\n\n';
              }
            case QuestionType.yesOrNo:
              break;
          }
        }

        Future.delayed(Duration(milliseconds: 500), () {
          final finalMessages = List<ChatMessage>.from(currentState.messages)
            ..add(ChatMessage(text: summary, isBot: true,finalWidget: ElevatedButton(onPressed: (){}, child: Text('data'))));
          emit(
            currentState.copyWith(messages: finalMessages, isCompleted: true),
          );
        });
      },
    );
  }
}
