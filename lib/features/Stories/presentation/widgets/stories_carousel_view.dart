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

class StoriesCarouselView extends StatefulWidget {
  final List<StoriesModeData> stories;
  final AnimationController controller;

  const StoriesCarouselView({
    super.key,
    required this.stories,
    required this.controller,
  });

  @override
  State<StoriesCarouselView> createState() => _StoriesCarouselViewState();
}

class _StoriesCarouselViewState extends State<StoriesCarouselView>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _slideController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: 0.85,
      initialPage: 0,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, child) {
        return Opacity(
          opacity: widget.controller.value,
          child: Column(
            children: [
              // مؤشر الصفحات
              _buildPageIndicator(),

              const SizedBox(height: 16),

              // الشريط الرئيسي
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() => _currentIndex = index);
                    _slideController.forward().then((_) {
                      _slideController.reverse();
                    });
                  },
                  itemCount: widget.stories.length,
                  itemBuilder: (context, index) {
                    final story = widget.stories[index];
                    final isActive = index == _currentIndex;

                    return TweenAnimationBuilder<double>(
                      duration: Duration(milliseconds: 800 + (index * 100)),
                      tween: Tween(begin: 0.0, end: 1.0),
                      curve: Curves.easeOutCubic,
                      builder: (context, value, child) {
                        return Transform.translate(
                          offset: Offset(0, 30 * (1 - value)),
                          child: Opacity(
                            opacity: value,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOutCubic,
                              margin: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: isActive ? 0 : 20,
                              ),
                              child: StoryCarouselCard(
                                story: story,
                                index: index,
                                isActive: isActive,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),

              // أزرار التنقل
              _buildNavigationButtons(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPageIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          widget.stories.length,
              (index) => AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 3),
            width: index == _currentIndex ? 20 : 8,
            height: 8,
            decoration: BoxDecoration(
              gradient: index == _currentIndex
                  ? LinearGradient(
                colors: [
                  ColorManager.primaryColor,
                  ColorManager.primaryColor.withOpacity(0.7),
                ],
              )
                  : null,
              color: index == _currentIndex
                  ? null
                  : ColorManager.primaryColor.withOpacity(0.3),
              borderRadius: BorderRadius.circular(4),
              boxShadow: index == _currentIndex
                  ? [
                BoxShadow(
                  color: ColorManager.primaryColor.withOpacity(0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
                  : [],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // زر السابق
          _buildNavButton(
            icon: Icons.chevron_left_rounded,
            onTap: _currentIndex > 0
                ? () {
              _pageController.previousPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            }
                : null,
          ),

          // معلومات الصفحة
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: ColorManager.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: ColorManager.primaryColor.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Text(
              '${_currentIndex + 1} من ${widget.stories.length}',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: ColorManager.primaryColor,
              ),
            ),
          ),

          // زر التالي
          _buildNavButton(
            icon: Icons.chevron_right_rounded,
            onTap: _currentIndex < widget.stories.length - 1
                ? () {
              _pageController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            }
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildNavButton({
    required IconData icon,
    VoidCallback? onTap,
  }) {
    final isEnabled = onTap != null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: isEnabled
              ? LinearGradient(
            colors: [
              ColorManager.primaryColor,
              ColorManager.primaryColor.withOpacity(0.8),
            ],
          )
              : null,
          color: isEnabled ? null : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isEnabled
              ? [
            BoxShadow(
              color: ColorManager.primaryColor.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ]
              : [],
        ),
        child: Icon(
          icon,
          color: isEnabled ? Colors.white : Colors.grey.shade500,
          size: 20,
        ),
      ),
    );
  }
}

class StoryCarouselCard extends StatefulWidget {
  final StoriesModeData story;
  final int index;
  final bool isActive;

  const StoryCarouselCard({
    super.key,
    required this.story,
    required this.index,
    required this.isActive,
  });

  @override
  State<StoryCarouselCard> createState() => _StoryCarouselCardState();
}

class _StoryCarouselCardState extends State<StoryCarouselCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  bool _isPressed = false;

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
    final childId = context
        .read<ChildrenStoriesCubit>()
        .idChildren;
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
          final scale = 1.0 - (_hoverController.value * 0.03);
          final elevation = widget.isActive ? 15.0 : 8.0;
          final finalElevation = elevation + (_hoverController.value * 10);

          return Transform.scale(
            scale: scale,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: finalElevation,
                    offset: Offset(0, finalElevation / 2),
                    spreadRadius: 2,
                  ),
                  if (widget.isActive)
                    BoxShadow(
                      color: gradientColors[0].withOpacity(0.3),
                      blurRadius: finalElevation + 10,
                      offset: Offset(0, finalElevation / 3),
                      spreadRadius: 4,
                    ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // خلفية الصورة
                    _buildImageBackground(gradientColors),

                    // التدرج العلوي
                    _buildGradientOverlay(),

                    // المحتوى الرئيسي
                    _buildMainContent(childId),

                    // العناصر العائمة
                    _buildFloatingElements(),

                    // الشارات
                    _buildBadges(),

                    // تأثير النشاط
                    if (widget.isActive) _buildActiveEffect(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildImageBackground(List<Color> gradientColors) {
    return Hero(
      tag: 'story_carousel_image_${widget.story.storyId}',
      child: widget.story.imageCover != null &&
          widget.story.imageCover!.isNotEmpty
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
            stops: const [0.0, 0.6, 1.0],
          ),
        ),
        child: Center(
          child: Icon(
            Icons.auto_stories_rounded,
            size: 80,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ),
    );
  }

  Widget _buildGradientOverlay() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            Colors.black.withOpacity(0.2),
            Colors.black.withOpacity(0.7),
            Colors.black.withOpacity(0.9),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.0, 0.4, 0.7, 1.0],
        ),
      ),
    );
  }

  Widget _buildMainContent(int childId) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // العنوان
            Text(
              widget.story.storyTitle ?? 'قصة بدون عنوان',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                height: 1.3,
                shadows: [
                  Shadow(
                    blurRadius: 15.0,
                    color: Colors.black,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 8),

            // الوصف
            if (widget.story.storyDescription != null &&
                widget.story.storyDescription!.isNotEmpty)
              Text(
                widget.story.storyDescription!,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.9),
                  height: 1.4,
                  shadows: const [
                    Shadow(
                      blurRadius: 10.0,
                      color: Colors.black,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),

            const SizedBox(height: 16),

            // أزرار الأكشن
            _buildActionButtons(childId),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(int childId) {
    return Row(
      children: [
        // زر التفاصيل
        Expanded(
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  ColorManager.primaryColor,
                  ColorManager.primaryColor.withOpacity(0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
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
                borderRadius: BorderRadius.circular(20),
                onTap: () => _navigateToStoryDetails(context, childId),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'التفاصيل',
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
          ),
        ),

        const SizedBox(width: 12),

        // زر التشغيل
        Expanded(
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.green.shade400,
                  Colors.green.shade600,
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withOpacity(0.4),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () => _navigateToStoryPlay(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'تشغيل',
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
          ),
        ),
      ],
    );
  }

  Widget _buildFloatingElements() {
    return Positioned(
      top: 16,
      right: 16,
      child: Column(
        children: [
          // زر المفضلة
          _buildFloatingButton(
            icon: Icons.favorite_border_rounded,
            color: Colors.red.shade400,
            onTap: () {
              // إضافة للمفضلة
            },
          ),

          const SizedBox(height: 8),

          // زر المشاركة
          _buildFloatingButton(
            icon: Icons.share_rounded,
            color: Colors.blue.shade400,
            onTap: () {
              // مشاركة القصة
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
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
          icon,
          color: color,
          size: 16,
        ),
      ),
    );
  }

  Widget _buildBadges() {
    return Positioned(
      top: 16,
      left: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.story.ageGroup != null &&
              widget.story.ageGroup!.isNotEmpty)
            _buildBadge(
              '${widget.story.ageGroup} سنة',
              Icons.child_care_rounded,
              Colors.blue.shade400,
            ),
          if (widget.story.categoryName != null &&
              widget.story.categoryName!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: _buildBadge(
                widget.story.categoryName!,
                Icons.category_rounded,
                Colors.green.shade400,
              ),
            ),

          // مؤشر جديد
          if (widget.index < 2)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: _buildNewIndicator(),
            ),
        ],
      ),
    );
  }

  Widget _buildBadge(String text, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewIndicator() {
    return TweenAnimationBuilder<double>(
      duration: const Duration(seconds: 2),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: 1.0 + (0.15 * value),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.red.withOpacity(0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Text(
              'جديد',
              style: TextStyle(
                color: Colors.white,
                fontSize: 9,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildActiveEffect() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 2,
        ),
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.transparent,
            Colors.white.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }

  void _navigateToStoryDetails(BuildContext context, int childId) {
    HapticFeedback.mediumImpact();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            StoryDetailsPage(
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
        builder: (context) =>
            StoriesPlayPage(
              childId: widget.story.childrenId ?? 0,
              storyId: widget.story.storyId ?? 0,
            ),
      ),
    );
  }

  List<Color> _getGradientColors(int index) {
    final colorSets = [
      [Colors.blue.shade400, Colors.purple.shade300, Colors.pink.shade200],
      [Colors.green.shade400, Colors.teal.shade300, Colors.cyan.shade200],
      [Colors.orange.shade400, Colors.red.shade300, Colors.pink.shade200],
      [Colors.purple.shade400, Colors.indigo.shade300, Colors.blue.shade200],
      [Colors.amber.shade400, Colors.orange.shade300, Colors.red.shade200],
      [Colors.cyan.shade400, Colors.blue.shade300, Colors.indigo.shade200],
    ];
    return colorSets[index % colorSets.length];
  }
}