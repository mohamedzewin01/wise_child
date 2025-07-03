import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wise_child/core/api/api_constants.dart';
import 'package:wise_child/features/StoryDetails/presentation/pages/StoryDetails_page.dart';

class StoryItemWidget extends StatelessWidget {
  final dynamic story;
  final int childId;

  const StoryItemWidget({super.key, required this.story, required this.childId});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                StoryDetailsPage(storyId: story.storyId, childId: childId),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            _buildStoryImage(),
            const SizedBox(width: 16),
            Expanded(child: _buildStoryInfo()),
            _buildArrowIcon(),
          ],
        ),
      ),
    );
  }

  Widget _buildStoryImage() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey.shade200,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: story.imageCover != null
            ? CachedNetworkImage(
                imageUrl: '${ApiConstants.urlImage}${story.imageCover!}',
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => Icon(
                  Icons.book_rounded,
                  color: Colors.grey.shade600,
                  size: 24,
                ),
              )
            : Icon(Icons.book_rounded, color: Colors.grey.shade600, size: 24),
      ),
    );
  }

  Widget _buildStoryInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          story.storyTitle ?? 'قصة بدون عنوان',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          story.storyDescription ?? '',
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          maxLines: 2,

          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildArrowIcon() {
    return Icon(
      Icons.arrow_forward_ios_rounded,
      size: 16,
      color: Colors.grey.shade400,
    );
  }
}
