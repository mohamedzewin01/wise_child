// import 'dart:async';
//
// import 'package:flutter/material.dart';
//
// void main() => runApp(ChatBotApp());
//
// class ChatBotApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Multiple Question ChatBot',
//       home: ChatBotPage(),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }
//
// class ChatBotPage extends StatefulWidget {
//   const ChatBotPage({super.key});
//
//   @override
//   _ChatBotPageState createState() => _ChatBotPageState();
// }
//
// class _ChatBotPageState extends State<ChatBotPage> {
//   final List<String> questions = ["ما اسمك؟", "كم عمرك؟", "ما هي وظيفتك؟"];
//
//   List<String> messages = [];
//   int currentQuestionIndex = 0;
//   final TextEditingController _controller = TextEditingController();
//   final ScrollController _scrollController = ScrollController();
//   bool allQuestionsAnswered = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _askNextQuestion();
//   }
//
//   void _askNextQuestion() {
//     setState(() {});
//     if (currentQuestionIndex < questions.length) {
//       messages.add("البوت: ${questions[currentQuestionIndex]}");
//     } else {
//       allQuestionsAnswered = true;
//       messages.add("البوت: شكرًا لإجاباتك! ✅");
//     }
//     Timer(Duration(seconds: 4), () {
//       if (_scrollController.hasClients) {
//         _scrollController.animateTo(
//           _scrollController.position.maxScrollExtent,
//           duration: const Duration(milliseconds: 300),
//           curve: Curves.easeOut,
//         );
//       }
//     });
//   }
//
//   void _sendMessage() {
//     String userMessage = _controller.text.trim();
//     if (userMessage.isEmpty) return;
//
//     setState(() {
//       messages.add("أنت: $userMessage");
//       _controller.clear();
//       currentQuestionIndex++;
//     });
//
//     Future.delayed(Duration(milliseconds: 500), _askNextQuestion);
//   }
//
//   void _finish() {
//     ScaffoldMessenger.of(
//       context,
//     ).showSnackBar(SnackBar(content: Text("تم إنهاء المحادثة 👋")));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('شات بوت متعدد الأسئلة')),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               controller: _scrollController,
//               padding: const EdgeInsets.all(8),
//               itemCount: messages.length,
//               itemBuilder: (context, index) {
//                 return Container(
//                   margin: const EdgeInsets.symmetric(vertical: 4),
//                   child: Text(messages[index]),
//                 );
//               },
//             ),
//           ),
//           Divider(height: 1),
//           if (!allQuestionsAnswered)
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: TextField(
//                       controller: _controller,
//                       decoration: InputDecoration(hintText: "اكتب هنا..."),
//                       onSubmitted: (_) => _sendMessage(),
//                     ),
//                   ),
//                   IconButton(icon: Icon(Icons.send), onPressed: _sendMessage),
//                 ],
//               ),
//             )
//           else
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: ElevatedButton(onPressed: _finish, child: Text("متابعة")),
//             ),
//         ],
//       ),
//     );
//   }
// }
