
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'package:wise_child/features/Stories/presentation/widgets/card_story.dart';
import 'package:wise_child/features/Stories/presentation/widgets/story_card.dart';

class SkeCardUser extends StatelessWidget {
  const SkeCardUser({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: List.generate(8, (index) => Skeletonizer(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10.0,),
            child: StoryCard(
              childId: 223,
              storyId: 223,

              title: 'عنوان القصة',
              description: 'وصف قصير للقصة...',
              ageRange: 'Ages 4-7',
              duration: '10 mins',
              imageUrl: '1.jpg',
              cardColor: const Color(0xFFFFF8E1),
              buttonColor: ColorManager.primaryColor,
            ),
          ),
        ),),
      ),
    );
  }
}
