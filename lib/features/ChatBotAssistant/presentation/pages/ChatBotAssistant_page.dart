//
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:wise_child/core/resources/color_manager.dart';
// import 'package:wise_child/features/ChatBotAssistant/data/models/questions.dart';
// import 'package:wise_child/features/ChatBotAssistant/data/models/response/questions_dto.dart';
// import 'package:wise_child/features/ChatBotAssistant/domain/entities/questions_entity.dart';
// import '../../../../core/di/di.dart';
// import '../../../../test.dart';
// import '../bloc/ChatBotAssistant_cubit.dart';
//
//
// final List<Questions> _questions = [
//
// ];
//
//
//
// class TypingIndicator extends StatefulWidget {
//   const TypingIndicator({super.key});
//
//   @override
//   _TypingIndicatorState createState() => _TypingIndicatorState();
// }
//
// class _TypingIndicatorState extends State<TypingIndicator>
//     with TickerProviderStateMixin {
//   late AnimationController _animationController;
//   late Animation<double> _animation;
//
//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       duration: Duration(milliseconds: 1500),
//       vsync: this,
//     );
//     _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
//     );
//     _animationController.repeat();
//   }
//
//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: _animation,
//       builder: (context, child) {
//         return Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             _buildDot(0),
//             SizedBox(width: 4),
//             _buildDot(1),
//             SizedBox(width: 4),
//             _buildDot(2),
//           ],
//         );
//       },
//     );
//   }
//
//   Widget _buildDot(int index) {
//     double delay = index * 0.3;
//     double animationValue = (_animation.value + delay) % 1.0;
//     double opacity = animationValue < 0.5
//         ? (animationValue * 2)
//         : ((1.0 - animationValue) * 2);
//
//     return Container(
//       width: 8,
//       height: 8,
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(opacity.clamp(0.3, 1.0)),
//         shape: BoxShape.circle,
//       ),
//     );
//   }
// }
//
// class ChatBotAssistantPage extends StatefulWidget {
//   const ChatBotAssistantPage({super.key});
//
//   @override
//   State<ChatBotAssistantPage> createState() => _ChatBotAssistantPageState();
// }
//
// class _ChatBotAssistantPageState extends State<ChatBotAssistantPage> {
//   late ChatBotAssistantCubit viewModel;
//   final List<ChatMessage> _messages = [];
//   final TextEditingController _textController = TextEditingController();
//   final ScrollController _scrollController = ScrollController();
//
//   int _currentQuestionIndex = 0;
//   final List<Answer> _answers = [];
//
//   // متغيرات للأسئلة المتسلسلة
//   bool _isInSequentialMode = false;
//   int _sequentialCount = 0;
//   int _currentSequentialIndex = 0;
//   List<String> _sequentialAnswers = [];
//   String _sequentialPrompt = '';
//
//   // قائمة الأسئلة
//
//
//   // متغيرات للإجابات الحالية
//   String _currentTextAnswer = '';
//   String? _currentSingleChoice;
//   List<String> _currentMultipleChoices = [];
//
//   @override
//   void initState() {
//
//     viewModel = getIt.get<ChatBotAssistantCubit>();
//     viewModel.getQuestions();
//     super.initState();
//     _startChat();
//   }
//
//   void _startChat() {
//     setState(() {
//       _messages.add(
//         ChatMessage(
//           text: 'أهلاً وسهلاً! \n  سأقوم بطرح بعض الأسئلة عليك.\n  دعنا نبدأ!',
//           isBot: true,
//         ),
//       );
//     });
//
//     Future.delayed(Duration(milliseconds: 500), () {
//       _askNextQuestion();
//     });
//   }
//
//   void _askNextQuestion() {
//     if (_currentQuestionIndex < _questions.length) {
//       final question = _questions[_currentQuestionIndex];
//
//       // إضافة مؤشر الكتابة أولاً
//       setState(() {
//         _messages.add(
//           ChatMessage(
//             text: '',
//             isBot: true,
//             isTyping: true,
//           ),
//         );
//       });
//       _scrollToBottom();
//
//       // إزالة مؤشر الكتابة وإضافة السؤال الفعلي بعد تأخير
//       Future.delayed(Duration(milliseconds: 2000), () {
//         setState(() {
//           // إزالة مؤشر الكتابة
//           _messages.removeWhere((message) => message.isTyping);
//
//           // إضافة السؤال الفعلي
//           _messages.add(
//             ChatMessage(text: question.question??'', isBot: true, question: question),
//           );
//
//           // إعادة تعيين الإجابات الحالية
//           _currentTextAnswer = '';
//           _currentSingleChoice = null;
//           _currentMultipleChoices.clear();
//
//           // إعداد الأسئلة المتسلسلة
//           if (question.type == QuestionType.sequential) {
//             _isInSequentialMode = false;
//             _sequentialCount = 0;
//             _currentSequentialIndex = 0;
//             _sequentialAnswers.clear();
//             _sequentialPrompt = question.followUpQuestion ?? '';
//           }
//         });
//         _scrollToBottom();
//       });
//     } else {
//       _showResults();
//     }
//   }
//
//
//   void _submitAnswer() {
//     final Questions currentQuestion = _questions[_currentQuestionIndex];
//
//     // التعامل مع الأسئلة المتسلسلة
//     if (currentQuestion.type == QuestionType.sequential) {
//       _handleSequentialAnswer(currentQuestion);
//       return;
//     }
//
//     late Answer answer;
//     String displayText = '';
//
//     switch (currentQuestion.type) {
//       case QuestionType.text:
//         if (_currentTextAnswer.trim().isEmpty) return;
//         answer = Answer(
//           questionId: currentQuestion.id,
//           textAnswer: _currentTextAnswer,
//         );
//         displayText = _currentTextAnswer;
//         break;
//
//       case QuestionType.singleChoice:
//         if (_currentSingleChoice == null) return;
//         answer = Answer(
//           questionId: currentQuestion.id,
//           selectedOption: _currentSingleChoice,
//         );
//         displayText = _currentSingleChoice!;
//         break;
//
//       case QuestionType.multipleChoice:
//         if (_currentMultipleChoices.isEmpty) return;
//         answer = Answer(
//           questionId: currentQuestion.id,
//           selectedOptions: List.from(_currentMultipleChoices),
//         );
//         displayText = _currentMultipleChoices.join(', ');
//         break;
//
//       case QuestionType.sequential:
//         return; // مش هيوصل لها أصلاً بسبب الشرط فوق
//     }
//
//     _processAnswer(answer, displayText);
//   }
//
//   void _handleSequentialAnswer(Questions question) {
//     if (!_isInSequentialMode) {
//       // أول إجابة: العدد
//       final countText = _currentTextAnswer.trim();
//       if (countText.isEmpty) return;
//
//       final count = int.tryParse(countText);
//       if (count == null || count <= 0) {
//         _showErrorMessage('يرجى إدخال رقم صحيح أكبر من الصفر');
//         return;
//       }
//
//       setState(() {
//         _sequentialCount = count;
//         _isInSequentialMode = true;
//         _currentSequentialIndex = 1;
//         _sequentialAnswers.clear();
//       });
//
//       // إضافة رسالة المستخدم
//       setState(() {
//         _messages.add(ChatMessage(text: countText, isBot: false));
//       });
//
//       _textController.clear();
//       _currentTextAnswer = '';
//       _scrollToBottom();
//
//       if (count == 0) {
//         // إذا كان العدد صفر، ننتقل للسؤال التالي
//         final answer = Answer(questionId: question.id.toString(), sequentialAnswers: []);
//         _processAnswer(answer, 'لا يوجد');
//         return;
//       }
//
//       // طرح السؤال الأول من السلسلة مع مؤشر الكتابة
//       _askSequentialQuestionWithTyping(question);
//     } else {
//       // إجابة على أحد الأسئلة المتسلسلة
//       if (_currentTextAnswer.trim().isEmpty) return;
//
//       setState(() {
//         _sequentialAnswers.add(_currentTextAnswer.trim());
//         _messages.add(
//           ChatMessage(text: _currentTextAnswer.trim(), isBot: false),
//         );
//         _currentSequentialIndex++;
//       });
//
//       _textController.clear();
//       _currentTextAnswer = '';
//       _scrollToBottom();
//
//       if (_currentSequentialIndex <= _sequentialCount) {
//         // طرح السؤال التالي مع مؤشر الكتابة
//         _askSequentialQuestionWithTyping(question);
//       } else {
//         // انتهينا من جميع الأسئلة المتسلسلة
//         final answer = Answer(
//           questionId: question.id??'',
//           sequentialAnswers: List.from(_sequentialAnswers),
//         );
//
//         _showTypingAndMessage('شكراً لك! السؤال التالي:', () {
//           _answers.add(answer);
//           _currentQuestionIndex++;
//           _isInSequentialMode = false;
//           _askNextQuestion();
//         });
//       }
//     }
//   }
//
//   void _askSequentialQuestionWithTyping(Questions question) {
//     // إضافة مؤشر الكتابة
//     setState(() {
//       _messages.add(
//         ChatMessage(
//           text: '',
//           isBot: true,
//           isTyping: true,
//         ),
//       );
//     });
//     _scrollToBottom();
//
//     // إزالة مؤشر الكتابة وإضافة السؤال
//     Future.delayed(Duration(milliseconds: 1500), () {
//       setState(() {
//         _messages.removeWhere((message) => message.isTyping);
//         _messages.add(
//           ChatMessage(
//             text: '${question.followUpQuestion} $_currentSequentialIndex؟',
//             isBot: true,
//           ),
//         );
//       });
//       _scrollToBottom();
//     });
//   }
//
//   void _askSequentialQuestion(Questions question) {
//     setState(() {
//       _messages.add(
//         ChatMessage(
//           text: '${question.followUpQuestion} $_currentSequentialIndex؟',
//           isBot: true,
//         ),
//       );
//     });
//     _scrollToBottom();
//   }
//
//   void _processAnswer(Answer answer, String displayText) {
//     setState(() {
//       _answers.add(answer);
//       _messages.add(ChatMessage(text: displayText, isBot: false));
//       _currentQuestionIndex++;
//     });
//
//     _textController.clear();
//     _scrollToBottom();
//
//     if (_currentQuestionIndex < _questions.length) {
//       _showTypingAndMessage('شكراً لك! السؤال التالي:', () {
//         _askNextQuestion();
//       });
//     } else {
//       _showResults();
//     }
//   }
//
//   void _showTypingAndMessage(String message, VoidCallback onComplete) {
//     // إضافة مؤشر الكتابة
//     setState(() {
//       _messages.add(
//         ChatMessage(
//           text: '',
//           isBot: true,
//           isTyping: true,
//         ),
//       );
//     });
//     _scrollToBottom();
//
//     // إزالة مؤشر الكتابة وإضافة الرسالة
//     Future.delayed(Duration(milliseconds: 1500), () {
//       setState(() {
//         _messages.removeWhere((message) => message.isTyping);
//         _messages.add(
//           ChatMessage(text: message, isBot: true),
//         );
//       });
//       _scrollToBottom();
//
//       Future.delayed(Duration(milliseconds: 300), onComplete);
//     });
//   }
//
//   void _showErrorMessage(String message) {
//     setState(() {
//       _messages.add(ChatMessage(text: message, isBot: true));
//     });
//     _scrollToBottom();
//   }
//
//   void _showResults() {
//     _showTypingAndMessage('شكراً لك! لقد انتهينا من جميع الأسئلة. إليك ملخص إجاباتك:', () {
//       String summary = '';
//       for (int i = 0; i < _questions.length; i++) {
//         final question = _questions[i];
//         final answer = _answers.firstWhere((a) => a.questionId == question.id);
//
//         summary += '${i + 1}. ${question.question}\n';
//
//         switch (question.type) {
//           case QuestionType.text:
//             summary += 'الإجابة: ${answer.textAnswer}\n\n';
//             break;
//           case QuestionType.singleChoice:
//             summary += 'الإجابة: ${answer.selectedOption}\n\n';
//             break;
//           case QuestionType.multipleChoice:
//             summary += 'الإجابات: ${answer.selectedOptions?.join(', ')}\n\n';
//             break;
//           case QuestionType.sequential:
//             if (answer.sequentialAnswers?.isEmpty ?? true) {
//               summary += 'الإجابة: لا يوجد\n\n';
//             } else {
//               summary += 'الإجابات:\n';
//               for (int j = 0; j < answer.sequentialAnswers!.length; j++) {
//                 summary += '${j + 1}. ${answer.sequentialAnswers![j]}\n';
//               }
//               summary += '\n';
//             }
//             break;
//         }
//       }
//
//       Future.delayed(Duration(milliseconds: 500), () {
//         setState(() {
//           _messages.add(ChatMessage(text: summary, isBot: true));
//         });
//         _scrollToBottom();
//       });
//     });
//   }
//
//   void _scrollToBottom() {
//     Future.delayed(Duration(milliseconds: 100), () {
//       if (_scrollController.hasClients) {
//         _scrollController.animateTo(
//           _scrollController.position.maxScrollExtent,
//           duration: Duration(milliseconds: 300),
//           curve: Curves.easeOut,
//         );
//       }
//     });
//   }
//
//   Widget _buildMessageBubble(ChatMessage message) {
//     return Container(
//       margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
//       child: Column(
//         crossAxisAlignment: message.isBot
//             ? CrossAxisAlignment.start
//             : CrossAxisAlignment.end,
//         children: [
//           Row(
//             mainAxisAlignment: message.isBot
//                 ? MainAxisAlignment.start
//                 : MainAxisAlignment.end,
//             children: [
//               if (message.isBot)
//                 CircleAvatar(
//                   radius: 16,
//                   backgroundImage: CachedNetworkImageProvider(
//                     'https://artawiya.com//DigitalArtawiya/image.jpeg',
//                   ),
//                 ),
//               SizedBox(width: 8),
//               Flexible(
//                 child: Container(
//                   padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//                   constraints: BoxConstraints(
//                     maxWidth: MediaQuery.of(context).size.width * 0.75,
//                   ),
//                   decoration: BoxDecoration(
//                     color: message.isBot
//                         ? ColorManager.chatUserBg
//                         : ColorManager.chatAssistantText,
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(16),
//                       bottomLeft: message.isBot
//                           ? Radius.circular(4)
//                           : Radius.circular(16),
//                       bottomRight: Radius.circular(16),
//                       topRight: message.isBot
//                           ? Radius.circular(16)
//                           : Radius.circular(4),
//                     ),
//                   ),
//                   child: message.isTyping
//                       ? TypingIndicator()
//                       : Text(
//                     message.text,
//                     style: TextStyle(
//                       color: message.isBot ? Colors.white : Colors.white,
//                       fontSize: 16,
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(width: 8),
//               if (!message.isBot)
//                 CircleAvatar(
//                   radius: 16,
//                   backgroundImage: CachedNetworkImageProvider(
//                     'https://www.georgetown.edu/wp-content/uploads/2022/02/Jkramerheadshot-scaled-e1645036825432-1050x1050-c-default.jpg',
//                   ),
//                 ),
//             ],
//           ),
//           // إضافة الاختيارات تحت السؤال
//           if (message.isBot && message.question != null && !message.isTyping)
//             _buildQuestionOptions(message.question!),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildQuestionOptions(Questions question) {
//     if (question.type == QuestionType.singleChoice) {
//       return Container(
//         margin: EdgeInsets.only(top: 10, right: 40),
//         child: Wrap(
//           children: question.options!
//               .map(
//                 (option) => Container(
//               margin: EdgeInsets.symmetric(vertical: 2),
//               child: InkWell(
//                 onTap: () {
//                   setState(() {
//                     _currentSingleChoice = option;
//                   });
//                 },
//                 child: Container(
//                   padding: EdgeInsets.symmetric(
//                     horizontal: 16,
//                     vertical: 8,
//                   ),
//                   decoration: BoxDecoration(
//                     color: _currentSingleChoice == option
//                         ? Colors.blue.withOpacity(0.1)
//                         : Colors.grey[100],
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(
//                       color: _currentSingleChoice == option
//                           ? Colors.blue
//                           : Colors.grey[300]!,
//                     ),
//                   ),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Icon(
//                         _currentSingleChoice == option
//                             ? Icons.radio_button_checked
//                             : Icons.radio_button_unchecked,
//                         color: _currentSingleChoice == option
//                             ? Colors.blue
//                             : Colors.grey,
//                         size: 20,
//                       ),
//                       SizedBox(width: 8),
//                       Text(
//                         option,
//                         style: TextStyle(
//                           color: _currentSingleChoice == option
//                               ? Colors.blue
//                               : Colors.black87,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           )
//               .toList(),
//         ),
//       );
//     } else if (question.type == QuestionType.multipleChoice) {
//       return Container(
//         margin: EdgeInsets.only(top: 10, right: 40),
//         child: Column(
//           children: question.options!
//               .map(
//                 (option) => Container(
//               margin: EdgeInsets.symmetric(vertical: 2),
//               child: InkWell(
//                 onTap: () {
//                   setState(() {
//                     if (_currentMultipleChoices.contains(option)) {
//                       _currentMultipleChoices.remove(option);
//                     } else {
//                       _currentMultipleChoices.add(option);
//                     }
//                   });
//                 },
//                 child: Container(
//                   padding: EdgeInsets.symmetric(
//                     horizontal: 16,
//                     vertical: 8,
//                   ),
//                   decoration: BoxDecoration(
//                     color: _currentMultipleChoices.contains(option)
//                         ? Colors.blue.withOpacity(0.1)
//                         : Colors.grey[100],
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(
//                       color: _currentMultipleChoices.contains(option)
//                           ? Colors.blue
//                           : Colors.grey[300]!,
//                     ),
//                   ),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Icon(
//                         _currentMultipleChoices.contains(option)
//                             ? Icons.check_box
//                             : Icons.check_box_outline_blank,
//                         color: _currentMultipleChoices.contains(option)
//                             ? Colors.blue
//                             : Colors.grey,
//                         size: 20,
//                       ),
//                       SizedBox(width: 8),
//                       Text(
//                         option,
//                         style: TextStyle(
//                           color: _currentMultipleChoices.contains(option)
//                               ? Colors.blue
//                               : Colors.black87,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           )
//               .toList(),
//         ),
//       );
//     }
//     return SizedBox.shrink();
//   }
//
//   Widget _buildInputArea() {
//     if (_currentQuestionIndex >= _questions.length) return SizedBox.shrink();
//
//     final currentQuestion = _questions[_currentQuestionIndex];
//
//     return Container(
//       padding: EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             offset: Offset(0, -2),
//             blurRadius: 4,
//             color: Colors.black12,
//           ),
//         ],
//       ),
//       child: _buildInputWidget(currentQuestion),
//     );
//   }
//
//   Widget _buildInputWidget(Questions question) {
//     if (question.type == QuestionType.text ||
//         (question.type == QuestionType.sequential)) {
//       return Row(
//         children: [
//           Expanded(
//             child: TextField(
//               controller: _textController,
//               keyboardType:
//               question.type == QuestionType.sequential &&
//                   !_isInSequentialMode
//                   ? TextInputType.number
//                   : TextInputType.text,
//               onChanged: (value) {
//                 _currentTextAnswer = value;
//               },
//               decoration: InputDecoration(
//                 hintText: "Type your message...",
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(25.0),
//                   borderSide: BorderSide(color: ColorManager.inputBorder),
//                 ),
//                 enabledBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(25.0),
//                   borderSide: BorderSide(
//                     color: ColorManager.inputBorder.withOpacity(0.7),
//                   ),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(25.0),
//                   borderSide: BorderSide(
//                     color: ColorManager.chatUserBg.withOpacity(0.5),
//                     width: 1.5,
//                   ),
//                 ),
//                 contentPadding: const EdgeInsets.symmetric(
//                   horizontal: 18.0,
//                   vertical: 12.0,
//                 ),
//                 filled: true,
//                 fillColor: const Color(0xFFF9F9F9),
//               ),
//               minLines: 1,
//               maxLines: 5,
//               onSubmitted: (_) => _submitAnswer(),
//             ),
//           ),
//           const SizedBox(width: 8),
//           Container(
//             decoration: const BoxDecoration(
//               color: ColorManager.primaryColor,
//               shape: BoxShape.circle,
//             ),
//             child: IconButton(
//               icon: const Icon(
//                 Icons.send_rounded,
//                 color: Colors.white,
//                 size: 22,
//               ),
//               onPressed: () {
//                 _submitAnswer();
//               },
//             ),
//           ),
//         ],
//       );
//     } else if (question.type == QuestionType.singleChoice) {
//       return ElevatedButton(
//         onPressed: _currentSingleChoice != null ? _submitAnswer : null,
//         style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 45)),
//         child: Text('إرسال'),
//       );
//     } else if (question.type == QuestionType.multipleChoice) {
//       return ElevatedButton(
//         onPressed: _currentMultipleChoices.isNotEmpty ? _submitAnswer : null,
//         style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 45)),
//         child: Text('إرسال'),
//       );
//     }
//
//     return SizedBox.shrink();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider.value(
//   value: viewModel,
//   child: BlocListener<ChatBotAssistantCubit, ChatBotAssistantState>(
//   listener: (context, state) {
//  if (state is ChatBotAssistantSuccess) {
//       setState(() {
//         _questions.clear();
//       _questions.addAll(state.questionsEntity?.questions??[]);
//       });
//     }
//   },
//   child: Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         title: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text("StoryGuide Assistant"),
//             Text(
//               "Finding the perfect stories for your child",
//               style: TextStyle(
//                 fontSize: 12,
//                 color: Colors.grey[600],
//                 fontWeight: FontWeight.normal,
//               ),
//             ),
//           ],
//         ),
//         centerTitle: false,
//       ),
//       body: Column(
//         children: [
//           Divider(height: 1, color: Colors.grey[300]),
//           Expanded(
//             child: ListView.builder(
//               controller: _scrollController,
//               itemCount: _messages.length,
//               itemBuilder: (context, index) {
//                 return _buildMessageBubble(_messages[index]);
//               },
//             ),
//           ),
//           _buildInputArea(),
//         ],
//       ),
//     ),
// ),
// );
//   }
//
//   @override
//   void dispose() {
//     _textController.dispose();
//     _scrollController.dispose();
//     super.dispose();
//   }
// }
//
//
