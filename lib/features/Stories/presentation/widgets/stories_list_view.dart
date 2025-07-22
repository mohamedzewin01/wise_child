import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'package:wise_child/core/resources/cashed_image.dart';
import 'package:wise_child/features/Stories/data/models/response/children_stories_model_dto.dart';
import 'package:wise_child/features/Stories/presentation/bloc/ChildrenStoriesCubit/children_stories_cubit.dart';
import 'package:wise_child/features/StoriesPlay/presentation/pages/StoriesPlay_page.dart';
import 'package:wise_child/features/StoriesPlay/presentation/widgets/story_screen.dart';
import 'package:wise_child/features/StoryDetails/presentation/pages/StoryDetails_page.dart';

class StoriesListView extends StatelessWidget {
  final List<StoriesModeData> stories;
  final AnimationController controller;

  const StoriesListView({
    super.key,
    required this.stories,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Opacity(
          opacity: controller.value,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            itemCount: stories.length,
            itemBuilder: (context, index) {
              final story = stories[index];

              return TweenAnimationBuilder<double>(
                duration: Duration(milliseconds: 600 + (index * 100)),
                tween: Tween(begin: 0.0, end: 1.0),
                curve: Curves.easeOutCubic,
                builder: (context, value, child) {
                  return Transform.translate(
                    offset: Offset(50 * (1 - value), 0),
                    child: Opacity(
                      opacity: value,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: StoryListCard(
                          story: story,
                          index: index,
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}

class StoryListCard extends StatefulWidget {
  final StoriesModeData story;
  final int index;

  const StoryListCard({
    super.key,
    required this.story,
    required this.index,
  });

  @override
  State<StoryListCard> createState() => _StoryListCardState();
}

class _StoryListCardState extends State<StoryListCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final childId = context.read<ChildrenStoriesCubit>().idChildren;
    final gradientColors = _getGradientColors(widget.index);

    return GestureDetector(
      onTapDown: (_) {
        setState(() => _isPressed = true);
        _hoverController.forward();
      },
      onTapUp: (_) {
        setState(() => _isPressed = false);
        _hoverController.reverse();
        _navigateToStoryDetails(context, childId);
      },
      onTapCancel: () {
        setState(() => _isPressed = false);
        _hoverController.reverse();
      },
      child: AnimatedBuilder(
        animation: _hoverController,
        builder: (context, child) {
          final scale = 1.0 - (_hoverController.value * 0.02);
          final elevation = 8.0 + (_hoverController.value * 8);

          return Transform.scale(
            scale: scale,
            child: Container(
              height: 140,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: [
                    Colors.white,
                    Colors.grey.shade50.withOpacity(0.5),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: elevation,
                    offset: Offset(0, elevation / 2),
                    spreadRadius: 1,
                  ),
                  BoxShadow(
                    color: gradientColors[0].withOpacity(0.1),
                    blurRadius: elevation + 5,
                    offset: Offset(0, elevation / 3),
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Row(
                  children: [
                    // قسم الصورة
                    _buildImageSection(gradientColors),

                    // قسم المحتوى
                    Expanded(
                      child: _buildContentSection(childId),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildImageSection(List<Color> gradientColors) {
    return Container(
      width: 120,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors.map((c) => c.withOpacity(0.3)).toList(),
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // الصورة
          if (widget.story.imageCover != null && widget.story.imageCover!.isNotEmpty)
            Hero(
              tag: 'story_list_image_${widget.story.storyId}',
              child: CustomImage(
                url: widget.story.imageCover!,
                height: double.infinity,
                width: double.infinity,
              ),
            )
          else
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradientColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.auto_stories_rounded,
                  size: 40,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ),

          // تدرج علوي
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.3),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // زر التشغيل العائم
          Positioned(
            top: 8,
            right: 8,
            child: _buildFloatingPlayButton(),
          ),

          // مؤشر جديد
          if (widget.index < 2)
            Positioned(
              top: 8,
              left: 8,
              child: _buildNewBadge(),
            ),
        ],
      ),
    );
  }

  Widget _buildContentSection(int childId) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // العنوان
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.story.storyTitle ?? 'قصة بدون عنوان',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 6),

                // الوصف
                if (widget.story.storyDescription != null &&
                    widget.story.storyDescription!.isNotEmpty)
                  Text(
                    widget.story.storyDescription!,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),

          // الشارات والأزرار
          Row(
            children: [
              // شارات المعلومات
              Expanded(
                child: Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: [
                    if (widget.story.ageGroup != null)
                      _buildInfoBadge(
                        '${widget.story.ageGroup} سنة',
                        Icons.child_care_rounded,
                        Colors.blue,
                      ),
                    if (widget.story.categoryName != null)
                      _buildInfoBadge(
                        widget.story.categoryName!,
                        Icons.category_rounded,
                        Colors.green,
                      ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              // أزرار الأكشن
              _buildActionButtons(childId),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingPlayButton() {
    return GestureDetector(
      onTap: () => _navigateToStoryPlay(),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white,
              Colors.white.withOpacity(0.9),
            ],
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Icon(
          Icons.play_arrow_rounded,
          color: ColorManager.primaryColor,
          size: 18,
        ),
      ),
    );
  }

  Widget _buildNewBadge() {
    return TweenAnimationBuilder<double>(
      duration: const Duration(seconds: 2),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: 1.0 + (0.1 * value),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.red.shade400,
                  Colors.orange.shade400,
                ],
              ),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.red.withOpacity(0.4),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              'جديد',
              style: TextStyle(
                color: Colors.white,
                fontSize: 8,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoBadge(String text, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 10,
            color: color,
          ),
          const SizedBox(width: 3),
          Text(
            text,
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(int childId) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // زر التفاصيل
        _buildActionButton(
          icon: Icons.info_outline_rounded,
          color: ColorManager.primaryColor,
          onTap: () => _navigateToStoryDetails(context, childId),
        ),

        const SizedBox(width: 8),

        // زر التشغيل
        _buildActionButton(
          icon: Icons.play_arrow_rounded,
          color: Colors.green,
          onTap: () => _navigateToStoryPlay(),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Icon(
          icon,
          size: 16,
          color: color,
        ),
      ),
    );
  }

  void _navigateToStoryDetails(BuildContext context, int childId) {
    HapticFeedback.mediumImpact();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StoryDetailsPage(
          storyId: widget.story.storyId ?? 0,
          childId: childId,
        ),
      ),
    );
  }

  void _navigateToStoryPlay() {
    HapticFeedback.mediumImpact();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StoriesPlayPage(
          childId: widget.story.childrenId ?? 0,
          storyId: widget.story.storyId ?? 0,
        ),
      ),
    );
  }

  List<Color> _getGradientColors(int index) {
    final colorSets = [
      [Colors.blue.shade400, Colors.purple.shade300],
      [Colors.green.shade400, Colors.teal.shade300],
      [Colors.orange.shade400, Colors.red.shade300],
      [Colors.pink.shade400, Colors.purple.shade300],
      [Colors.indigo.shade400, Colors.blue.shade300],
      [Colors.amber.shade400, Colors.orange.shade300],
    ];
    return colorSets[index % colorSets.length];
  }
}