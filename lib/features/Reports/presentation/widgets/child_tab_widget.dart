import 'package:flutter/material.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'package:wise_child/core/widgets/avatar_image.dart';
import 'package:wise_child/features/Reports/data/models/response/reports_dto.dart';
import 'story_card_widget.dart';

class ChildTabWidget extends StatelessWidget {
  final ReportData childData;
  final VoidCallback onAddReview;

  const ChildTabWidget({
    super.key,
    required this.childData,
    required this.onAddReview,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // معلومات الطفل
          _buildChildInfoCard(),
          const SizedBox(height: 20),

          // إحصائيات عامة
          _buildStatsCard(),
          const SizedBox(height: 20),

          // القصص المشاهدة
          _buildStoriesSection(),
          const SizedBox(height: 20),

          // زر إضافة المراجعة
          _buildAddReviewButton(),
        ],
      ),
    );
  }

  Widget _buildChildInfoCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [ColorManager.primaryColor, Color(0xFF9B59B6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Row(
          children: [

            AvatarWidget(
              firstName: childData.firstName ?? '',
              lastName: childData.lastName ?? '',
              imageUrl: childData.imageUrlChild,
              radius: 35,

            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${childData.firstName} ${childData.lastName}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'النوع : ${childData.gender == 'Male' ? 'ولد' : 'بنت'}',
                    style: const TextStyle(fontSize: 14, color: Colors.white70),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'تاريخ الميلاد: ${_formatDate(childData.dateOfBirth)}',
                    style: const TextStyle(fontSize: 14, color: Colors.white70),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCard() {
    final totalViews =
        childData.stories?.fold<int>(
          0,
          (sum, story) => sum + (story.totalViews ?? 0),
        ) ??
        0;

    final totalStories = childData.stories?.length ?? 0;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'الإحصائيات العامة',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    icon: Icons.book_outlined,
                    title: 'عدد القصص',
                    value: totalStories.toString(),
                    color: const Color(0xFF6B73FF),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatItem(
                    icon: Icons.visibility_outlined,
                    title: 'إجمالي المشاهدات',
                    value: totalViews.toString(),
                    color: const Color(0xFF00BCD4),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    icon: Icons.trending_up_outlined,
                    title: 'المتوسط لكل قصة',
                    value: totalStories > 0
                        ? (totalViews / totalStories).toStringAsFixed(1)
                        : '0',
                    color: const Color(0xFF4CAF50),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatItem(
                    icon: Icons.favorite_outline,
                    title: 'القصة الأكثر مشاهدة',
                    value: _getMostViewedStory(),
                    color: const Color(0xFFFF6B6B),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, size: 24, color: color),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStoriesSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'القصص المشاهدة',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${childData.stories?.length ?? 0} قصة',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (childData.stories != null && childData.stories!.isNotEmpty)
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: childData.stories!.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  return StoryCardWidget(story: childData.stories![index]);
                },
              )
            else
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'لا توجد قصص مشاهدة حتى الآن',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddReviewButton() {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onAddReview,
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorManager.primaryColor,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.rate_review_outlined, color: Colors.white),
            SizedBox(width: 8),
            Text(
              'إضافة مراجعة حول تأثير القصص',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String? date) {
    if (date == null) return 'غير محدد';
    try {
      final dateTime = DateTime.parse(date);
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    } catch (e) {
      return date;
    }
  }

  String _getMostViewedStory() {
    if (childData.stories == null || childData.stories!.isEmpty) {
      return 'لا توجد';
    }

    final mostViewed = childData.stories!.reduce(
      (a, b) => (a.totalViews ?? 0) > (b.totalViews ?? 0) ? a : b,
    );

    return '${mostViewed.totalViews} مشاهدة';
  }
}
