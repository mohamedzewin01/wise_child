import 'package:flutter/material.dart';
import 'package:wise_child/core/api/api_constants.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'package:wise_child/features/AllStoriesByUser/data/models/response/user_stories_dto.dart';
import 'package:wise_child/features/AllStoriesByUser/presentation/widgets/cached_network_image_widget.dart';
import 'package:wise_child/features/ChildMode/presentation/widgets/ChildHeader.dart';
import 'package:wise_child/core/widgets/avatar_image.dart';

class ChildInfoCard extends StatelessWidget {
  final ChildrenStoriesData childData;

  const ChildInfoCard({
    super.key,
    required this.childData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Row(
        children: [
          AvatarWidget(


            backgroundColor: ColorManager.primaryColor,
            textColor: Colors.white,
            imageUrl: childData.imageUrl??'',
            radius: 32,
            firstName: childData.childName ?? '',
            lastName:'',

          ),


          const SizedBox(width: 16),

          // معلومات الطفل
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  childData.childName ?? 'غير محدد',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 8),

                // العمر والجنس
                Row(
                  children: [
                    _buildInfoChip(
                      icon: Icons.cake_rounded,
                      label: '${childData.age ?? 0} سنة',
                      color: const Color(0xFFEF4444),
                    ),
                    const SizedBox(width: 8),
                    _buildInfoChip(
                      icon: childData.gender == 'Male'
                          ? Icons.boy_rounded
                          : Icons.girl_rounded,
                      label: childData.gender == 'Male' ? 'ذكر' : 'أنثى',
                      color: childData.gender == 'Male'
                          ? const Color(0xFF3B82F6)
                          : const Color(0xFFEC4899),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // جنس الصديق المفضل
                if (childData.playmateGender != null) ...[
                  _buildInfoChip(
                    icon: Icons.people_rounded,
                    label: ' يفضل اللعب مع: ${childData.bestFriendName}',
                    color: const Color(0xFF10B981),
                  ),
                ],
              ],
            ),
          ),

          // أيقونة الطفل
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: ColorManager.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              childData.gender == 'Male' ? Icons.boy_rounded : Icons.girl_rounded,
              color:ColorManager.primaryColor,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: color,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}