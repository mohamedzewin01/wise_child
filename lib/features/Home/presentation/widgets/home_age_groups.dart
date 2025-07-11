import 'package:flutter/material.dart';
import 'package:wise_child/core/api/api_constants.dart';
import 'package:wise_child/features/Home/data/models/response/get_home_request.dart';

class HomeAgeGroups extends StatelessWidget {
  final List<StoriesByAgeGroup> ageGroups;

  const HomeAgeGroups({
    super.key,
    required this.ageGroups,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    if (ageGroups.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'القصص حسب الفئة العمرية',
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () => _viewAllAgeGroups(context),
                child: Text(
                  'عرض الكل',
                  style: TextStyle(color: colorScheme.primary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 280,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemCount: ageGroups.length,
              itemBuilder: (context, index) {
                final ageGroup = ageGroups[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: _buildAgeGroupCard(
                    context: context,
                    ageGroup: ageGroup,
                    colorScheme: colorScheme,
                    textTheme: textTheme,
                    index: index,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAgeGroupCard({
    required BuildContext context,
    required StoriesByAgeGroup ageGroup,
    required ColorScheme colorScheme,
    required TextTheme textTheme,
    required int index,
  }) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal,
    ];
    final color = colors[index % colors.length];

    return GestureDetector(
      onTap: () => _viewAgeGroupDetails(context, ageGroup),
      child: Container(
        width: 200,
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
          border: Border.all(
            color: color.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with age group name and count
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getAgeGroupIcon(ageGroup.ageGroup ?? ''),
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ageGroup.ageGroup ?? 'غير محدد',
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                        ),
                        Text(
                          '${ageGroup.count ?? 0} قصة',
                          style: textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Stories list
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: _buildStoriesList(
                  ageGroup.stories ?? [],
                  textTheme,
                  colorScheme,
                ),
              ),
            ),

            // View all button
            Padding(
              padding: const EdgeInsets.all(12),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _viewAgeGroupDetails(context, ageGroup),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  child: Text(
                    'عرض الكل',
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoriesList(
      List<Stories> stories,
      TextTheme textTheme,
      ColorScheme colorScheme,
      ) {
    if (stories.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.book_outlined,
              size: 40,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 8),
            Text(
              'لا توجد قصص',
              style: textTheme.bodyMedium?.copyWith(
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: stories.length > 3 ? 3 : stories.length,
      itemBuilder: (context, index) {
        final story = stories[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: _buildStoryItem(story, textTheme),
        );
      },
    );
  }

  Widget _buildStoryItem(Stories story, TextTheme textTheme) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Story image
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Container(
              width: 40,
              height: 40,
              color: Colors.grey[200],
              child: story.imageCover?.isNotEmpty == true
                  ? Image.network(
                "${ApiConstants.urlImage}${story.imageCover}",
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildPlaceholderImage();
                },
              )
                  : _buildPlaceholderImage(),
            ),
          ),
          const SizedBox(width: 8),

          // Story info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  story.storyTitle ?? 'بدون عنوان',
                  style: textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  story.categoryName ?? 'عام',
                  style: textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      color: Colors.grey[200],
      child: const Center(
        child: Icon(
          Icons.book,
          size: 20,
          color: Colors.grey,
        ),
      ),
    );
  }

  IconData _getAgeGroupIcon(String ageGroup) {
    if (ageGroup.contains('3-5') || ageGroup.contains('3 إلى 5')) {
      return Icons.child_care;
    } else if (ageGroup.contains('6-8') || ageGroup.contains('6 إلى 8')) {
      return Icons.school;
    } else if (ageGroup.contains('9-12') || ageGroup.contains('9 إلى 12')) {
      return Icons.menu_book;
    } else if (ageGroup.contains('13+') || ageGroup.contains('13 فأكثر')) {
      return Icons.auto_stories;
    }
    return Icons.groups;
  }

  void _viewAllAgeGroups(BuildContext context) {
    // Navigate to age groups page
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('عرض جميع الفئات العمرية')),
    );
  }

  void _viewAgeGroupDetails(BuildContext context, StoriesByAgeGroup ageGroup) {
    // Navigate to specific age group details
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('عرض تفاصيل الفئة العمرية: ${ageGroup.ageGroup}'),
      ),
    );
  }
}