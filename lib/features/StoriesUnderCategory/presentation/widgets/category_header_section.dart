import 'package:flutter/material.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'package:wise_child/core/resources/style_manager.dart';
import 'package:wise_child/features/StoriesUnderCategory/data/models/response/stories_under_category_dto.dart';

class CategoryHeaderSection extends StatelessWidget {
  final Category category;
  final bool isRTL;
  final int totalStories;

  const CategoryHeaderSection({
    super.key,
    required this.category,
    required this.isRTL,
    required this.totalStories,
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
              margin: const EdgeInsets.symmetric(horizontal: 20),
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
                          Icons.category,
                          color: ColorManager.primaryColor,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              category.categoryName ?? 'فئة القصص',
                              style: getBoldStyle(
                                color: ColorManager.primaryColor,
                                fontSize: 22,
                              ),
                              textDirection: isRTL
                                  ? TextDirection.rtl
                                  : TextDirection.ltr,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'معرف الفئة: ${category.categoryId ?? 'غير محدد'}',
                              style: getRegularStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12,
                              ),
                              textDirection: isRTL
                                  ? TextDirection.rtl
                                  : TextDirection.ltr,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildStatisticsRow(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatisticsRow() {
    return Row(
      textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatCard(
          icon: Icons.auto_stories,
          title: 'إجمالي القصص',
          value: '${category.stories?.length ?? 0}',
          color: ColorManager.primaryColor,
        ),
        _buildStatCard(
          icon: Icons.filter_list,
          title: 'المعروضة',
          value: '$totalStories',
          color: Colors.green.shade600,
        ),
        _buildStatCard(
          icon: Icons.visibility,
          title: 'إجمالي المشاهدات',
          value: '${_getTotalViews()}',
          color: Colors.orange.shade600,
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: color,
              size: 20,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: getBoldStyle(
                color: color,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: getRegularStyle(
                color: color,
                fontSize: 10,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  int _getTotalViews() {
    if (category.stories == null) return 0;
    return category.stories!.fold(0, (sum, story) => sum + (story.viewsCount ?? 0));
  }
}