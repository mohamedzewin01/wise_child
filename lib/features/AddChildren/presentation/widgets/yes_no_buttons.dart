// import 'package:flutter/material.dart';
//
// import '../bloc/cubit_bot/chatbot_cubit.dart';
//
// class YesNoButtons extends StatelessWidget {
//   const YesNoButtons({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       key: UniqueKey(),
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         ElevatedButton(
//           onPressed: () => ChatbotCubit.get(context).handleUserResponse(true),
//           child: const Text("نعم"),
//         ),
//         const SizedBox(width: 16),
//         ElevatedButton(
//           onPressed: () => ChatbotCubit.get(context).handleUserResponse(false),
//           style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
//           child: const Text("لا"),
//         ),
//       ],
//     );
//   }
// }
