import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wise_child/core/api/api_constants.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'package:wise_child/core/resources/style_manager.dart';
import 'package:wise_child/features/StoryInfo/domain/entities/story_info_entities.dart';
import 'package:wise_child/features/StoryInfo/data/models/response/story_info_dto.dart';
import 'package:wise_child/features/StoryInfo/presentation/widgets/story_info_title_section.dart';
import 'package:wise_child/features/StoryInfo/presentation/widgets/story_info_details_section.dart';
import 'package:wise_child/features/StoryInfo/presentation/widgets/story_info_category_section.dart';
import 'package:wise_child/features/StoryInfo/presentation/widgets/story_info_problem_section.dart';
import 'package:wise_child/features/StoryInfo/presentation/widgets/story_info_description_section.dart';

class StoryInfoContent extends StatefulWidget {
  final StoryInfoEntity storyInfo;
  final bool isRTL;

  const StoryInfoContent({
    super.key,
    required this.storyInfo,
    required this.isRTL,
  });

  @override
  State<StoryInfoContent> createState() => _StoryInfoContentState();
}

class _StoryInfoContentState extends State<StoryInfoContent>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startAnimations();
  }

  void _setupAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));
  }

  void _startAnimations() {
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        _fadeController.forward();
        _slideController.forward();
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        _buildSliverAppBar(context),
        SliverToBoxAdapter(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.storyInfo.story != null) ...[
                      StoryInfoTitleSection(
                        story: widget.storyInfo.story!,
                        isRTL: widget.isRTL,
                      ),
                      const SizedBox(height: 20),

                      StoryInfoDetailsSection(
                        story: widget.storyInfo.story!,
                      ),
                      const SizedBox(height: 24),

                      if (widget.storyInfo.story!.storyDescription != null) ...[
                        StoryInfoDescriptionSection(
                          story: widget.storyInfo.story!,
                          isRTL: widget.isRTL,
                        ),
                        const SizedBox(height: 24),
                      ],

                      if (widget.storyInfo.story!.problem != null) ...[
                        StoryInfoProblemSection(
                          problem: widget.storyInfo.story!.problem!,
                          isRTL: widget.isRTL,
                        ),
                        const SizedBox(height: 24),
                      ],

                      if (widget.storyInfo.story!.category != null) ...[
                        StoryInfoCategorySection(
                          category: widget.storyInfo.story!.category!,
                          isRTL: widget.isRTL,
                        ),
                        const SizedBox(height: 100),
                      ],
                    ] else ...[
                      _buildNoDataWidget(),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 320,
      pinned: true,
      backgroundColor: ColorManager.primaryColor,
      leading: _AppBarButton(
        icon: Icons.arrow_back_ios,
        onPressed: () => Navigator.of(context).pop(),
      ),

      flexibleSpace: FlexibleSpaceBar(
        background: _StoryImageWidget(story: widget.storyInfo.story),
      ),
    );
  }

  Widget _buildNoDataWidget() {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          Icon(
            Icons.info_outline,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'لا توجد معلومات متاحة',
            style: getBoldStyle(
              color: Colors.grey.shade600,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'تعذر العثور على تفاصيل القصة',
            style: getRegularStyle(
              color: Colors.grey.shade500,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }


}

// AppBar Button Component
class _AppBarButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _AppBarButton({
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
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
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          icon,
          color: ColorManager.primaryColor,
          size: 20,
        ),
      ),
    );
  }
}

// Story Image Widget
class _StoryImageWidget extends StatelessWidget {
  final StoryInfo? story;

  const _StoryImageWidget({this.story});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.black.withOpacity(0.4),
          ],
        ),
      ),
      child: story?.imageCover != null && story!.imageCover!.isNotEmpty
          ? Hero(
        tag: 'story_image_${story!.storyId}',
        child: Image.network(
          '${ApiConstants.urlImage}${story!.imageCover}',
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return _buildImageLoadingWidget();
          },
          errorBuilder: (context, error, stackTrace) =>
              _buildPlaceholderImage(),
        ),
      )
          : _buildPlaceholderImage(),
    );
  }

  Widget _buildImageLoadingWidget() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            ColorManager.primaryColor.withOpacity(0.3),
            ColorManager.primaryColor.withOpacity(0.6),
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              strokeWidth: 3,
            ),
            const SizedBox(height: 16),
            Text(
              'جاري تحميل صورة القصة...',
              style: getBoldStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            ColorManager.primaryColor.withOpacity(0.8),
            ColorManager.primaryColor,
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 1000),
              tween: Tween(begin: 0.0, end: 1.0),
              builder: (context, value, child) {
                return Transform.scale(
                  scale: 0.8 + (0.2 * value),
                  child: Icon(
                    Icons.auto_stories,
                    size: 80,
                    color: Colors.white.withOpacity(0.9 * value),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 1200),
              tween: Tween(begin: 0.0, end: 1.0),
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Text(
                    'غلاف القصة',
                    style: getBoldStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 20,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}