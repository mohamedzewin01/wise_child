// import 'package:flutter/material.dart';
// import 'package:wise_child/core/resources/color_manager.dart';
// import 'package:wise_child/core/resources/style_manager.dart';
// import 'package:wise_child/features/NewChildren/data/models/request/add_child_request.dart';
// import 'package:wise_child/features/NewChildren/presentation/pages/NewChildren_page.dart';
//
// class SiblingsCard extends StatelessWidget {
//   final Siblings person;
//   final VoidCallback onRemove;
//
//   const SiblingsCard({super.key, required this.person, required this.onRemove});
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//
//        elevation: 0,
//       color:  person.gender == 'male' ? ColorManager.primaryColor.withOpacity(0.2) : Colors.blueAccent.withOpacity(0.2),
//       margin: const EdgeInsets.only(bottom: 12),
//       child: ListTile(
//         titleTextStyle: getBoldStyle(color: Colors.black54,fontSize: 16),
//         leading: Icon(
//           person.gender == 'male' ? Icons.male : Icons.female,
//           color: person.gender == 'male' ? Colors.blue : Colors.pink,
//           size: 30,
//         ),
//         title: Text(
//           person.name??'',
//           style:getBoldStyle(color: Colors.blueAccent,fontSize: 16),
//
//           // const TextStyle(fontWeight: FontWeight.w600),
//         ),
//
//         subtitle: Text('العمر: ${person.age} سنة',style: getBoldStyle(color: ColorManager.primaryColor,fontSize: 12),),
//
//         trailing: Container(
//           padding: EdgeInsets.all(8),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(12.0),
//           ),
//           child: InkWell(
//             onTap: onRemove,
//             child: const Icon(Icons.delete_outline, color: Colors.redAccent)),
//         ),
//       ),
//     );
//   }
// }