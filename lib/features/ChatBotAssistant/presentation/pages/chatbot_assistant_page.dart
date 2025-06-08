// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:wise_child/features/ChatBotAssistant/presentation/widgets/chat_widgets.dart';
// import '../../../../core/di/di.dart';
// import '../bloc/ChatBotAssistant_cubit.dart';
//
// import '../bloc/chat_cubit/chat_cubit.dart';
//
// import '../widgets/chat_controller.dart';
//
//
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
//   late ChatController _chatController;
//   final TextEditingController _textController = TextEditingController();
//
//   // متغيرات الإجابات الحالية
//   String? _currentSingleChoice;
//   List<String> _currentMultipleChoices = [];
//
//   @override
//   void initState() {
//     _chatController = ChatController();
//
//     viewModel = getIt.get<ChatBotAssistantCubit>();
//     viewModel.getQuestions();
//
//     _startChat();
//     super.initState();
//   }
//
//
//   void _startChat() {
//     setState(() {
//       _chatController.startChat();
//     });
//
//     Future.delayed(Duration(milliseconds: 500), () {
//       _chatController.askNextQuestion();
//       setState(() {});
//       _chatController.scrollToBottom();
//     });
//   }
//
//
//   void _submitAnswer() {
//     final success = _chatController.submitAnswer(
//       _currentSingleChoice,
//       _currentMultipleChoices,
//     );
//
//     if (success) {
//       setState(() {
//         _currentSingleChoice = null;
//         _currentMultipleChoices.clear();
//       });
//       _textController.clear();
//       _chatController.scrollToBottom();
//     }
//   }
//
//   void _onSingleChoiceChanged(String? choice) {
//     setState(() {
//       _currentSingleChoice = choice;
//     });
//   }
//
//   void _onMultipleChoiceToggle(String choice) {
//     setState(() {
//       if (_currentMultipleChoices.contains(choice)) {
//         _currentMultipleChoices.remove(choice);
//       } else {
//         _currentMultipleChoices.add(choice);
//       }
//     });
//   }
//
//   void _onTextChanged(String value) {
//     _chatController.setCurrentTextAnswer(value);
//   }
//
//   Widget _buildInputArea() {
//     if (_chatController.currentQuestionIndex >=
//         _chatController.questions.length) {
//       return SizedBox.shrink();
//     }
//
//     final currentQuestion = _chatController.questions[_chatController
//         .currentQuestionIndex];
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
//       child: ChatWidgets.buildInputWidget(
//         context,
//         currentQuestion,
//         _textController,
//         _currentSingleChoice,
//         _currentMultipleChoices,
//         _chatController.isInSequentialMode,
//         _onTextChanged,
//         _submitAnswer,
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider.value(
//           value: viewModel,
//         ),
//         BlocProvider(
//           create: (context) => ChatCubit(),
//         ),
//       ],
//       child: BlocListener<ChatBotAssistantCubit, ChatBotAssistantState>(
//         listener: (context, state) {
//           if (state is ChatBotAssistantSuccess) {
//             setState(() {
//               _chatController.setQuestions(
//                   state.questionsEntity?.questions ?? []);
//               _chatController.askNextQuestion();
//             });
//           }
//         },
//
//         child: Scaffold(
//           appBar: AppBar(
//             automaticallyImplyLeading: false,
//             title: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text("StoryGuide Assistant"),
//                 Text(
//                   "Finding the perfect stories for your child",
//                   style: TextStyle(
//                     fontSize: 12,
//                     color: Colors.grey[600],
//                     fontWeight: FontWeight.normal,
//                   ),
//                 ),
//               ],
//             ),
//             centerTitle: false,
//           ),
//           body: Column(
//             children: [
//               Divider(height: 1, color: Colors.grey[300]),
//               Expanded(
//                 child: BlocBuilder<ChatCubit, ChatState>(
//                   builder: (context, state) {
//
//                     return ListView.builder(
//                       controller: _chatController.scrollController,
//                       itemCount: _chatController.messages.length,
//                       itemBuilder: (context, index) {
//                         return ChatWidgets.buildMessageBubble(
//                           context,
//                           _chatController.messages[index],
//                           _currentSingleChoice,
//                           _currentMultipleChoices,
//                           _onSingleChoiceChanged,
//                           _onMultipleChoiceToggle,
//
//                         );
//                       },
//                     );
//                   },
//                 ),
//               ),
//               _buildInputArea(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//
//   @override
//   void dispose() {
//     _textController.dispose();
//     _chatController.dispose();
//     super.dispose();
//   }
// }