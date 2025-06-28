// import 'package:flutter/material.dart';
// import 'package:wise_child/core/resources/color_manager.dart';
// import 'package:wise_child/core/resources/style_manager.dart';
// import 'package:wise_child/features/NewChildren/data/models/request/add_child_request.dart';
// import 'package:wise_child/features/NewChildren/presentation/widgets/section_header.dart';
// import 'package:wise_child/features/NewChildren/presentation/widgets/siblings_card.dart';
// import 'package:wise_child/l10n/app_localizations.dart';
//
// class SiblingsListSection extends StatelessWidget {
//   const SiblingsListSection({
//     super.key,
//     required this.title,
//     required this.buttonLabel,
//     required this.list,
//     required this.onAdd,
//     required this.onRemove,
//   });
//
//   final String title;
//   final String buttonLabel;
//   final List<Siblings> list;
//   final VoidCallback onAdd;
//   final ValueChanged<Siblings> onRemove;
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         SectionHeader(title: title,),
//
//         if (list.isEmpty)
//            Text(
//             AppLocalizations.of(context)!.noSiblingsAdded,
//             style: getBoldStyle(color: Colors.grey),
//           ),
//         ...list.map(
//               (person) =>
//               SiblingsCard(person: person, onRemove: () => onRemove(person)),
//         ),
//         OutlinedButton.icon(
//           onPressed: onAdd,
//           icon: const Icon(Icons.add),
//           label: Text(buttonLabel,style: getBoldStyle(color: Colors.grey),),
//           style: OutlinedButton.styleFrom(
//             foregroundColor: Colors.green,
//             side: BorderSide(
//               color: Colors.grey.shade300,
//             ),
//             // minimumSize: const Size(double.infinity, 45),
//             backgroundColor: Colors.grey.shade200,
//           ),
//         ),
//       ],
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:wise_child/core/resources/style_manager.dart';
import 'package:wise_child/features/NewChildren/data/models/request/add_child_request.dart';

class SiblingsListSection extends StatelessWidget {
  const SiblingsListSection({
    super.key,
    required this.title,
    required this.buttonLabel,
    required this.list,
    required this.onAdd,
    required this.onRemove,
  });

  final String title;
  final String buttonLabel;
  final List<Siblings> list;
  final VoidCallback onAdd;
  final ValueChanged<Siblings> onRemove;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.teal.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.family_restroom,
                color: Colors.teal.shade400,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade800,
                ),
              ),
            ),
            Text(
              '${list.length}',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.teal.shade600,
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Empty State or List
        if (list.isEmpty)
          _buildEmptyState()
        else
          Column(
            children: list
                .map((person) => _buildSiblingCard(person, context))
                .toList(),
          ),

        const SizedBox(height: 16),

        // Add Button
        _buildAddButton(),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.people_outline,
            size: 32,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 8),
          Text(
            'لا توجد إخوة أو أخوات مضافين',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'اضغط على زر الإضافة أدناه',
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSiblingCard(Siblings person, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: person.gender == 'male'
            ? Colors.blue.shade50
            : Colors.pink.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: person.gender == 'male'
              ? Colors.blue.shade200
              : Colors.pink.shade200,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: person.gender == 'male'
                  ? Colors.blue.shade100
                  : Colors.pink.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              person.gender == 'male' ? Icons.male : Icons.female,
              color: person.gender == 'male'
                  ? Colors.blue.shade600
                  : Colors.pink.shade600,
              size: 24,
            ),
          ),

          const SizedBox(width: 16),

          // Information
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  person.name ?? '',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade800,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.cake_outlined,
                      size: 14,
                      color: Colors.grey.shade500,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${person.age} سنة',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Remove Button
          GestureDetector(
            onTap: () => onRemove(person),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.close,
                color: Colors.red.shade400,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton() {
    return Container(
      width: double.infinity,
      height: 48,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.teal.shade300,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onAdd,
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.teal.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.add,
                    color: Colors.teal.shade600,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  buttonLabel,
                  style: TextStyle(
                    color: Colors.teal.shade600,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}