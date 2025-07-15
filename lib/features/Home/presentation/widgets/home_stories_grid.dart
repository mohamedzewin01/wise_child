import 'package:flutter/material.dart';
import 'package:wise_child/core/api/api_constants.dart';
import 'package:wise_child/core/resources/style_manager.dart';
import 'package:wise_child/features/Home/data/models/response/get_home_request.dart';
import 'package:wise_child/features/Home/presentation/widgets/all_stories_page.dart';
import 'package:wise_child/features/StoryInfo/presentation/pages/StoryInfo_page.dart';

enum StoriesType { topViewed, topInactive }

class HomeStoriesGrid extends StatelessWidget {
  final String title;
  final bool? isActive;
  final List<dynamic> stories;
  final StoriesType type;

  const HomeStoriesGrid({
    super.key,
    required this.title,
    required this.stories,
    required this.type, this.isActive=true,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    if (stories.isEmpty) {
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
                title,
                style:getSemiBoldStyle(
                  fontSize: 16,
                  color: Colors.black87,
                )
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AllStoriesPage(
                        title: title,
                        stories: stories,
                        type: type,
                      ),
                    ),
                  );
                },
                child: Text(
                  'عرض الكل',
                  style:getSemiBoldStyle(
                    color: colorScheme.primary,
                  )
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 205,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: stories.length > 5 ? 5 : stories.length,
              itemBuilder: (context, index) {
                final story = stories[index];
                return Padding(
                  padding: EdgeInsets.only(
                    right: index == 0 ? 6 : 12,
                  ),
                  child: _buildStoryCard(
                    isActive: isActive??true,
                    context: context,
                    story: story,
                    colorScheme: colorScheme,
                    textTheme: textTheme,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoryCard({
    required bool isActive,
    required BuildContext context,
    required dynamic story,
    required ColorScheme colorScheme,
    required TextTheme textTheme,
  }) {
    final String title = story is TopViewedStories
        ? story.storyTitle ?? 'بدون عنوان'
        : story is TopInactiveStories
        ? story.storyTitle ?? 'بدون عنوان'
        : 'بدون عنوان';

    final String imageUrl = story is TopViewedStories
        ? story.imageCover ?? ''
        : story is TopInactiveStories
        ? story.imageCover ?? ''
        : '';

    final int viewsCount = story is TopViewedStories
        ? story.viewsCount ?? 0
        : story is TopInactiveStories
        ? story.viewsCount ?? 0
        : 0;

    final String categoryName = story is TopViewedStories
        ? story.categoryName ?? 'عام'
        : story is TopInactiveStories
        ? story.categoryName ?? 'عام'
        : 'عام';

    final String ageGroup = story is TopViewedStories
        ? story.ageGroup ?? ''
        : story is TopInactiveStories
        ? story.ageGroup ?? ''
        : '';

    final String gender = story is TopViewedStories
        ? story.gender ?? ''
        : story is TopInactiveStories
        ? story.gender ?? ''
        : '';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StoryInfoPage(
              storyId: story.storyId ?? 0,
              isRTL: true, // أو false حسب اللغة
            ),
          ),
        );
      },
      child:
      Container(
        width: 160,
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
            // Story Image
            Container(
              height: 100,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                color: colorScheme.primary.withOpacity(0.1),
              ),
              child: Stack(
                children: [
                  // صورة القصة
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                      child: imageUrl.isNotEmpty
                          ? Image.network(
                        "${ApiConstants.urlImage}$imageUrl",
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return _buildPlaceholderImage(colorScheme);
                        },
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return _buildPlaceholderImage(colorScheme);
                        },
                      )
                          : _buildPlaceholderImage(colorScheme),
                    ),
                  ),

                  // تغطية عند عدم التفعيل
                  if (!isActive)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.visibility_off, color: Colors.white.withOpacity(0.5), size: 30),
                              const SizedBox(height: 4),
                              Text(
                                'غير متاحة حالياً',
                                style: textTheme.bodyMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),


            // Story Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Story Title
                    Text(
                      title,
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),

                    // Category
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        categoryName,
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const Spacer(),

                    // Story Info
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.visibility,
                              size: 14,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '$viewsCount',
                              style: textTheme.bodySmall?.copyWith(
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        if (ageGroup.isNotEmpty)
                          Text(
                            ageGroup,
                            style: textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                      ],
                    ),

                    if (gender.isNotEmpty)
                      const SizedBox(height: 2),
                    if (gender.isNotEmpty)
                      Text(
                        gender,
                        style: textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage(ColorScheme colorScheme) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.primary.withOpacity(0.1),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Center(
        child: Icon(
          Icons.menu_book,
          size: 40,
          color: colorScheme.primary,
        ),
      ),
    );
  }
}