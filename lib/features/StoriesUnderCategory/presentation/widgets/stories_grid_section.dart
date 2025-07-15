import 'package:flutter/material.dart';
import 'package:wise_child/core/api/api_constants.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'package:wise_child/core/resources/style_manager.dart';
import 'package:wise_child/features/StoriesUnderCategory/data/models/response/stories_under_category_dto.dart';
import 'package:wise_child/features/StoriesUnderCategory/presentation/widgets/story_card_widget.dart';

class StoriesGridSection extends StatelessWidget {
  final List<Stories> stories;
  final bool isRTL;
  final Animation<double> fadeAnimation;

  const StoriesGridSection({
    super.key,
    required this.stories,
    required this.isRTL,
    required this.fadeAnimation,
  });

  @override
  Widget build(BuildContext context) {
    if (stories.isEmpty) {
      return SliverToBoxAdapter(
        child: _buildEmptyState(),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate(
              (context, index) {
            return FadeTransition(
              opacity: fadeAnimation,
              child: TweenAnimationBuilder<double>(
                duration: Duration(milliseconds: 800 + (index * 100)),
                tween: Tween(begin: 0.0, end: 1.0),
                builder: (context, value, child) {
                  return Transform.translate(
                    offset: Offset(0, 50 * (1 - value)),
                    child: Opacity(
                      opacity: value,
                      child: StoryCardWidget(
                        story: stories[index],
                        isRTL: isRTL,
                        index: index,
                      ),
                    ),
                  );
                },
              ),
            );
          },
          childCount: stories.length,
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: _getCrossAxisCount(context),
          childAspectRatio: 0.75,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 1000),
            tween: Tween(begin: 0.0, end: 1.0),
            builder: (context, value, child) {
              return Transform.scale(
                scale: 0.8 + (0.2 * value),
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.grey.shade300,
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    Icons.search_off,
                    size: 50,
                    color: Colors.grey.shade400,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          Text(
            'لا توجد قصص تطابق معايير البحث',
            style: getBoldStyle(
              color: Colors.grey.shade600,
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'جرب تغيير الفلاتر أو البحث عن شيء آخر',
            style: getRegularStyle(
              color: Colors.grey.shade500,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.blue.shade200,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  color: Colors.blue.shade600,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'نصيحة: استخدم فلتر "الكل" لعرض جميع القصص المتاحة',
                    style: TextStyle(
                      color: Colors.blue.shade700,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  int _getCrossAxisCount(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 600) {
      return 3;
    } else if (screenWidth > 400) {
      return 2;
    } else {
      return 1;
    }
  }
}