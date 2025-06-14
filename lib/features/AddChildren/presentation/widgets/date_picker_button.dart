// import 'package:flutter/material.dart';
//
// import '../bloc/cubit_bot/chatbot_cubit.dart';
//
// class DatePickerButton extends StatelessWidget {
//   const DatePickerButton({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       key: UniqueKey(),
//       child: Builder(
//         builder: (context) {
//           return ElevatedButton.icon(
//             icon: const Icon(Icons.calendar_today),
//             label: const Text("اختر تاريخ الميلاد"),
//             onPressed: () async {
//               final DateTime? picked = await showDatePicker(
//                 context: context,
//                 initialDate: DateTime.now(),
//                 firstDate: DateTime(2000),
//                 lastDate: DateTime.now(),
//               );
//               if (picked != null && context.mounted) {
//                 ChatbotCubit.get(context).handleUserResponse(picked);
//               }
//             },
//           );
//         },
//       ),
//     );
//   }
// }
