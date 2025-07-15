import 'package:flutter/material.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'package:wise_child/core/resources/style_manager.dart';
import 'package:wise_child/core/widgets/expandable_text.dart';
import 'package:wise_child/features/StoryInfo/data/models/response/story_info_dto.dart';

class StoryInfoDescriptionSection extends StatelessWidget {
  final StoryInfo story;
  final bool isRTL;

  const StoryInfoDescriptionSection({
    super.key,
    required this.story,
    required this.isRTL,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 1200),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'وصف القصة',
                  style: getBoldStyle(
                    color: ColorManager.primaryColor,
                    fontSize: 18,
                  ),
                  textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.grey.shade200,
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade100,
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: _buildDescriptionContent(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDescriptionContent() {
    if (story.storyDescription == null || story.storyDescription!.isEmpty) {
      return Row(
        children: [
          Icon(
            Icons.info_outline,
            color: Colors.grey.shade400,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'لا يوجد وصف متاح للقصة',
              style: getRegularStyle(
                color: Colors.grey.shade500,
                fontSize: 14,
              ),
              textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
            ),
          ),
        ],
      );
    }

    // Check if ExpandableText widget exists, otherwise use regular Text
    return _buildExpandableOrRegularText();
  }

  Widget _buildExpandableOrRegularText() {
    // Try to use ExpandableText if available, otherwise use regular Text
    try {
      return ExpandableText(
        description: story.storyDescription!,
        isRTL: isRTL,
      );
    } catch (e) {
      // If ExpandableText is not available, use regular Text with Show More/Less functionality
      return _CustomExpandableText(
        text: story.storyDescription!,
        isRTL: isRTL,
      );
    }
  }
}

class _CustomExpandableText extends StatefulWidget {
  final String text;
  final bool isRTL;
  final int maxLines;

  const _CustomExpandableText({
    required this.text,
    required this.isRTL,
    this.maxLines = 10,
  });

  @override
  State<_CustomExpandableText> createState() => _CustomExpandableTextState();
}

class _CustomExpandableTextState extends State<_CustomExpandableText> {
  bool _isExpanded = false;
  bool _hasOverflow = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkOverflow();
    });
  }

  void _checkOverflow() {
    final textPainter = TextPainter(
      text: TextSpan(
        text: widget.text,
        style: const TextStyle(fontSize: 14, height: 1.4),
      ),
      maxLines: widget.maxLines,
      textDirection: widget.isRTL ? TextDirection.rtl : TextDirection.ltr,
    );

    textPainter.layout(maxWidth: MediaQuery
        .of(context)
        .size
        .width - 80);

    if (mounted) {
      setState(() {
        _hasOverflow = textPainter.didExceedMaxLines;
      });
    }

    textPainter.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.text,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black87,
            height: 1.4,
          ),
          textDirection: widget.isRTL ? TextDirection.rtl : TextDirection.ltr,
          maxLines: _isExpanded ? null : widget.maxLines,
          overflow: _isExpanded ? null : TextOverflow.ellipsis,
        ),
        if (_hasOverflow) ...[
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Text(
              _isExpanded ? 'عرض أقل' : 'عرض المزيد',
              style: TextStyle(
                color: ColorManager.primaryColor,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              textDirection: widget.isRTL ? TextDirection.rtl : TextDirection
                  .ltr,
            ),
          ),
        ],
      ],
    );
  }
}