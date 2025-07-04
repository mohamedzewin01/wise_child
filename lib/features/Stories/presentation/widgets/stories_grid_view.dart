import 'package:flutter/material.dart';
import 'package:wise_child/features/Stories/data/models/response/children_stories_model_dto.dart';
import 'package:wise_child/features/Stories/presentation/widgets/side_story_card.dart';


class StoriesGridView extends StatelessWidget {
  final List<StoriesModeData> stories;
  final AnimationController controller;

  const StoriesGridView({
    super.key,
    required this.stories,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Opacity(
          opacity: controller.value,
          child: GridView.builder(
            padding: const EdgeInsets.all(20),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.8,
            ),
            itemCount: stories.length,
            itemBuilder: (context, index) {
              final story = stories[index];

              return TweenAnimationBuilder<double>(
                duration: Duration(milliseconds: 800 + (index * 100)),
                tween: Tween(begin: 0.0, end: 1.0),
                curve: Curves.easeOutCubic,
                builder: (context, value, child) {
                  return Transform.translate(
                    offset: Offset(0, 30 * (1 - value)),
                    child: Opacity(
                      opacity: value,
                      child: SideStoryCard(
                        story: story,
                        index: index,

                      ),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}