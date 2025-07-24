import 'package:flutter/material.dart';
import 'package:wise_child/features/ChildStories/data/models/response/get_child_stories_dto.dart';
import 'package:wise_child/features/Children/data/models/response/get_children_dto.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'package:wise_child/core/resources/style_manager.dart';
import 'package:wise_child/localization/locale_cubit.dart';

class StoriesStatistics extends StatelessWidget {
  final List<Stories> stories;
  final Children child;
  final bool isRTL;

  const StoriesStatistics({
    super.key,
    required this.stories,
    required this.child,
    required this.isRTL,
  });

  @override
  Widget build(BuildContext context) {
    final languageCode = LocaleCubit.get(context).state.languageCode;
    final totalViews = stories.fold<int>(0, (sum, story) => sum + (story.viewsCount ?? 0));
    final activeStories = stories.where((story) => story.isActive == 1).length;
    final averageViews = stories.isNotEmpty ? (totalViews / stories.length).round() : 0;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: ColorManager.primaryColor.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: ColorManager.primaryColor.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: isRTL ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: ColorManager.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.analytics_outlined,
                    color: ColorManager.primaryColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    languageCode == 'ar' ? 'إحصائيات القصص' : 'Stories Statistics',
                    style: getBoldStyle(
                      color: ColorManager.primaryColor,
                      fontSize: 18,
                    ),
                    textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Statistics Grid
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.library_books_outlined,
                    title: languageCode == 'ar' ? 'إجمالي القصص' : 'Total Stories',
                    value: '${stories.length}',
                    color: Colors.blue.shade600,
                    isRTL: isRTL,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.visibility_outlined,
                    title: languageCode == 'ar' ? 'إجمالي المشاهدات' : 'Total Views',
                    value: _formatNumber(totalViews),
                    color: Colors.green.shade600,
                    isRTL: isRTL,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.check_circle_outline,
                    title: languageCode == 'ar' ? 'القصص النشطة' : 'Active Stories',
                    value: '$activeStories',
                    color: Colors.orange.shade600,
                    isRTL: isRTL,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.trending_up_outlined,
                    title: languageCode == 'ar' ? 'متوسط المشاهدات' : 'Avg Views',
                    value: _formatNumber(averageViews),
                    color: Colors.purple.shade600,
                    isRTL: isRTL,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    required bool isRTL,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: isRTL ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          // Icon and Value Row
          Row(
            textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 18,
                ),
              ),
              Text(
                value,
                style: getBoldStyle(
                  color: color,
                  fontSize: 20,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Title
          Text(
            title,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            textAlign: isRTL ? TextAlign.right : TextAlign.left,
            textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
          ),
        ],
      ),
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    } else {
      return number.toString();
    }
  }
}