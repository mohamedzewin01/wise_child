import 'package:flutter/material.dart';
import 'package:wise_child/features/ChatBotAssistant/data/models/questions.dart';
import '../../data/models/response/questions_dto.dart';
import '../../domain/entities/questions_entity.dart';


class ChatController {
  final List<ChatMessage> _messages = [];
  final List<Answer> _answers = [];
  final ScrollController _scrollController = ScrollController();

  int _currentQuestionIndex = 0;
  List<Questions> _questions = [];

  // متغيرات للأسئلة المتسلسلة
  bool _isInSequentialMode = false;
  int _sequentialCount = 0;
  int _currentSequentialIndex = 0;
  List<String> _sequentialAnswers = [];
  String _sequentialPrompt = '';

  // متغيرات للإجابات الحالية

  String _currentTextAnswer = '';

  // Getters
  List<ChatMessage> get messages => _messages;
  List<Answer> get answers => _answers;
  ScrollController get scrollController => _scrollController;
  int get currentQuestionIndex => _currentQuestionIndex;
  List<Questions> get questions => _questions;
  bool get isInSequentialMode => _isInSequentialMode;
  String get currentTextAnswer => _currentTextAnswer;

  void setQuestions(List<Questions> questions) {
    _questions = questions;
  }

  void setCurrentTextAnswer(String value) {
    _currentTextAnswer = value;
  }

  void startChat() {
    _messages.add(
      ChatMessage(
        text: 'أهلاً وسهلاً! \n  سأقوم بطرح بعض الأسئلة عليك.\n  دعنا نبدأ!',
        isBot: true,
      ),
    );
  }

  void askNextQuestion() {
    if (_currentQuestionIndex < _questions.length) {
      final question = _questions[_currentQuestionIndex];

      // إضافة مؤشر الكتابة أولاً
      _messages.add(
        ChatMessage(
          text: '',
          isBot: true,
          isTyping: true,
        ),
      );

      // إزالة مؤشر الكتابة وإضافة السؤال الفعلي بعد تأخير

      Future.delayed(Duration(milliseconds: 2000), () {
        // إزالة مؤشر الكتابة

        _messages.removeWhere((message) => message.isTyping);


        // إضافة السؤال الفعلي
        _messages.add(
          ChatMessage(
              text: question.question ?? '', isBot: true, question: question),
        );

        // إعادة تعيين الإجابات الحالية
        _currentTextAnswer = '';

        // إعداد الأسئلة المتسلسلة
        if (question.type == QuestionType.sequential) {
          _isInSequentialMode = false;
          _sequentialCount = 0;
          _currentSequentialIndex = 0;
          _sequentialAnswers.clear();
          _sequentialPrompt = question.followUpQuestion ?? '';
        }
      });
    }
  }

  bool submitAnswer(
      String? currentSingleChoice, List<String> currentMultipleChoices) {
    final Questions currentQuestion = _questions[_currentQuestionIndex];

    // التعامل مع الأسئلة المتسلسلة
    if (currentQuestion.type == QuestionType.sequential) {
      return _handleSequentialAnswer(currentQuestion);
    }

    late Answer answer;
    String displayText = '';

    switch (currentQuestion.type) {
      case QuestionType.text:
        if (_currentTextAnswer.trim().isEmpty) return false;
        answer = Answer(
          questionId: currentQuestion.id ?? '',
          textAnswer: _currentTextAnswer,
        );
        displayText = _currentTextAnswer;
        break;

      case QuestionType.singleChoice:
        if (currentSingleChoice == null) return false;
        answer = Answer(
          questionId: currentQuestion.id ?? '',
          selectedOption: currentSingleChoice,
        );
        displayText = currentSingleChoice;
        break;

      case QuestionType.multipleChoice:
        if (currentMultipleChoices.isEmpty) return false;
        answer = Answer(
          questionId: currentQuestion.id ?? '',
          selectedOptions: List.from(currentMultipleChoices),
        );
        displayText = currentMultipleChoices.join(', ');
        break;

      case QuestionType.sequential:
        return false; // مش هيوصل لها أصلاً بسبب الشرط فوق
    }

    _processAnswer(answer, displayText);
    return true;
  }

  bool _handleSequentialAnswer(Questions question) {
    if (!_isInSequentialMode) {
      // أول إجابة: العدد
      final countText = _currentTextAnswer.trim();
      if (countText.isEmpty) return false;

      final count = int.tryParse(countText);
      if (count == null || count <= 0) {
        _showErrorMessage('يرجى إدخال رقم صحيح أكبر من الصفر');
        return false;
      }

      _sequentialCount = count;
      _isInSequentialMode = true;
      _currentSequentialIndex = 1;
      _sequentialAnswers.clear();

      // إضافة رسالة المستخدم
      _messages.add(ChatMessage(text: countText, isBot: false));

      _currentTextAnswer = '';

      if (count == 0) {
        // إذا كان العدد صفر، ننتقل للسؤال التالي
        final answer = Answer(
            questionId: question.id ?? '', sequentialAnswers: []);
        _processAnswer(answer, 'لا يوجد');
        return true;
      }

      // طرح السؤال الأول من السلسلة مع مؤشر الكتابة
      _askSequentialQuestionWithTyping(question);
    } else {
      // إجابة على أحد الأسئلة المتسلسلة
      if (_currentTextAnswer.trim().isEmpty) return false;

      _sequentialAnswers.add(_currentTextAnswer.trim());
      _messages.add(
        ChatMessage(text: _currentTextAnswer.trim(), isBot: false),
      );
      _currentSequentialIndex++;

      _currentTextAnswer = '';

      if (_currentSequentialIndex <= _sequentialCount) {
        // طرح السؤال التالي مع مؤشر الكتابة
        _askSequentialQuestionWithTyping(question);
      } else {
        // انتهينا من جميع الأسئلة المتسلسلة
        final answer = Answer(
          questionId: question.id ?? '',
          sequentialAnswers: List.from(_sequentialAnswers),
        );

        _showTypingAndMessage('شكراً لك! السؤال التالي:', () {
          _answers.add(answer);
          _currentQuestionIndex++;
          _isInSequentialMode = false;
          askNextQuestion();
        });
      }
    }
    return true;
  }

  void _askSequentialQuestionWithTyping(Questions question) {
    // إضافة مؤشر الكتابة
    _messages.add(
      ChatMessage(
        text: '',
        isBot: true,
        isTyping: true,
      ),
    );

    // إزالة مؤشر الكتابة وإضافة السؤال
    Future.delayed(Duration(milliseconds: 1500), () {
      _messages.removeWhere((message) => message.isTyping);
      _messages.add(
        ChatMessage(
          text: '${question.followUpQuestion} $_currentSequentialIndex؟',
          isBot: true,
        ),
      );
    });
  }

  void _processAnswer(Answer answer, String displayText) {
    _answers.add(answer);
    _messages.add(ChatMessage(text: displayText, isBot: false));
    _currentQuestionIndex++;

    if (_currentQuestionIndex < _questions.length) {
      _showTypingAndMessage('شكراً لك! السؤال التالي:', () {
        askNextQuestion();
      });
    } else {
      showResults();
    }
  }

  void _showTypingAndMessage(String message, VoidCallback onComplete) {
    // إضافة مؤشر الكتابة
    _messages.add(
      ChatMessage(
        text: '',
        isBot: true,
        isTyping: true,
      ),
    );

    // إزالة مؤشر الكتابة وإضافة الرسالة
    Future.delayed(Duration(milliseconds: 1500), () {
      _messages.removeWhere((message) => message.isTyping);
      _messages.add(
        ChatMessage(text: message, isBot: true),
      );

      Future.delayed(Duration(milliseconds: 300), onComplete);
    });
  }

  void _showErrorMessage(String message) {
    _messages.add(ChatMessage(text: message, isBot: true));
  }

  void showResults() {
    _showTypingAndMessage(
        'شكراً لك! لقد انتهينا من جميع الأسئلة. إليك ملخص إجاباتك:', () {
      String summary = '';
      for (int i = 0; i < _questions.length; i++) {
        final question = _questions[i];
        final answer = _answers.firstWhere((a) => a.questionId == question.id);

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
            break;
        }
      }

      Future.delayed(Duration(milliseconds: 500), () {
        _messages.add(ChatMessage(text: summary, isBot: true));
      });
    });
  }

  void scrollToBottom() {
    Future.delayed(Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void dispose() {
    _scrollController.dispose();
  }
}