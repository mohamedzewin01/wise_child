import 'package:flutter/material.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'package:wise_child/core/resources/style_manager.dart';
import 'package:wise_child/features/StoryInfo/data/models/response/story_info_dto.dart';

class StoryInfoTitleSection extends StatelessWidget {
  final StoryInfo story;
  final bool isRTL;

  const StoryInfoTitleSection({
    super.key,
    required this.story,
    required this.isRTL,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 800),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    ColorManager.primaryColor.withOpacity(0.1),
                    Colors.purple.shade50.withOpacity(0.5),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: ColorManager.primaryColor.withOpacity(0.2),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: ColorManager.primaryColor.withOpacity(0.1),
                    blurRadius: 10,
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
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: ColorManager.primaryColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.auto_stories,
                          color: ColorManager.primaryColor,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          story.storyTitle ?? 'عنوان القصة',
                          style: getBoldStyle(
                            color: ColorManager.primaryColor,
                            fontSize: 22,
                          ),
                          textDirection: isRTL
                              ? TextDirection.rtl
                              : TextDirection.ltr,
                        ),
                      ),
                    ],
                  ),
                  if (story.createdAt != null) ...[
                    const SizedBox(height: 12),
                    Row(
                      textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 16,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'تاريخ الإنشاء: ${_formatDate(story.createdAt!)}',
                          style: getRegularStyle(
                            color: Colors.grey.shade600,
                            fontSize: 13,
                          ),
                          textDirection: isRTL
                              ? TextDirection.rtl
                              : TextDirection.ltr,
                        ),
                      ],
                    ),
                  ],
                  if (story.isActive != null) ...[
                    const SizedBox(height: 8),
                    Row(
                      textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                      children: [
                        Icon(
                          story.isActive! ? Icons.check_circle : Icons.cancel,
                          size: 16,
                          color: story.isActive! ? Colors.green : Colors.red,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'الحالة: ${story.isActive! ? "نشطة" : "غير نشطة"}',
                          style: getRegularStyle(
                            color: story.isActive! ? Colors.green.shade600 : Colors.red.shade600,
                            fontSize: 13,
                          ),
                          textDirection: isRTL
                              ? TextDirection.rtl
                              : TextDirection.ltr,
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