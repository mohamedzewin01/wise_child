// import 'package:flutter/material.dart';
//
// class ChatMessageWidget extends StatelessWidget {
//   final String text;
//   final bool isFromUser;
//
//   const ChatMessageWidget({
//     super.key,
//     required this.text,
//     required this.isFromUser,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 10.0),
//       child: Row(
//         mainAxisAlignment: isFromUser ? MainAxisAlignment.end : MainAxisAlignment.start,
//         children: [
//           Flexible(
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
//               decoration: BoxDecoration(
//                 color: isFromUser ? Colors.blue : Colors.grey[200],
//                 borderRadius: BorderRadius.only(
//                   topLeft: const Radius.circular(20),
//                   topRight: const Radius.circular(20),
//                   bottomLeft: isFromUser ? const Radius.circular(20) : const Radius.circular(0),
//                   bottomRight: isFromUser ? const Radius.circular(0) : const Radius.circular(20),
//                 ),
//               ),
//               child: Text(
//                 text,
//                 style: TextStyle(
//                   color: isFromUser ? Colors.white : Colors.black87,
//                   fontSize: 16,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }