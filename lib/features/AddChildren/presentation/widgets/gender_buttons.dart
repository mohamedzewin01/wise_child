// import 'package:flutter/material.dart';
//
// import '../bloc/cubit_bot/chatbot_cubit.dart';
//
// class GenderButtons extends StatelessWidget {
//   const GenderButtons({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       key: UniqueKey(),
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         ElevatedButton(
//           onPressed: () => ChatbotCubit.get(context).handleUserResponse("ولد"),
//           child: const Text("ولد"),
//         ),
//         const SizedBox(width: 16),
//         ElevatedButton(
//           onPressed: () => ChatbotCubit.get(context).handleUserResponse("بنت"),
//           style: ElevatedButton.styleFrom(backgroundColor: Colors.pink[300]),
//           child: const Text("بنت"),
//         ),
//       ],
//     );
//   }
// }
