// Story Title Section
import 'package:flutter/material.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'package:wise_child/core/resources/style_manager.dart';
import 'package:wise_child/features/StoryDetails/data/models/response/story_details_dto.dart';

class StoryTitleSection extends StatelessWidget {
  final StoryDetails story;
  final bool isRTL;

  const StoryTitleSection({super.key,
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
                    textDirection: isRTL ? TextDirection.rtl : TextDirection
                        .ltr,
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
                      textDirection: isRTL ? TextDirection.rtl : TextDirection
                          .ltr,
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

// Favorite Image Section Component


// Story Info Section


// Info Card Component


// Story Description Section


// Problem Section
class _ProblemSection extends StatelessWidget {
  final Problem problem;
  final bool isRTL;

  const _ProblemSection({
    required this.problem,
    required this.isRTL,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 1400),
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
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.orange.shade200, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.shade100,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    textDirection: isRTL ? TextDirection.rtl : TextDirection
                        .ltr,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.psychology,
                          size: 20,
                          color: Colors.orange.shade700,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'تساعد في حل:',
                        style: getBoldStyle(
                          color: Colors.orange.shade800,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    problem.problemTitle ?? 'مشكلة غير محددة',
                    style: getBoldStyle(
                        color: Colors.orange.shade700, fontSize: 18),
                    textDirection: isRTL ? TextDirection.rtl : TextDirection
                        .ltr,
                  ),
                  if (problem.problemDescription != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      problem.problemDescription!,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.orange.shade600,
                        height: 1.4,
                      ),
                      textDirection: isRTL ? TextDirection.rtl : TextDirection
                          .ltr,
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
}

// Category Section
class _CategorySection extends StatelessWidget {
  final Category category;
  final bool isRTL;

  const _CategorySection({
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
                    textDirection: isRTL ? TextDirection.rtl : TextDirection
                        .ltr,
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
                    style: getBoldStyle(
                        color: Colors.blue.shade700, fontSize: 18),
                    textDirection: isRTL ? TextDirection.rtl : TextDirection
                        .ltr,
                  ),
                  if (category.categoryDescription != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      category.categoryDescription!,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blue.shade600,
                        height: 1.4,
                      ),
                      textDirection: isRTL ? TextDirection.rtl : TextDirection
                          .ltr,
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
}
