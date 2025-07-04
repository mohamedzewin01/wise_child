import 'package:flutter/material.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'package:wise_child/features/StoryDetails/data/models/response/story_details_dto.dart';
import 'package:wise_child/features/StoryDetails/presentation/widgets/Info_card.dart';

class StoryInfoSection extends StatelessWidget {
  final StoryDetails story;

  const StoryInfoSection({required this.story, super.key});

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
                  InfoCard(
                    icon: Icons.child_care,
                    title: 'الفئة العمرية',
                    stringValue: story.ageGroup??'',
                    color: ColorManager.primaryColor,
                    delay: 0,
                  ),
                if (story.gender != null)
                  InfoCard(
                    icon: Icons.person,
                    title: 'الجنس',
                    stringValue: story.gender??'',
                    color: Colors.green.shade600,
                    delay: 100,
                  ),
                if (story.isActive == true)
                  InfoCard(
                    icon: Icons.check_circle,
                    title: 'الحالة',
                    stringValue: 'نشطة',
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
