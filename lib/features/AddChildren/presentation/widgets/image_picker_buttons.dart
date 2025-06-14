// import 'package:flutter/material.dart';
// import 'package:wise_child/features/AddChildren/presentation/bloc/cubit_bot/chatbot_cubit.dart';
//
// class ImagePickerButtons extends StatelessWidget {
//   const ImagePickerButtons({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       key: UniqueKey(),
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         ElevatedButton.icon(
//           icon: const Icon(Icons.photo_library),
//           label: const Text("اختيار صورة"),
//           onPressed: ChatbotCubit.get(context).pickImage,
//         ),
//         const SizedBox(width: 16),
//         TextButton(
//           onPressed: () => ChatbotCubit.get(context).handleUserResponse(null),
//           child: const Text("تخطي"),
//         ),
//       ],
//     );
//   }
// }
