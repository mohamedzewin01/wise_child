import 'package:flutter/material.dart';
import 'package:wise_child/core/resources/style_manager.dart';
import 'package:wise_child/features/AllStoriesByUser/data/models/response/user_stories_dto.dart';
import 'package:wise_child/features/AllStoriesByUser/presentation/widgets/child_info_card.dart';
import 'package:wise_child/features/AllStoriesByUser/presentation/widgets/story_card_home.dart';

class ChildStoriesSection extends StatelessWidget {
  final ChildrenStoriesData childData;
  final int childIndex;
  final bool isRTL;

  const ChildStoriesSection({
    super.key,
    required this.childData,
    required this.childIndex,
    required this.isRTL,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // معلومات الطفل
          ChildInfoCard(childData: childData),

          // القصص
          if (childData.stories?.isNotEmpty ?? false) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Icon(
                    Icons.auto_stories_rounded,
                    color: Color(0xFF667EEA),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'القصص المتاحة (${childData.stories!.length})',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF374151),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            SizedBox(
              height: 250,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: childData.stories!.length,
                separatorBuilder: (context, index) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  return StoryCardHome(
                    story: childData.stories![index],
                    storyIndex: index,
                    isRTL: isRTL,
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
          ] else ...[

            Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.library_books_outlined,
                      size: 48,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'لا توجد قصص متاحة حالياً',
                      style: getSemiBoldStyle(
                        fontSize: 18,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'سيتم إضافة قصص جديدة قريباً',
                      style: getSemiBoldStyle(
                        fontSize: 14,
                        color: Colors.grey[500],
                      ),

                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
