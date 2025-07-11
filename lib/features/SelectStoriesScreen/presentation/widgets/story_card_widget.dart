import 'package:flutter/material.dart';
import 'package:wise_child/core/api/api_constants.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'package:wise_child/core/resources/style_manager.dart';
import 'package:wise_child/features/SelectStoriesScreen/data/models/response/stories_by_category_dto/stories_by_category_dto.dart';

class StoryCardWidget extends StatelessWidget {
  final StoriesCategory story;
  final bool isRTL;
  final VoidCallback? onTap;

  const StoryCardWidget({
    super.key,
    required this.story,
    required this.isRTL,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Story Image
              Expanded(
                flex: 3,
                child: _buildStoryImage(),
              ),

              // Story Info
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Story Title
                      Text(
                        story.storyTitle ?? 'قصة بدون عنوان',
                        textDirection:TextDirection.rtl ,
                        style: getBoldStyle(
                          color: ColorManager.primaryColor,
                          fontSize: 11,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 6),

                      // Story Description
                      if (story.storyDescription != null)
                        Expanded(
                          child: Text(
                            story.storyDescription!,
                            textDirection:TextDirection.rtl ,
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey.shade600,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                      const SizedBox(height: 8),

                      // Tags
                      _buildStoryTags(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStoryImage() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: ColorManager.primaryColor.withOpacity(0.1),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: story.imageCover != null && story.imageCover!.isNotEmpty
          ? ClipRRect(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
        child: Image.network(
          '${ApiConstants.urlImage}${story.imageCover}' ,
          fit: BoxFit.fill,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
                    : null,
                color: ColorManager.primaryColor,
                strokeWidth: 2,
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return _buildPlaceholderImage();
          },
        ),
      )
          : _buildPlaceholderImage(),
    );
  }

  Widget _buildPlaceholderImage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.auto_stories,
            size: 32,
            color: ColorManager.primaryColor.withOpacity(0.7),
          ),
          const SizedBox(height: 8),
          Text(
            'غلاف القصة',
            style: TextStyle(
              fontSize: 12,
              color: ColorManager.primaryColor.withOpacity(0.7),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoryTags() {
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: [
        if (story.ageGroup != null)
          _buildStoryTag(
            text: story.ageGroup!,
            color: ColorManager.primaryColor,
          ),
        if (story.gender != null)
          _buildStoryTag(
            text: story.gender!,
            color: Colors.green.shade600,
          ),
        if (story.problem != null)
          _buildStoryTag(
            text: story.problem?.problemTitle??'',
            color: Colors.orange.shade600,
          ),
      ],
    );
  }

  Widget _buildStoryTag({required String text, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 9,
          color: color,
          fontWeight: FontWeight.w600,

        ),
      ),
    );
  }
}