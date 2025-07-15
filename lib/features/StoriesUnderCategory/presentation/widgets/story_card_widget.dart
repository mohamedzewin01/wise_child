import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wise_child/core/api/api_constants.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'package:wise_child/core/resources/style_manager.dart';
import 'package:wise_child/features/StoriesUnderCategory/data/models/response/stories_under_category_dto.dart';

class StoryCardWidget extends StatefulWidget {
  final Stories story;
  final bool isRTL;
  final int index;

  const StoryCardWidget({
    super.key,
    required this.story,
    required this.isRTL,
    required this.index,
  });

  @override
  State<StoryCardWidget> createState() => _StoryCardWidgetState();
}

class _StoryCardWidgetState extends State<StoryCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onStoryTap,
      onTapDown: (_) {
        setState(() => _isHovered = true);
        _hoverController.forward();
        HapticFeedback.lightImpact();
      },
      onTapUp: (_) {
        setState(() => _isHovered = false);
        _hoverController.reverse();
      },
      onTapCancel: () {
        setState(() => _isHovered = false);
        _hoverController.reverse();
      },
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: _isHovered
                    ? ColorManager.primaryColor.withOpacity(0.2)
                    : Colors.grey.shade200,
                blurRadius: _isHovered ? 12 : 8,
                offset: Offset(0, _isHovered ? 6 : 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStoryImage(),
                _buildStoryContent(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStoryImage() {
    return Expanded(
      flex: 3,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black.withOpacity(0.3),
            ],
          ),
        ),
        child: Stack(
          children: [
            _buildImage(),
            _buildOverlayContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    if (widget.story.imageCover != null && widget.story.imageCover!.isNotEmpty) {
      return Hero(
        tag: 'story_image_${widget.story.storyId}_${widget.index}',
        child: Image.network(
          '${ApiConstants.urlImage}${widget.story.imageCover}',
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return _buildImagePlaceholder(isLoading: true);
          },
          errorBuilder: (context, error, stackTrace) {
            return _buildImagePlaceholder(isLoading: false);
          },
        ),
      );
    } else {
      return _buildImagePlaceholder(isLoading: false);
    }
  }

  Widget _buildImagePlaceholder({required bool isLoading}) {
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
            if (isLoading)
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                strokeWidth: 2,
              )
            else
              Icon(
                Icons.auto_stories,
                size: 40,
                color: Colors.white.withOpacity(0.8),
              ),
            const SizedBox(height: 8),
            Text(
              isLoading ? 'جاري التحميل...' : 'غلاف القصة',
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverlayContent() {
    return Positioned(
      top: 8,
      left: 8,
      right: 8,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (widget.story.isActive == true)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Colors.white,
                    size: 12,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'نشطة',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          if (widget.story.viewsCount != null && widget.story.viewsCount! > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.visibility,
                    color: Colors.white,
                    size: 12,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${widget.story.viewsCount}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStoryContent() {
    return Expanded(
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.story.storyTitle ?? 'عنوان القصة',
              style: getBoldStyle(
                color: ColorManager.primaryColor,
                fontSize: 14,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textDirection: widget.isRTL ? TextDirection.rtl : TextDirection.ltr,
            ),
            const SizedBox(height: 6),
            if (widget.story.storyDescription != null)
              Text(
                widget.story.storyDescription!,
                style: getRegularStyle(
                  color: Colors.grey.shade600,
                  fontSize: 11,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textDirection: widget.isRTL ? TextDirection.rtl : TextDirection.ltr,
              ),
            const Spacer(),
            _buildStoryTags(),
          ],
        ),
      ),
    );
  }

  Widget _buildStoryTags() {
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: [
        if (widget.story.gender != null)
          _buildTag(
            widget.story.gender!,
            Colors.blue.shade600,
            Icons.person,
          ),
        if (widget.story.ageGroup != null)
          _buildTag(
            widget.story.ageGroup!,
            Colors.green.shade600,
            Icons.child_care,
          ),
        if (widget.story.createdAt != null)
          _buildTag(
            _formatDate(widget.story.createdAt!),
            Colors.orange.shade600,
            Icons.schedule,
          ),
      ],
    );
  }

  Widget _buildTag(String text, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 0.5,
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
          const SizedBox(width: 2),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 9,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}';
    } catch (e) {
      return 'تاريخ غير صحيح';
    }
  }

  void _onStoryTap() {
    // Navigate to story details or story info page
    // Example:
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => StoryDetailsPage(
    //       storyId: widget.story.storyId!,
    //       childId: currentChildId,
    //     ),
    //   ),
    // );

    // For now, show a placeholder dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(
                Icons.auto_stories,
                color: ColorManager.primaryColor,
                size: 28,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.story.storyTitle ?? 'القصة',
                  style: getBoldStyle(
                    color: ColorManager.primaryColor,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('معرف القصة: ${widget.story.storyId}'),
              const SizedBox(height: 8),
              if (widget.story.storyDescription != null)
                Text(widget.story.storyDescription!),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'إغلاق',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Navigate to story details
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorManager.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('عرض التفاصيل'),
            ),
          ],
        );
      },
    );
  }
}