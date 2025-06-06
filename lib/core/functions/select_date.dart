import 'package:flutter/material.dart';
// DateTime? _selectedDate ;
// Future<void> _selectDate(BuildContext context) async {
//   final DateTime? picked = await showDatePicker(
//     context: context,
//     initialDate: _selectedDate ?? DateTime.now(),
//     firstDate: DateTime(2000),
//     lastDate: DateTime(2101),
//   );
//   if (picked != null && picked != _selectedDate) {
//     setState(() {
//       _selectedDate = picked;
//       _dateController.text = DateFormat('MMMM dd, yyyy').format(picked);
//     });
//   }
// }