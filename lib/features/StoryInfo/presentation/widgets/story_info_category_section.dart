import 'package:flutter/material.dart';
import 'package:wise_child/core/resources/style_manager.dart';
import 'package:wise_child/features/StoryInfo/data/models/response/story_info_dto.dart';

class StoryInfoCategorySection extends StatelessWidget {
  final CategoryInfo category;
  final bool isRTL;

  const StoryInfoCategorySection({
    super.key,
    required this.category,
    required this.isRTL,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 1600),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.blue.shade200, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.shade100,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.category,
                          size: 20,
                          color: Colors.blue.shade700,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'تصنيف القصة:',
                        style: getBoldStyle(
                          color: Colors.blue.shade800,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    category.categoryName ?? 'تصنيف غير محدد',
                    style: getBoldStyle(color: Colors.blue.shade700, fontSize: 18),
                    textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                  ),
                  if (category.categoryDescription != null && category.categoryDescription!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      category.categoryDescription!,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blue.shade600,
                        height: 1.4,
                      ),
                      textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                    ),
                  ],

                  if (category.createdAt != null) ...[
                    const SizedBox(height: 4),
                    Row(
                      textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: Colors.blue.shade500,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'تاريخ الإنشاء: ${_formatDate(category.createdAt!)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blue.shade500,
                          ),
                          textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }
}