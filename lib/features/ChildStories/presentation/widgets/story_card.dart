// lib/features/ChildStories/presentation/widgets/story_card.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wise_child/core/api/api_constants.dart';
import 'package:wise_child/features/ChildStories/data/models/response/get_child_stories_dto.dart';
import 'package:wise_child/features/Children/data/models/response/get_children_dto.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'package:wise_child/core/resources/style_manager.dart';
import 'package:wise_child/features/StoryDetails/presentation/pages/StoryDetails_page.dart';
import 'package:wise_child/localization/locale_cubit.dart';

class StoryCard extends StatefulWidget {
  final Stories story;
  final Children child;
  final int index;
  final bool isRTL;

  const StoryCard({
    super.key,
    required this.story,
    required this.child,
    required this.index,
    required this.isRTL,
  });

  @override
  State<StoryCard> createState() => _StoryCardState();
}

class _StoryCardState extends State<StoryCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _elevationAnimation = Tween<double>(
      begin: 1.0,
      end: 0.5,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown() {
    setState(() => _isPressed = true);
    _animationController.forward();
    HapticFeedback.lightImpact();
  }

  void _onTapUp() {
    setState(() => _isPressed = false);
    _animationController.reverse();
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
    _animationController.reverse();
  }

  void _onTap() {
    HapticFeedback.selectionClick();

    Navigator.push(context, MaterialPageRoute(
      builder: (context) => StoryDetailsPage(storyId: widget.story.storyId??0,childId:widget.child.idChildren??0,isRTL: widget.isRTL ,),
    ));
  }

  Color _getStoryColor() {
    final colors = [
      Colors.purple.shade400,
      Colors.blue.shade400,
      Colors.green.shade400,
      Colors.orange.shade400,
      Colors.pink.shade400,
      Colors.teal.shade400,
      Colors.indigo.shade400,
      Colors.red.shade400,
    ];
    return colors[widget.index % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    final languageCode = LocaleCubit.get(context).state.languageCode;
    final storyColor = _getStoryColor();

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: (_) => _onTapDown(),
            onTapUp: (_) => _onTapUp(),
            onTapCancel: _onTapCancel,
            onTap: _onTap,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08 * _elevationAnimation.value),
                    blurRadius: 20 * _elevationAnimation.value,
                    offset: Offset(0, 8 * _elevationAnimation.value),
                    spreadRadius: 2 * _elevationAnimation.value,
                  ),
                  BoxShadow(
                    color: storyColor.withOpacity(0.2 * _elevationAnimation.value),
                    blurRadius: 15 * _elevationAnimation.value,
                    offset: Offset(0, 4 * _elevationAnimation.value),
                    spreadRadius: 1 * _elevationAnimation.value,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white,
                        storyColor.withOpacity(0.02),
                        Colors.white,
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                    border: Border.all(
                      color: storyColor.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image Section
                      _buildImageSection(storyColor),

                      // Content Section
                      _buildContentSection(storyColor, languageCode),

                      // Footer Section

                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildImageSection(Color storyColor) {
    return Expanded(
      flex: 3,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  storyColor.withOpacity(0.8),
                  storyColor.withOpacity(0.6),
                ],
              ),
            ),
            child: widget.story.imageCover != null
                ? Image.network(
             '${ApiConstants.urlImage}${ widget.story.imageCover}',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return _buildPlaceholderImage(storyColor);
              },
            )
                : _buildPlaceholderImage(storyColor),
          ),

          // Status Badge
          if (widget.story.isActive == 1)
            Positioned(
              top: 12,
              left: widget.isRTL ? null : 12,
              right: widget.isRTL ? 12 : null,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.shade600,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  widget.isRTL ? 'نشط' : 'Active',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

          // Views Badge
          Positioned(
            bottom: 12,
            right: widget.isRTL ? null : 12,
            left: widget.isRTL ? 12 : null,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                textDirection: widget.isRTL ? TextDirection.rtl : TextDirection.ltr,
                children: [
                  Icon(
                    Icons.visibility_outlined,
                    color: Colors.white,
                    size: 12,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${widget.story.viewsCount ?? 0}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderImage(Color storyColor) {
    return Center(
      child: Icon(
        Icons.auto_stories_outlined,
        color: Colors.white,
        size: 40,
      ),
    );
  }

  Widget _buildContentSection(Color storyColor, String languageCode) {
    return Expanded(
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: widget.isRTL ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            // Title with difficulty indicator
            Row(
              textDirection: widget.isRTL ? TextDirection.rtl : TextDirection.ltr,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    widget.story.storyTitle ?? '',
                    style: getBoldStyle(
                      color: ColorManager.primaryColor,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textDirection: widget.isRTL ? TextDirection.rtl : TextDirection.ltr,
                  ),
                ),
                const SizedBox(width: 4),

              ],
            ),

            const SizedBox(height: 8),

            // Description with enhanced styling
            if (widget.story.storyDescription != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: storyColor.withOpacity(0.03),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: storyColor.withOpacity(0.08),
                    width: 0.5,
                  ),
                ),
                child: Text(
                  widget.story.storyDescription!,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 11,
                    height: 1.3,
                    fontStyle: FontStyle.italic,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textDirection: widget.isRTL ? TextDirection.rtl : TextDirection.ltr,
                ),
              ),


          ],
        ),
      ),
    );
  }

}