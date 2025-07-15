import 'package:flutter/material.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'package:wise_child/core/resources/style_manager.dart';
import 'package:wise_child/features/StoryInfo/data/models/response/story_info_dto.dart';

class StoryInfoDetailsSection extends StatelessWidget {
  final StoryInfo story;

  const StoryInfoDetailsSection({required this.story, super.key});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 1000),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                if (story.ageGroup != null)
                  _StoryInfoCard(
                    icon: Icons.child_care,
                    title: 'الفئة العمرية',
                    valueInfo: story.ageGroup!,
                    color: ColorManager.primaryColor,
                    delay: 0,
                  ),
                if (story.gender != null)
                  _StoryInfoCard(
                    icon: Icons.person,
                    title: 'الجنس',
                    valueInfo: story.gender!,
                    color: Colors.green.shade600,
                    delay: 100,
                  ),
                if (story.isActive == true)
                  _StoryInfoCard(
                    icon: Icons.check_circle,
                    title: 'الحالة',
                    valueInfo: 'نشطة',
                    color: Colors.blue.shade600,
                    delay: 200,
                  ),

              ],
            ),
          ),
        );
      },
    );
  }
}

class _StoryInfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String valueInfo;
  final Color color;
  final int delay;

  const _StoryInfoCard({
    required this.icon,
    required this.title,
    required this.valueInfo,
    required this.color,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 800 + delay),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.8 + (0.2 * value),
          child: Opacity(
            opacity: value,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: color.withOpacity(0.3),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(icon, size: 20, color: color),
                      const SizedBox(width: 8),
                      Text(
                        title,
                        style: getMediumStyle(
                          color: color,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    valueInfo,
                    style: getBoldStyle(
                      color: color,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}