import 'package:flutter/material.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'package:wise_child/features/ChildDetailsPage/presentation/widgets/components/info_row_widget.dart';
import 'package:wise_child/features/ChildDetailsPage/presentation/widgets/components/story_item_widget.dart';


class StoriesSection extends StatelessWidget {
  final List stories;
  final int childId;

  const StoriesSection({
    super.key,
    required this.stories, required this.childId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: _buildCardDecoration(),
      child: Column(
        children: [
          _buildHeader(),
          ..._buildStoriesList(),
          if (stories.length > 3) _buildViewAllButton(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.deepPurple,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.auto_stories_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            'القصص المفضلة',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const Spacer(),
          Text(
            '${stories.length} قصة',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildStoriesList() {
    return stories
        .take(3)
        .map((story) => StoryItemWidget(story: story,childId:childId ,))
        .toList();
  }

  Widget _buildViewAllButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: TextButton(
        onPressed: () {
          // Navigate to full stories list
        },
        child: Text(
          'عرض جميع القصص (${stories.length})',
          style: TextStyle(
            color: ColorManager.primaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildCardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          offset: const Offset(0, 4),
          blurRadius: 15,
        ),
      ],
    );
  }
}