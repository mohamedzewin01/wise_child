import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wise_child/core/resources/cashed_image.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'package:wise_child/features/StoriesPlay/presentation/pages/StoriesPlay_page.dart';

class EnhancedStoryCard extends StatefulWidget {
  final String title;
  final String description;
  final String ageRange;
  final String category;
  final String imageUrl;
  final int childId;
  final int storyId;
  final int index;

  const EnhancedStoryCard({
    super.key,
    required this.title,
    required this.description,
    required this.ageRange,
    required this.category,
    required this.imageUrl,
    required this.childId,
    required this.storyId,
    required this.index,
  });

  @override
  State<EnhancedStoryCard> createState() => _EnhancedStoryCardState();
}

class _EnhancedStoryCardState extends State<EnhancedStoryCard>
    with TickerProviderStateMixin {
  late AnimationController _hoverController;
  late AnimationController _tapController;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _tapController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    _tapController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _tapController.forward();
    HapticFeedback.lightImpact();
  }

  void _onTapUp(TapUpDetails details) {
    _tapController.reverse();
  }

  void _onTapCancel() {
    _tapController.reverse();
  }

  void _navigateToStory() {
    HapticFeedback.mediumImpact();
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => StoriesPlayPage(
          childId: widget.childId,
          storyId: widget.storyId,
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
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // الألوان المتدرجة حسب الفهرس
    final gradientColors = _getGradientColors(widget.index);

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
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        onTap: _navigateToStory,
        child: AnimatedBuilder(
          animation: Listenable.merge([_hoverController, _tapController]),
          builder: (context, child) {
            final hoverScale = 1.0 + (_hoverController.value * 0.02);
            final tapScale = 1.0 - (_tapController.value * 0.05);
            final combinedScale = hoverScale * tapScale;

            return Transform.scale(
              scale: combinedScale,
              child: Container(
                height: 220,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 20 + (_hoverController.value * 10),
                      offset: Offset(0, 8 + (_hoverController.value * 4)),
                      spreadRadius: _hoverController.value * 2,
                    ),
                    if (_isHovered)
                      BoxShadow(
                        color: gradientColors[0].withOpacity(0.2),
                        blurRadius: 30,
                        offset: const Offset(0, 15),
                        spreadRadius: 5,
                      ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  children: [
                    // الخلفية والصورة
                    _buildImageBackground(gradientColors),

                    // التدرج العلوي
                    _buildGradientOverlay(gradientColors),

                    // المحتوى النصي
                    _buildContent(),

                    // زر التشغيل المحسن
                    _buildPlayButton(),

                    // الشارات العلوية
                    _buildTopBadges(),
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
        tag: 'story_image_${widget.storyId}',
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradientColors.map((c) => c.withOpacity(0.3)).toList(),
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: CustomImage(
            url: widget.imageUrl,
            height: double.infinity,
            width: double.infinity,

          ),
        ),
      ),
    );
  }

  Widget _buildGradientOverlay(List<Color> gradientColors) {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.transparent,
              Colors.black.withOpacity(0.3),
              Colors.black.withOpacity(0.7),
              Colors.black.withOpacity(0.9),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.0, 0.4, 0.7, 1.0],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
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
            // عنوان القصة
            Hero(
              tag: 'story_title_${widget.storyId}',
              child: Material(
                color: Colors.transparent,
                child: Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.2,
                    shadows: [
                      Shadow(
                        blurRadius: 15.0,
                        color: Colors.black,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),

            const SizedBox(height: 8),

            // وصف القصة
            Text(
              widget.description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.9),
                height: 1.4,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 16),

            // زر تشغيل القصة
            _buildActionButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton() {
    return Container(
      width: double.infinity,
      height: 48,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            ColorManager.primaryColor,
            ColorManager.primaryColor.withOpacity(0.8),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: ColorManager.primaryColor.withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: _navigateToStory,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.play_arrow_rounded,
                color: Colors.white,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'تشغيل القصة',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlayButton() {
    return Positioned(
      top: 20,
      right: 20,
      child: AnimatedScale(
        scale: _isHovered ? 1.1 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(
            Icons.play_arrow_rounded,
            color: ColorManager.primaryColor,
            size: 24,
          ),
        ),
      ),
    );
  }

  Widget _buildTopBadges() {
    return Positioned(
      top: 16,
      left: 16,
      child: Wrap(
        spacing: 8,
        children: [
          _buildBadge(widget.ageRange, Icons.child_care),
          if (widget.category.isNotEmpty)
            _buildBadge(widget.category, Icons.category),
        ],
      ),
    );
  }

  Widget _buildBadge(String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: ColorManager.primaryColor,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: ColorManager.primaryColor,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
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