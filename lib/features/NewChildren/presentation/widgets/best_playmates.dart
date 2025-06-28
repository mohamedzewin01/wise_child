// import 'package:flutter/material.dart';
// import 'package:wise_child/core/resources/color_manager.dart';
// import 'package:wise_child/core/resources/style_manager.dart';
// import 'package:wise_child/features/NewChildren/data/models/request/add_child_request.dart';
// import 'package:wise_child/features/NewChildren/presentation/widgets/section_header.dart';
// import 'package:wise_child/l10n/app_localizations.dart';
//
//
// class BestPlaymateSection extends StatelessWidget {
//   const BestPlaymateSection({
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
//   final List<BestPlaymate> list;
//   final VoidCallback onAdd;
//   final ValueChanged<BestPlaymate> onRemove;
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
//               (person) =>
//                   BestPlaymateCard(bestPlaymate: person, onRemove: () => onRemove(person)),
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
//
// class BestPlaymateCard extends StatelessWidget {
//   final BestPlaymate bestPlaymate;
//   final VoidCallback onRemove;
//
//   const BestPlaymateCard({super.key, required this.bestPlaymate, required this.onRemove});
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 0,
//       color: bestPlaymate.gender == 'male' ? ColorManager.primaryColor.withOpacity(0.2) : Colors.blueAccent.withOpacity(0.2),
//       margin: const EdgeInsets.only(bottom: 12),
//       child: ListTile(
//         titleTextStyle: getBoldStyle(color: Colors.black54,fontSize: 16),
//         leading: Icon(
//           bestPlaymate.gender == 'male' ? Icons.male : Icons.female,
//           color: bestPlaymate.gender == 'male' ? Colors.blue : Colors.pink,
//           size: 30,
//         ),
//         title: Text(
//           bestPlaymate.name??'',
//           style:getBoldStyle(color: Colors.blueAccent,fontSize: 16),
//         ),
//
//         subtitle: Text('العمر: ${bestPlaymate.age} سنة',style: getBoldStyle(color: ColorManager.primaryColor,fontSize: 12),),
//         trailing: Container(
//           padding: EdgeInsets.all(8),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(12.0),
//           ),
//           child: InkWell(
//               onTap: onRemove,
//               child: const Icon(Icons.delete_outline, color: Colors.redAccent)),
//         ),
//
//       ),
//     );
//   }
// }

///
import 'package:flutter/material.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'package:wise_child/core/resources/style_manager.dart';
import 'package:wise_child/features/NewChildren/data/models/request/add_child_request.dart';

class BestPlaymateSection extends StatelessWidget {
  const BestPlaymateSection({
    super.key,
    required this.title,
    required this.buttonLabel,
    required this.list,
    required this.onAdd,
    required this.onRemove,
  });

  final String title;
  final String buttonLabel;
  final List<BestPlaymate> list;
  final VoidCallback onAdd;
  final ValueChanged<BestPlaymate> onRemove;

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
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.favorite_outline,
                color: Colors.orange.shade600,
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
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: list.isNotEmpty ? Colors.green.shade50 : Colors.orange.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: list.isNotEmpty ? Colors.green.shade200 : Colors.orange.shade300,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    list.isNotEmpty ? Icons.check_circle : Icons.warning,
                    size: 12,
                    color: list.isNotEmpty ? Colors.green.shade600 : Colors.orange.shade600,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    list.isNotEmpty ? 'مكتمل' : 'مطلوب',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: list.isNotEmpty ? Colors.green.shade700 : Colors.orange.shade700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Empty State or Best Playmate Card
        if (list.isEmpty)
          _buildEmptyState()
        else
          _buildBestPlaymateCard(list.first, context),

        const SizedBox(height: 16),

        // Add Button (disabled if already has one)
        _buildAddButton(),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.orange.shade200,
          width: 2,
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.orange.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.favorite_border,
              size: 40,
              color: Colors.orange.shade600,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'لم يتم إضافة الصديق المفضل',
            style: TextStyle(
              color: Colors.orange.shade700,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'هذا الحقل مطلوب لإكمال التسجيل\nيمكن إضافة صديق مفضل واحد فقط',
            style: TextStyle(
              color: Colors.orange.shade600,
              fontSize: 13,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBestPlaymateCard(BestPlaymate bestPlaymate, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.orange.shade50,
            Colors.orange.shade100,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.orange.shade300,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.1),
            offset: const Offset(0, 4),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          // Special Avatar with Heart
          Stack(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: bestPlaymate.gender == 'male'
                      ? Colors.blue.shade100
                      : Colors.pink.shade100,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.orange.shade400,
                    width: 3,
                  ),
                ),
                child: Icon(
                  bestPlaymate.gender == 'male' ? Icons.male : Icons.female,
                  color: bestPlaymate.gender == 'male'
                      ? Colors.blue.shade600
                      : Colors.pink.shade600,
                  size: 28,
                ),
              ),
              Positioned(
                top: -2,
                right: -2,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.red.shade400,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Icon(
                    Icons.favorite,
                    color: Colors.white,
                    size: 10,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(width: 20),

          // Information
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: Colors.orange.shade600,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'الصديق المفضل',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.orange.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  bestPlaymate.name ?? '',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      Icons.cake_outlined,
                      size: 14,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${bestPlaymate.age} سنة',
                      style: TextStyle(
                        fontSize: 14,
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
            onTap: () => onRemove(bestPlaymate),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Icon(
                Icons.close,
                color: Colors.red.shade500,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton() {
    final isDisabled = list.isNotEmpty;

    return Container(
      width: double.infinity,
      height: 52,
      decoration: BoxDecoration(
        border: Border.all(
          color: isDisabled
              ? Colors.grey.shade300
              : Colors.orange.shade400,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(14),
        color: isDisabled ? Colors.grey.shade50 : Colors.transparent,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: isDisabled ? null : onAdd,
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: isDisabled
                        ? Colors.grey.shade200
                        : Colors.orange.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isDisabled ? Icons.check : Icons.add,
                    color: isDisabled
                        ? Colors.grey.shade500
                        : Colors.orange.shade700,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  isDisabled ? 'تم إضافة الصديق المفضل' : buttonLabel,
                  style: TextStyle(
                    color: isDisabled
                        ? Colors.grey.shade500
                        : Colors.orange.shade700,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (!isDisabled) ...[
                  const SizedBox(width: 6),
                  Text(
                    '*',
                    style: TextStyle(
                      color: Colors.red.shade500,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}