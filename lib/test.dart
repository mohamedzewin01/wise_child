// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:wise_child/core/resources/color_manager.dart';
//
//
//
// enum QuestionType { text, singleChoice, multipleChoice, sequential }
//
// class Question {
//   final String id;
//   final String question;
//   final QuestionType type;
//   final List<String>? options;
//   final String? followUpQuestion; // للأسئلة المتسلسلة
//   final String? countPrompt; // النص الذي يطلب العدد
//
//   Question({
//     required this.id,
//     required this.question,
//     required this.type,
//     this.options,
//     this.followUpQuestion,
//     this.countPrompt,
//   });
// }
//
// class Answer {
//   final String questionId;
//   final String? textAnswer;
//   final String? selectedOption;
//   final List<String>? selectedOptions;
//   final List<String>? sequentialAnswers; // للأسئلة المتسلسلة
//
//   Answer({
//     required this.questionId,
//     this.textAnswer,
//     this.selectedOption,
//     this.selectedOptions,
//     this.sequentialAnswers,
//   });
// }
//
// class ChatMessage {
//   final String text;
//   final bool isBot;
//   final Question? question;
//
//   ChatMessage({
//     required this.text,
//     required this.isBot,
//     this.question,
//   });
// }
//
// class ChatBotAssistantScreen extends StatefulWidget {
//   const ChatBotAssistantScreen({super.key});
//
//   @override
//   State<ChatBotAssistantScreen> createState() => _ChatBotAssistantScreenState();
// }
//
// class _ChatBotAssistantScreenState extends State<ChatBotAssistantScreen> {
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
//   final List<Question> _questions = [
//     Question(
//       id: 'q1',
//       question: 'ما اسمك؟',
//       type: QuestionType.text,
//     ),
//     Question(
//       id: 'q2',
//       question: 'ما هو عمرك؟',
//       type: QuestionType.singleChoice,
//       options: ['أقل من 18', '18-25', '26-35', '36-50', 'أكثر من 50'],
//     ),
//     Question(
//       id: 'q3',
//       question: 'كم أخ لك؟',
//       type: QuestionType.sequential,
//       followUpQuestion: 'ما اسم الأخ رقم',
//       countPrompt: 'اكتب العدد',
//     ),
//     Question(
//       id: 'q4',
//       question: 'كم أخت لك؟',
//       type: QuestionType.sequential,
//       followUpQuestion: 'ما اسم الأخت رقم',
//       countPrompt: 'اكتب العدد',
//     ),
//     Question(
//       id: 'q6',
//       question: 'كم عم لك؟',
//       type: QuestionType.sequential,
//       followUpQuestion: 'ما اسم عم رقم',
//       countPrompt: 'اكتب العدد',
//     ),
//     Question(
//       id: 'q5',
//       question: 'ما هي هواياتك المفضلة؟ (يمكنك اختيار أكثر من إجابة)',
//       type: QuestionType.multipleChoice,
//       options: ['القراءة', 'الرياضة', 'الموسيقى', 'السفر', 'الطبخ', 'الألعاب'],
//     ),
//     Question(
//       id: 'q6',
//       question: 'كم مادة تدرسها في الجامعة؟',
//       type: QuestionType.sequential,
//       followUpQuestion: 'ما اسم المادة رقم',
//       countPrompt: 'اكتب عدد المواد',
//     ),
//     Question(
//       id: 'q7',
//       question: 'ما هو لونك المفضل؟',
//       type: QuestionType.singleChoice,
//       options: ['أحمر', 'أزرق', 'أخضر', 'أصفر', 'أسود', 'أبيض'],
//     ),
//     Question(
//       id: 'q8',
//       question: 'صف لنا يومك المثالي؟',
//       type: QuestionType.text,
//     ),
//   ];
//
//   // متغيرات للإجابات الحالية
//   String _currentTextAnswer = '';
//   String? _currentSingleChoice;
//   List<String> _currentMultipleChoices = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _startChat();
//   }
//
//   void _startChat() {
//     setState(() {
//       _messages.add(ChatMessage(
//         text: 'أهلاً وسهلاً! سأقوم بطرح بعض الأسئلة عليك. دعنا نبدأ!',
//         isBot: true,
//       ));
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
//       setState(() {
//         _messages.add(ChatMessage(
//           text: question.question,
//           isBot: true,
//           question: question,
//         ));
//
//         // إعادة تعيين الإجابات الحالية
//         _currentTextAnswer = '';
//         _currentSingleChoice = null;
//         _currentMultipleChoices.clear();
//
//         // إعداد الأسئلة المتسلسلة
//         if (question.type == QuestionType.sequential) {
//           _isInSequentialMode = false;
//           _sequentialCount = 0;
//           _currentSequentialIndex = 0;
//           _sequentialAnswers.clear();
//           _sequentialPrompt = question.followUpQuestion ?? '';
//         }
//       });
//       _scrollToBottom();
//     } else {
//       _showResults();
//     }
//   }
//
//   void _submitAnswer() {
//     final currentQuestion = _questions[_currentQuestionIndex];
//
//     // التعامل مع الأسئلة المتسلسلة
//     if (currentQuestion.type == QuestionType.sequential) {
//       _handleSequentialAnswer(currentQuestion);
//       return;
//     }
//     Answer answer;
//     String displayText = '';
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
//         return; // يتم التعامل معه في _handleSequentialAnswer
//     }
//
//     _processAnswer(answer, displayText);
//   }
//
//   void _handleSequentialAnswer(Question question) {
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
//         _messages.add(ChatMessage(
//           text: countText,
//           isBot: false,
//         ));
//       });
//
//       _textController.clear();
//       _currentTextAnswer = '';
//       _scrollToBottom();
//
//       if (count == 0) {
//         // إذا كان العدد صفر، ننتقل للسؤال التالي
//         final answer = Answer(
//           questionId: question.id,
//           sequentialAnswers: [],
//         );
//         _processAnswer(answer, 'لا يوجد');
//         return;
//       }
//
//       // طرح السؤال الأول من السلسلة
//       Future.delayed(Duration(milliseconds: 500), () {
//         _askSequentialQuestion(question);
//       });
//     } else {
//       // إجابة على أحد الأسئلة المتسلسلة
//       if (_currentTextAnswer.trim().isEmpty) return;
//
//       setState(() {
//         _sequentialAnswers.add(_currentTextAnswer.trim());
//         _messages.add(ChatMessage(
//           text: _currentTextAnswer.trim(),
//           isBot: false,
//         ));
//         _currentSequentialIndex++;
//       });
//
//       _textController.clear();
//       _currentTextAnswer = '';
//       _scrollToBottom();
//
//       if (_currentSequentialIndex <= _sequentialCount) {
//         // طرح السؤال التالي
//         Future.delayed(Duration(milliseconds: 500), () {
//           _askSequentialQuestion(question);
//         });
//       } else {
//         // انتهينا من جميع الأسئلة المتسلسلة
//         final answer = Answer(
//           questionId: question.id,
//           sequentialAnswers: List.from(_sequentialAnswers),
//         );
//
//         Future.delayed(Duration(milliseconds: 500), () {
//           setState(() {
//             _messages.add(ChatMessage(
//               text: 'شكراً لك! السؤال التالي:',
//               isBot: true,
//             ));
//           });
//
//           _answers.add(answer);
//           _currentQuestionIndex++;
//           _isInSequentialMode = false;
//
//           Future.delayed(Duration(milliseconds: 300), () {
//             _askNextQuestion();
//           });
//         });
//       }
//     }
//   }
//
//   void _askSequentialQuestion(Question question) {
//     setState(() {
//       _messages.add(ChatMessage(
//         text: '${question.followUpQuestion} $_currentSequentialIndex؟',
//         isBot: true,
//       ));
//     });
//     _scrollToBottom();
//   }
//
//   void _processAnswer(Answer answer, String displayText) {
//     setState(() {
//       _answers.add(answer);
//       _messages.add(ChatMessage(
//         text: displayText,
//         isBot: false,
//       ));
//       _currentQuestionIndex++;
//     });
//
//     _textController.clear();
//     _scrollToBottom();
//
//     Future.delayed(Duration(milliseconds: 500), () {
//       if (_currentQuestionIndex < _questions.length) {
//         setState(() {
//           _messages.add(ChatMessage(
//             text: 'شكراً لك! السؤال التالي:',
//             isBot: true,
//           ));
//         });
//         Future.delayed(Duration(milliseconds: 300), () {
//           _askNextQuestion();
//         });
//       } else {
//         _showResults();
//       }
//     });
//   }
//
//   void _showErrorMessage(String message) {
//     setState(() {
//       _messages.add(ChatMessage(
//         text: message,
//         isBot: true,
//       ));
//     });
//     _scrollToBottom();
//   }
//
//   void _showResults() {
//     setState(() {
//       _messages.add(ChatMessage(
//         text: 'شكراً لك! لقد انتهينا من جميع الأسئلة. إليك ملخص إجاباتك:',
//         isBot: true,
//       ));
//     });
//
//     String summary = '';
//     for (int i = 0; i < _questions.length; i++) {
//       final question = _questions[i];
//       final answer = _answers.firstWhere((a) => a.questionId == question.id);
//
//       summary += '${i + 1}. ${question.question}\n';
//
//       switch (question.type) {
//         case QuestionType.text:
//           summary += 'الإجابة: ${answer.textAnswer}\n\n';
//           break;
//         case QuestionType.singleChoice:
//           summary += 'الإجابة: ${answer.selectedOption}\n\n';
//           break;
//         case QuestionType.multipleChoice:
//           summary += 'الإجابات: ${answer.selectedOptions?.join(', ')}\n\n';
//           break;
//         case QuestionType.sequential:
//           if (answer.sequentialAnswers?.isEmpty ?? true) {
//             summary += 'الإجابة: لا يوجد\n\n';
//           } else {
//             summary += 'الإجابات:\n';
//             for (int j = 0; j < answer.sequentialAnswers!.length; j++) {
//               summary += '${j + 1}. ${answer.sequentialAnswers![j]}\n';
//             }
//             summary += '\n';
//           }
//           break;
//       }
//     }
//
//     Future.delayed(Duration(milliseconds: 500), () {
//       setState(() {
//         _messages.add(ChatMessage(
//           text: summary,
//           isBot: true,
//         ));
//       });
//       _scrollToBottom();
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
//                 Padding(
//                   padding: const EdgeInsets.only(right: 8.0),
//                   child: CircleAvatar(
//                     radius: 16,
//                     backgroundImage: CachedNetworkImageProvider(
//                       'https://artawiya.com//DigitalArtawiya/image.jpeg',
//                     ), // Placeholder, use actual image
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
//                     color: message.isBot ?    ColorManager.chatUserBg
//                     : ColorManager.chatAssistantText,
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(16),
//                       bottomLeft: message.isBot ? Radius.circular(4) : Radius.circular(
//                         16,
//                       ),
//                       bottomRight: Radius.circular(16),
//                       topRight: message.isBot ? Radius.circular(16) : Radius.circular(
//                         4,
//                       ), // Slightly different for "tail" effect
//                     ),
//                   ),
//                   child: Text(
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
//                 Padding(
//                   padding: const EdgeInsets.only(left: 8.0),
//                   child: CircleAvatar(
//                     radius: 16,
//                     backgroundImage: CachedNetworkImageProvider(
//                       'https://www.georgetown.edu/wp-content/uploads/2022/02/Jkramerheadshot-scaled-e1645036825432-1050x1050-c-default.jpg',
//                     ), // Placeholder, use actual image
//                   ),
//                 ),
//             ],
//           ),
//           // إضافة الاختيارات تحت السؤال
//           if (message.isBot && message.question != null)
//             _buildQuestionOptions(message.question!),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildQuestionOptions(Question question) {
//     if (question.type == QuestionType.singleChoice) {
//       return Container(
//         margin: EdgeInsets.only(top: 10, right: 40),
//         child: Wrap(
//           children: question.options!.map((option) =>
//               Container(
//                 margin: EdgeInsets.symmetric(vertical: 2),
//                 child: InkWell(
//                   onTap: () {
//                     setState(() {
//                       _currentSingleChoice = option;
//                     });
//                   },
//                   child: Container(
//                     padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                     decoration: BoxDecoration(
//                       color: _currentSingleChoice == option
//                           ? Colors.blue.withOpacity(0.1)
//                           : Colors.grey[100],
//                       borderRadius: BorderRadius.circular(12),
//                       border: Border.all(
//                         color: _currentSingleChoice == option
//                             ? Colors.blue
//                             : Colors.grey[300]!,
//                       ),
//                     ),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Icon(
//                           _currentSingleChoice == option
//                               ? Icons.radio_button_checked
//                               : Icons.radio_button_unchecked,
//                           color: _currentSingleChoice == option
//                               ? Colors.blue
//                               : Colors.grey,
//                           size: 20,
//                         ),
//                         SizedBox(width: 8),
//                         Text(
//                           option,
//                           style: TextStyle(
//                             color: _currentSingleChoice == option
//                                 ? Colors.blue
//                                 : Colors.black87,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//           ).toList(),
//         ),
//       );
//     } else if (question.type == QuestionType.multipleChoice) {
//       return Container(
//         margin: EdgeInsets.only(top: 10, right: 40),
//         child: Column(
//           children: question.options!.map((option) =>
//               Container(
//                 margin: EdgeInsets.symmetric(vertical: 2),
//                 child: InkWell(
//                   onTap: () {
//                     setState(() {
//                       if (_currentMultipleChoices.contains(option)) {
//                         _currentMultipleChoices.remove(option);
//                       } else {
//                         _currentMultipleChoices.add(option);
//                       }
//                     });
//                   },
//                   child: Container(
//                     padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                     decoration: BoxDecoration(
//                       color: _currentMultipleChoices.contains(option)
//                           ? Colors.blue.withOpacity(0.1)
//                           : Colors.grey[100],
//                       borderRadius: BorderRadius.circular(12),
//                       border: Border.all(
//                         color: _currentMultipleChoices.contains(option)
//                             ? Colors.blue
//                             : Colors.grey[300]!,
//                       ),
//                     ),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Icon(
//                           _currentMultipleChoices.contains(option)
//                               ? Icons.check_box
//                               : Icons.check_box_outline_blank,
//                           color: _currentMultipleChoices.contains(option)
//                               ? Colors.blue
//                               : Colors.grey,
//                           size: 20,
//                         ),
//                         SizedBox(width: 8),
//                         Text(
//                           option,
//                           style: TextStyle(
//                             color: _currentMultipleChoices.contains(option)
//                                 ? Colors.blue
//                                 : Colors.black87,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//           ).toList(),
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
//   Widget _buildInputWidget(Question question) {
//     if (question.type == QuestionType.text ||
//         (question.type == QuestionType.sequential)) {
//       return Row(
//         children: [
//           Expanded(
//             child: TextField(
//               controller: _textController,
//               onChanged: (value) {
//                 _currentTextAnswer = value;
//               },
//               decoration: InputDecoration(
//                 hintText: question.type == QuestionType.sequential && !_isInSequentialMode
//                     ? question.countPrompt ?? 'اكتب العدد'
//                     : 'اكتب إجابتك هنا...',
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(25),
//                 ),
//                 contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//               ),
//               textDirection: TextDirection.rtl,
//               keyboardType: question.type == QuestionType.sequential && !_isInSequentialMode
//                   ? TextInputType.number
//                   : TextInputType.text,
//             ),
//           ),
//           SizedBox(width: 8),
//           FloatingActionButton(
//             onPressed: _submitAnswer,
//             child: Icon(Icons.send),
//             mini: true,
//           ),
//         ],
//       );
//     } else if (question.type == QuestionType.singleChoice) {
//       return ElevatedButton(
//         onPressed: _currentSingleChoice != null ? _submitAnswer : null,
//         child: Text('إرسال'),
//         style: ElevatedButton.styleFrom(
//           minimumSize: Size(double.infinity, 45),
//         ),
//       );
//     } else if (question.type == QuestionType.multipleChoice) {
//       return ElevatedButton(
//         onPressed: _currentMultipleChoices.isNotEmpty ? _submitAnswer : null,
//         child: Text('إرسال'),
//         style: ElevatedButton.styleFrom(
//           minimumSize: Size(double.infinity, 45),
//         ),
//       );
//     }
//
//     return SizedBox.shrink();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('شات بوت الأسئلة'),
//         backgroundColor: Colors.blue,
//         foregroundColor: Colors.white,
//       ),
//       body: Column(
//         children: [
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
//     );
//   }
//
//   @override
//   void dispose() {
//     _textController.dispose();
//     _scrollController.dispose();
//     super.dispose();
//   }
// }