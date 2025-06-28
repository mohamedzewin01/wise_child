// import 'package:flutter/material.dart';
// import 'package:wise_child/core/resources/style_manager.dart';
// import 'package:wise_child/features/NewChildren/data/models/request/add_child_request.dart';
// import 'package:wise_child/features/NewChildren/presentation/widgets/Friends_card.dart';
// import 'package:wise_child/features/NewChildren/presentation/widgets/section_header.dart';
// import 'package:wise_child/l10n/app_localizations.dart';
//
// class FriendsListSection extends StatelessWidget {
//   const FriendsListSection({
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
//   final List<Friends> list;
//   final VoidCallback onAdd;
//   final ValueChanged<Friends> onRemove;
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         SectionHeader(title: title, vertical: 5),
//
//         if (list.isEmpty)
//           Text(
//             AppLocalizations.of(context)!.noFriendsAdded,
//             style: getBoldStyle(color: Colors.grey),
//           ),
//         ...list.map(
//           (person) =>
//               FriendsCard(friends: person, onRemove: () => onRemove(person)),
//         ),
//         const SizedBox(height: 12),
//         OutlinedButton.icon(
//           onPressed: onAdd,
//           icon: const Icon(Icons.add),
//           label: Text(buttonLabel, style: getBoldStyle(color: Colors.grey)),
//           style: OutlinedButton.styleFrom(
//             foregroundColor: Colors.green,
//             side: BorderSide(color: Colors.grey.shade300),
//             // minimumSize: const Size(double.infinity, 45),
//             backgroundColor: Colors.grey.shade100,
//           ),
//         ),
//       ],
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:wise_child/core/resources/style_manager.dart';
import 'package:wise_child/features/NewChildren/data/models/request/add_child_request.dart';

class FriendsListSection extends StatelessWidget {
  const FriendsListSection({
    super.key,
    required this.title,
    required this.buttonLabel,
    required this.list,
    required this.onAdd,
    required this.onRemove,
  });

  final String title;
  final String buttonLabel;
  final List<Friends> list;
  final VoidCallback onAdd;
  final ValueChanged<Friends> onRemove;

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
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.people_outline,
                color: Colors.amber.shade600,
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
                color: Colors.amber.shade700,
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
                .map((friend) => _buildFriendCard(friend, context))
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
            Icons.emoji_people_outlined,
            size: 32,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 8),
          Text(
            'لا توجد أصدقاء مضافين',
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

  Widget _buildFriendCard(Friends friend, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: friend.gender == 'male'
            ? Colors.cyan.shade50
            : Colors.purple.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: friend.gender == 'male'
              ? Colors.cyan.shade200
              : Colors.purple.shade200,
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
              color: friend.gender == 'male'
                  ? Colors.cyan.shade100
                  : Colors.purple.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              friend.gender == 'male' ? Icons.male : Icons.female,
              color: friend.gender == 'male'
                  ? Colors.cyan.shade600
                  : Colors.purple.shade600,
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
                  friend.name ?? '',
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
                      '${friend.age} سنة',
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
            onTap: () => onRemove(friend),
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
          color: Colors.amber.shade400,
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
                    color: Colors.amber.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.add,
                    color: Colors.amber.shade700,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  buttonLabel,
                  style: TextStyle(
                    color: Colors.amber.shade700,
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