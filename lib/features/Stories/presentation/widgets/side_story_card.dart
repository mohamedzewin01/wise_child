import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'package:wise_child/core/resources/cashed_image.dart';
import 'package:wise_child/features/Stories/data/models/response/children_stories_model_dto.dart';
import 'package:wise_child/features/StoriesPlay/presentation/pages/StoriesPlay_page.dart';
import 'package:wise_child/features/StoriesPlay/presentation/widgets/story_screen.dart';
import 'package:wise_child/features/StoryDetails/presentation/pages/StoryDetails_page.dart';

import '../bloc/ChildrenStoriesCubit/children_stories_cubit.dart';

class SideStoryCard extends StatefulWidget {
  final StoriesModeData story;
  final int index;


  const SideStoryCard({
    super.key,
    required this.story,
    required this.index,
  });

  @override
  State<SideStoryCard> createState() => _SideStoryCardState();
}

class _SideStoryCardState extends State<SideStoryCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
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
    final gradientColors = _getGradientColors(widget.index);
    final childId=context.read<ChildrenStoriesCubit>().idChildren;

    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        _hoverController.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _hoverController.reverse();
      },
      child: GestureDetector(
        onTap: () => navigateToStory(context,storyId: widget.story.storyId??0,childId: childId),
        child: AnimatedBuilder(
          animation: _hoverController,
          builder: (context, child) {
            final scale = 1.0 + (_hoverController.value * 0.05);
            return Transform.scale(
              scale: scale,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 15 + (_hoverController.value * 10),
                      offset: Offset(0, 8 + (_hoverController.value * 4)),
                      spreadRadius: _hoverController.value * 2,
                    ),
                    if (_isHovered)
                      BoxShadow(
                        color: gradientColors[0].withOpacity(0.3),
                        blurRadius: 25,
                        offset: const Offset(0, 12),
                        spreadRadius: 3,
                      ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  children: [
                    // خلفية الصورة
                    _buildImageBackground(gradientColors),

                    // التدرج العلوي
                    _buildGradientOverlay(),

                    // المحتوى
                    _buildContent(storyId: widget.story.storyId??0,childId: childId),

                    // زر التشغيل العائم
                    _buildFloatingPlayButton(),

                    // الشارات العلوية
                    _buildBadges(),

                    // مؤشر جديد للقصص الحديثة
                    if (widget.index < 2) _buildNewIndicator(),

                    // تأثير hover
                    if (_isHovered) _buildHoverEffect(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }



  Widget _buildImageBackground(List<Color> gradientColors) {
    return Positioned.fill(
      child: Hero(
        tag: 'side_story_image_${widget.story.storyId}',
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradientColors.map((c) => c.withOpacity(0.2)).toList(),
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: widget.story.imageCover != null && widget.story.imageCover!.isNotEmpty
              ? CustomImage(
            url: widget.story.imageCover!,
            height: double.infinity,
            width: double.infinity,

          )
              : Container(
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
                size: 60,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGradientOverlay() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.transparent,
              Colors.black.withOpacity(0.3),
              Colors.black.withOpacity(0.7),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.0, 0.6, 1.0],
          ),
        ),
      ),
    );
  }

  Widget _buildContent({required int childId,required int storyId}) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // عنوان القصة
            Text(
              widget.story.storyTitle ?? 'قصة بدون عنوان',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                height: 1.3,
                shadows: [
                  Shadow(
                    blurRadius: 10.0,
                    color: Colors.black,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 8),

            // وصف القصة
            if (widget.story.storyDescription != null &&
                widget.story.storyDescription!.isNotEmpty)
              Text(
                widget.story.storyDescription!,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.9),
                  height: 1.4,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

            const SizedBox(height: 12),

            // زر التشغيل
            _buildDetailsButton(storyId: storyId,childId: childId),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsButton({required int childId,required int storyId}) {
    return Container(
      width: double.infinity,
      height: 36,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            ColorManager.primaryColor,
            ColorManager.primaryColor.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: ColorManager.primaryColor.withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () => navigateToStory(context,storyId: storyId,childId: childId),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.details,
                color: Colors.white,
                size: 18,
              ),
              const SizedBox(width: 6),
              Text(
           "تفاصيل القصة",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingPlayButton() {
    return Positioned(
      top: 12,
      right: 12,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  StoriesPlayPage(
                    childId: widget.story.childrenId ?? 0,
                    storyId: widget.story.storyId ?? 0,
                  ),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(1.0, 0.0),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeInOutCubic,
                  )),
                  child: FadeTransition(
                    opacity: animation,
                    child: child,
                  ),
                );
              },
              transitionDuration: const Duration(milliseconds: 400),
            ),
          );
        },
        child: AnimatedBuilder(
          animation: _hoverController,
          builder: (context, child) {
            final scale = 1.0 + (_hoverController.value * 0.2);
            return Transform.scale(
              scale: scale,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white,
                      Colors.white.withOpacity(0.95),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 12 + (_hoverController.value * 8),
                      offset: Offset(0, 4 + (_hoverController.value * 2)),
                      spreadRadius: _hoverController.value,
                    ),
                    if (_isHovered)
                      BoxShadow(
                        color: ColorManager.primaryColor.withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 6),
                        spreadRadius: 2,
                      ),
                  ],
                ),
                child: Icon(
                  Icons.play_arrow_rounded,
                  color: ColorManager.primaryColor,
                  size: 22,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBadges() {
    return Positioned(
      top: 30,
      left: 12,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.story.ageGroup != null && widget.story.ageGroup!.isNotEmpty)
            _buildBadge(
              '${widget.story.ageGroup} سنة',
              Icons.child_care_rounded,
            ),
          if (widget.story.categoryName != null && widget.story.categoryName!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: _buildBadge(
                widget.story.categoryName!,
                Icons.category_rounded,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBadge(String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: ColorManager.primaryColor,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: ColorManager.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewIndicator() {
    return Positioned(
      top: 2,
      left: 2,
      child: TweenAnimationBuilder<double>(
        duration: const Duration(seconds: 2),
        tween: Tween(begin: 0.0, end: 1.0),
        builder: (context, value, child) {
          final pulseScale = 1.0 + (0.2 * value);
          return Transform.scale(
            scale: pulseScale,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.red.shade400,
                    Colors.pink.shade400,
                    Colors.orange.shade400,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.4),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                'جديد',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHoverEffect() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [
              Colors.white.withOpacity(0.1),
              Colors.transparent,
              Colors.white.withOpacity(0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            width: 1,
          ),
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
      [Colors.cyan.shade400, Colors.blue.shade300],
      [Colors.lime.shade400, Colors.green.shade300],
      [Colors.deepPurple.shade400, Colors.purple.shade300],
      [Colors.teal.shade400, Colors.cyan.shade300],
    ];
    return colorSets[index % colorSets.length];
  }
}
void navigateToStory(BuildContext context, {required int childId,required int storyId}) {
  HapticFeedback.mediumImpact();

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) =>
          StoryDetailsPage(storyId: storyId, childId: childId),
    ),
  );
}