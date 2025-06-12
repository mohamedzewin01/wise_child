import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wise_child/features/AddChildren/presentation/bloc/cubit_bot/chatbot_state.dart';
import '../bloc/cubit_bot/chatbot_cubit.dart';


// 1. تحويل الويدجت إلى StatefulWidget
class AddChildChatbotScreen extends StatefulWidget {
  const AddChildChatbotScreen({super.key});

  @override
  State<AddChildChatbotScreen> createState() => _AddChildChatbotScreenState();
}

class _AddChildChatbotScreenState extends State<AddChildChatbotScreen> {
  // 2. إنشاء الـ Cubit كمتغير في الحالة
  late final ChatbotCubit _chatbotCubit;
  final _textController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // 3. تهيئة الـ Cubit واستدعاء startConversation هنا!
    _chatbotCubit = ChatbotCubit();
    _chatbotCubit.startConversation();
  }

  @override
  void dispose() {
    // 4. لا تنسَ إغلاق الـ Cubit والـ Controllers لتجنب تسريب الذاكرة
    _chatbotCubit.close();
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // دالة لتمرير الشاشة للأسفل
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("إنشاء ملف تعريف عبر المحادثة")),
      // 5. استخدام BlocProvider.value لتوفير الـ Cubit الذي أنشأناه
      body: BlocProvider.value(
        value: _chatbotCubit,
        child: BlocConsumer<ChatbotCubit, ChatbotState>(
          listener: (context, state) {
            _scrollToBottom();
          },
          builder: (context, state) {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16.0),
                    itemCount: state.messages.length,
                    itemBuilder: (context, index) => state.messages[index],
                  ),
                ),
                if (state.isWaitingForTextInput)
                  _buildInputArea(context, _textController),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildInputArea(BuildContext context, TextEditingController controller) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 5)],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(hintText: "اكتب ردك هنا...", border: InputBorder.none),
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  // استخدام الـ Cubit الذي قمنا بتعريفه في الأعلى
                  _chatbotCubit.handleUserResponse(value);
                  controller.clear();
                }
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              if (controller.text.isNotEmpty) {
                _chatbotCubit.handleUserResponse(controller.text);
                controller.clear();
              }
            },
          ),
        ],
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'dart:convert';
//
//
//
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
//
// class AddChildChatbotScreen extends StatefulWidget {
//   const AddChildChatbotScreen({super.key});
//
//   @override
//   _AddChildChatbotScreenState createState() => _AddChildChatbotScreenState();
// }
//
// class _AddChildChatbotScreenState extends State<AddChildChatbotScreen> {
//   final TextEditingController _messageController = TextEditingController();
//   final ScrollController _scrollController = ScrollController();
//   final ImagePicker _picker = ImagePicker();
//
//   List<Message> messages = [];
//   int currentStep = 0;
//
//   // بيانات الطفل
//   Map<String, dynamic> childData = {
//     "user_id": "",
//     "first_name": "",
//     "last_name": "",
//     "gender": "",
//     "date_of_birth": "",
//     "imageUrl": "",
//     "siblings": [],
//     "friends": []
//   };
//
//   List<Map<String, dynamic>> tempSiblings = [];
//   List<Map<String, dynamic>> tempFriends = [];
//   int siblingCount = 0;
//   int friendCount = 0;
//   int currentSiblingIndex = 0;
//   int currentFriendIndex = 0;
//   bool waitingForSpecialInput = false;
//   String specialInputType = "";
//
//   final List<String> questions = [
//     "مرحباً! سأساعدك في تسجيل بيانات الطفل. ما هو الاسم الأول؟",
//     "ما هو اسم العائلة؟",
//     "ما هو الجنس؟",
//     "ما هو تاريخ الميلاد؟",
//     "يرجى اختيار صورة للطفل",
//     "كم عدد الأشقاء؟",
//     "كم عدد الأصدقاء؟",
//   ];
//
//   @override
//   void initState() {
//     super.initState();
//     childData["user_id"] = _generateUserId();
//     _addBotMessage(questions[0]);
//   }
//
//   String _generateUserId() {
//     return DateTime.now().millisecondsSinceEpoch.toString() +
//         (1000 + (999 * (DateTime.now().millisecond / 1000))).round().toString();
//   }
//
//   void _addBotMessage(String text) {
//     setState(() {
//       messages.add(Message(text: text, isBot: true));
//     });
//     _scrollToBottom();
//   }
//
//   void _addUserMessage(String text) {
//     setState(() {
//       messages.add(Message(text: text, isBot: false));
//     });
//     _scrollToBottom();
//   }
//
//   void _addSpecialMessage(Widget widget) {
//     setState(() {
//       messages.add(Message(text: "", isBot: true, specialWidget: widget));
//     });
//     _scrollToBottom();
//   }
//
//   void _scrollToBottom() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
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
//   void _sendMessage() {
//     String message = _messageController.text.trim();
//     if (message.isEmpty) return;
//
//     _addUserMessage(message);
//     _messageController.clear();
//     _processUserResponse(message);
//   }
//
//   void _processUserResponse(String response) {
//     if (waitingForSpecialInput) return;
//
//     switch (currentStep) {
//       case 0: // الاسم الأول
//         childData["first_name"] = response;
//         currentStep++;
//         _addBotMessage(questions[1]);
//         break;
//
//       case 1: // اسم العائلة
//         childData["last_name"] = response;
//         currentStep++;
//         _showGenderSelection();
//         break;
//
//       case 2: // الجنس - يتم التعامل معه في _showGenderSelection
//         break;
//
//       case 3: // تاريخ الميلاد - يتم التعامل معه في _showDatePicker
//         break;
//
//       case 4: // الصورة - يتم التعامل معها في _showImagePicker
//         break;
//
//       case 5: // عدد الأشقاء
//         try {
//           siblingCount = int.parse(response);
//           if (siblingCount == 0) {
//             currentStep = 100; // الانتقال لسؤال الأصدقاء
//             _addBotMessage(questions[6]);
//           } else {
//             currentStep++;
//             _addBotMessage("ما هو اسم الشقيق رقم ${currentSiblingIndex + 1}؟");
//           }
//         } catch (e) {
//           _addBotMessage("يرجى إدخال رقم صحيح");
//         }
//         break;
//
//       case 6: // أسماء الأشقاء
//         if (tempSiblings.length <= currentSiblingIndex) {
//           tempSiblings.add({});
//         }
//         tempSiblings[currentSiblingIndex]["name"] = response;
//         _addBotMessage("ما هو عمر ${response}؟");
//         currentStep++;
//         break;
//
//       case 7: // أعمار الأشقاء
//         try {
//           int age = int.parse(response);
//           tempSiblings[currentSiblingIndex]["age"] = age;
//           _showSiblingGenderSelection(currentSiblingIndex);
//         } catch (e) {
//           _addBotMessage("يرجى إدخال رقم صحيح للعمر");
//         }
//         break;
//
//       case 8: // جنس الأشقاء - يتم التعامل معه في _showSiblingGenderSelection
//         break;
//
//       case 100: // عدد الأصدقاء
//         try {
//           friendCount = int.parse(response);
//           if (friendCount == 0) {
//             _finishDataCollection();
//           } else {
//             currentStep = 101;
//             _addBotMessage("ما هو اسم الصديق رقم ${currentFriendIndex + 1}؟");
//           }
//         } catch (e) {
//           _addBotMessage("يرجى إدخال رقم صحيح");
//         }
//         break;
//
//       case 101: // أسماء الأصدقاء
//         if (tempFriends.length <= currentFriendIndex) {
//           tempFriends.add({});
//         }
//         tempFriends[currentFriendIndex]["name"] = response;
//         _addBotMessage("ما هو عمر ${response}؟");
//         currentStep++;
//         break;
//
//       case 102: // أعمار الأصدقاء
//         try {
//           int age = int.parse(response);
//           tempFriends[currentFriendIndex]["age"] = age;
//           _showFriendGenderSelection(currentFriendIndex);
//         } catch (e) {
//           _addBotMessage("يرجى إدخال رقم صحيح للعمر");
//         }
//         break;
//
//       case 103: // جنس الأصدقاء - يتم التعامل معه في _showFriendGenderSelection
//         break;
//     }
//   }
//
//   void _showGenderSelection() {
//     waitingForSpecialInput = true;
//     specialInputType = "gender";
//     _addBotMessage("اختر الجنس:");
//
//     Widget genderButtons = Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: [
//         ElevatedButton.icon(
//           onPressed: () => _selectGender("male"),
//           icon: Icon(Icons.male, color: Colors.blue),
//           label: Text("ذكر"),
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.blue[100],
//             foregroundColor: Colors.blue[800],
//             padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//           ),
//         ),
//         ElevatedButton.icon(
//           onPressed: () => _selectGender("female"),
//           icon: Icon(Icons.female, color: Colors.pink),
//           label: Text("أنثى"),
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.pink[100],
//             foregroundColor: Colors.pink[800],
//             padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//           ),
//         ),
//       ],
//     );
//
//     _addSpecialMessage(genderButtons);
//   }
//
//   void _selectGender(String gender) {
//     childData["gender"] = gender;
//     _addUserMessage(gender == "male" ? "ذكر" : "أنثى");
//     waitingForSpecialInput = false;
//     currentStep++;
//     _showDatePicker();
//   }
//
//   void _showDatePicker() {
//     waitingForSpecialInput = true;
//     specialInputType = "date";
//     _addBotMessage("اختر تاريخ الميلاد:");
//
//     Widget dateButton = ElevatedButton.icon(
//       onPressed: () => _selectDate(),
//       icon: Icon(Icons.calendar_today),
//       label: Text("اختيار التاريخ"),
//       style: ElevatedButton.styleFrom(
//         backgroundColor: Colors.green[100],
//         foregroundColor: Colors.green[800],
//         padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//       ),
//     );
//
//     _addSpecialMessage(dateButton);
//   }
//
//   void _selectDate() async {
//     DateTime? selectedDate = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now().subtract(Duration(days: 365 * 10)),
//       firstDate: DateTime.now().subtract(Duration(days: 365 * 20)),
//       lastDate: DateTime.now(),
//       locale: Locale('ar'),
//     );
//
//     if (selectedDate != null) {
//       String formattedDate = "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";
//       childData["date_of_birth"] = formattedDate;
//       _addUserMessage("تاريخ الميلاد: $formattedDate");
//       waitingForSpecialInput = false;
//       currentStep++;
//       _showImagePicker();
//     }
//   }
//
//   void _showImagePicker() {
//     waitingForSpecialInput = true;
//     specialInputType = "image";
//     _addBotMessage("اختر صورة للطفل:");
//
//     Widget imageButtons = Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: [
//         ElevatedButton.icon(
//           onPressed: () => _selectImage(ImageSource.camera),
//           icon: Icon(Icons.camera_alt),
//           label: Text("الكاميرا"),
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.orange[100],
//             foregroundColor: Colors.orange[800],
//             padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//           ),
//         ),
//         ElevatedButton.icon(
//           onPressed: () => _selectImage(ImageSource.gallery),
//           icon: Icon(Icons.photo_library),
//           label: Text("المعرض"),
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.purple[100],
//             foregroundColor: Colors.purple[800],
//             padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//           ),
//         ),
//       ],
//     );
//
//     _addSpecialMessage(imageButtons);
//   }
//
//   void _selectImage(ImageSource source) async {
//     try {
//       final XFile? image = await _picker.pickImage(source: source);
//       if (image != null) {
//         // يمكنك هنا رفع الصورة إلى الخادم والحصول على الرابط
//         // لكن في هذا المثال سنحفظ اسم الملف فقط
//         String imageName = "image_${DateTime.now().millisecondsSinceEpoch}.jpg";
//         childData["imageUrl"] = imageName;
//
//         _addUserMessage("تم اختيار الصورة: $imageName");
//         waitingForSpecialInput = false;
//         currentStep++;
//         _addBotMessage(questions[5]);
//       }
//     } catch (e) {
//       _addBotMessage("حدث خطأ في اختيار الصورة. يرجى المحاولة مرة أخرى.");
//     }
//   }
//
//   void _showSiblingGenderSelection(int siblingIndex) {
//     waitingForSpecialInput = true;
//     specialInputType = "sibling_gender";
//     _addBotMessage("اختر جنس ${tempSiblings[siblingIndex]["name"]}:");
//
//     Widget genderButtons = Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: [
//         ElevatedButton.icon(
//           onPressed: () => _selectSiblingGender("male", siblingIndex),
//           icon: Icon(Icons.male, color: Colors.blue),
//           label: Text("ذكر"),
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.blue[100],
//             foregroundColor: Colors.blue[800],
//             padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//           ),
//         ),
//         ElevatedButton.icon(
//           onPressed: () => _selectSiblingGender("female", siblingIndex),
//           icon: Icon(Icons.female, color: Colors.pink),
//           label: Text("أنثى"),
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.pink[100],
//             foregroundColor: Colors.pink[800],
//             padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//           ),
//         ),
//       ],
//     );
//
//     _addSpecialMessage(genderButtons);
//   }
//
//   void _selectSiblingGender(String gender, int siblingIndex) {
//     tempSiblings[siblingIndex]["gender"] = gender;
//     _addUserMessage(gender == "male" ? "ذكر" : "أنثى");
//     waitingForSpecialInput = false;
//
//     currentSiblingIndex++;
//     if (currentSiblingIndex < siblingCount) {
//       currentStep = 6;
//       _addBotMessage("ما هو اسم الشقيق رقم ${currentSiblingIndex + 1}؟");
//     } else {
//       childData["siblings"] = tempSiblings;
//       currentStep = 100;
//       _addBotMessage(questions[6]);
//     }
//   }
//
//   void _showFriendGenderSelection(int friendIndex) {
//     waitingForSpecialInput = true;
//     specialInputType = "friend_gender";
//     _addBotMessage("اختر جنس ${tempFriends[friendIndex]["name"]}:");
//
//     Widget genderButtons = Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: [
//         ElevatedButton.icon(
//           onPressed: () => _selectFriendGender("male", friendIndex),
//           icon: Icon(Icons.male, color: Colors.blue),
//           label: Text("ذكر"),
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.blue[100],
//             foregroundColor: Colors.blue[800],
//             padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//           ),
//         ),
//         ElevatedButton.icon(
//           onPressed: () => _selectFriendGender("female", friendIndex),
//           icon: Icon(Icons.female, color: Colors.pink),
//           label: Text("أنثى"),
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.pink[100],
//             foregroundColor: Colors.pink[800],
//             padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//           ),
//         ),
//       ],
//     );
//
//     _addSpecialMessage(genderButtons);
//   }
//
//   void _selectFriendGender(String gender, int friendIndex) {
//     tempFriends[friendIndex]["gender"] = gender;
//     _addUserMessage(gender == "male" ? "ذكر" : "أنثى");
//     waitingForSpecialInput = false;
//
//     currentFriendIndex++;
//     if (currentFriendIndex < friendCount) {
//       currentStep = 101;
//       _addBotMessage("ما هو اسم الصديق رقم ${currentFriendIndex + 1}؟");
//     } else {
//       childData["friends"] = tempFriends;
//       _finishDataCollection();
//     }
//   }
//
//   void _finishDataCollection() {
//     _addBotMessage("تم جمع جميع البيانات بنجاح! 🎉");
//     _addBotMessage("البيانات المحفوظة:");
//
//     String jsonData = JsonEncoder.withIndent('  ').convert(childData);
//     _addBotMessage(jsonData);
//
//     _saveChildData();
//   }
//
//   void _saveChildData() {
//     print("البيانات المحفوظة:");
//     print(JsonEncoder.withIndent('  ').convert(childData));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('شات بوت لجمع بيانات الطفل'),
//         backgroundColor: Colors.blue[600],
//         elevation: 0,
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: Container(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                   colors: [Colors.blue[50]!, Colors.white],
//                 ),
//               ),
//               child: ListView.builder(
//                 controller: _scrollController,
//                 padding: EdgeInsets.all(16),
//                 itemCount: messages.length,
//                 itemBuilder: (context, index) {
//                   return MessageBubble(message: messages[index]);
//                 },
//               ),
//             ),
//           ),
//           if (!waitingForSpecialInput)
//             Container(
//               padding: EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 boxShadow: [
//                   BoxShadow(
//                     offset: Offset(0, -2),
//                     blurRadius: 6,
//                     color: Colors.black12,
//                   ),
//                 ],
//               ),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: TextField(
//                       controller: _messageController,
//                       textDirection: TextDirection.rtl,
//                       decoration: InputDecoration(
//                         hintText: 'اكتب إجابتك هنا...',
//                         hintTextDirection: TextDirection.rtl,
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(25),
//                           borderSide: BorderSide.none,
//                         ),
//                         filled: true,
//                         fillColor: Colors.grey[100],
//                         contentPadding: EdgeInsets.symmetric(
//                           horizontal: 20,
//                           vertical: 10,
//                         ),
//                       ),
//                       onSubmitted: (_) => _sendMessage(),
//                     ),
//                   ),
//                   SizedBox(width: 8),
//                   FloatingActionButton(
//                     onPressed: _sendMessage,
//                     child: Icon(Icons.send),
//                     mini: true,
//                     backgroundColor: Colors.blue[600],
//                   ),
//                 ],
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }
//
// class Message {
//   final String text;
//   final bool isBot;
//   final DateTime timestamp;
//   final Widget? specialWidget;
//
//   Message({
//     required this.text,
//     required this.isBot,
//     this.specialWidget,
//   }) : timestamp = DateTime.now();
// }
//
// class MessageBubble extends StatelessWidget {
//   final Message message;
//
//   const MessageBubble({Key? key, required this.message}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Align(
//       alignment: message.isBot ? Alignment.centerRight : Alignment.centerLeft,
//       child: Container(
//         margin: EdgeInsets.symmetric(vertical: 4),
//         padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//         decoration: BoxDecoration(
//           color: message.isBot ? Colors.blue[100] : Colors.green[100],
//           borderRadius: BorderRadius.circular(18),
//           boxShadow: [
//             BoxShadow(
//               offset: Offset(0, 1),
//               blurRadius: 3,
//               color: Colors.black12,
//             ),
//           ],
//         ),
//         constraints: BoxConstraints(
//           maxWidth: MediaQuery.of(context).size.width * 0.75,
//         ),
//         child: message.specialWidget != null
//             ? message.specialWidget!
//             : Text(
//           message.text,
//           textDirection: TextDirection.rtl,
//           style: TextStyle(
//             fontSize: 16,
//             color: Colors.black87,
//           ),
//         ),
//       ),
//     );
//   }
// }