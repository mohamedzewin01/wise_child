import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'package:wise_child/core/resources/style_manager.dart';

class StoryActionButtons extends StatefulWidget {
  final bool hasChanges;
  final bool isSaving;
  final File? selectedImage;
  final bool showDeleteConfirmation;
  final VoidCallback onCancel;
  final VoidCallback onUploadImage;
  final VoidCallback onConfirmDelete;
  final VoidCallback onSaveStory;

  const StoryActionButtons({
    super.key,
    required this.hasChanges,
    required this.isSaving,
    required this.selectedImage,
    required this.showDeleteConfirmation,
    required this.onCancel,
    required this.onUploadImage,
    required this.onConfirmDelete,
    required this.onSaveStory,
  });

  @override
  State<StoryActionButtons> createState() => _StoryActionButtonsState();
}

class _StoryActionButtonsState extends State<StoryActionButtons>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _pulseController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void didUpdateWidget(StoryActionButtons oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.hasChanges != oldWidget.hasChanges) {
      if (widget.hasChanges) {
        _slideController.forward();
        _startPulseAnimation();
      } else {
        _slideController.reverse();
        _pulseController.stop();
      }
    }
  }

  void _startPulseAnimation() {
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _slideController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.hasChanges) return const SizedBox.shrink();

    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _buildActionButtons(),
        ),
      ),
    );
  }

  List<Widget> _buildActionButtons() {
    List<Widget> buttons = [];

    // زر الإلغاء
    buttons.add(_buildCancelButton());

    // زر رفع الصورة الجديدة
    if (widget.selectedImage != null) {
      buttons.add(_buildUploadImageButton());
    }

    // زر تأكيد الحذف
    if (widget.showDeleteConfirmation) {
      buttons.add(_buildDeleteConfirmationButton());
    }

    // زر حفظ القصة
    if (widget.selectedImage == null && !widget.showDeleteConfirmation) {
      buttons.add(_buildSaveStoryButton());
    }

    return buttons;
  }

  Widget _buildCancelButton() {
    return _ActionButton(
      onPressed: widget.isSaving ? null : widget.onCancel,
      backgroundColor: Colors.grey.shade600,
      foregroundColor: Colors.white,
      icon: Icons.close,
      label: 'إلغاء',
      isLoading: false,
    );
  }

  Widget _buildUploadImageButton() {
    return ScaleTransition(
      scale: _pulseAnimation,
      child: _ActionButton(
        onPressed: widget.isSaving ? null : widget.onUploadImage,
        backgroundColor: ColorManager.primaryColor,
        foregroundColor: Colors.white,
        icon: Icons.cloud_upload,
        label: widget.isSaving ? 'جاري الرفع...' : 'رفع الصورة',
        isLoading: widget.isSaving,
      ),
    );
  }

  Widget _buildDeleteConfirmationButton() {
    return ScaleTransition(
      scale: _pulseAnimation,
      child: _ActionButton(
        onPressed: widget.isSaving ? null : widget.onConfirmDelete,
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        icon: Icons.delete_forever,
        label: widget.isSaving ? 'جاري الحذف...' : 'تأكيد الحذف',
        isLoading: widget.isSaving,
      ),
    );
  }

  Widget _buildSaveStoryButton() {
    return _ActionButton(
      onPressed: widget.isSaving ? null : widget.onSaveStory,
      backgroundColor: Colors.green.shade600,
      foregroundColor: Colors.white,
      icon: Icons.bookmark_add,
      label: widget.isSaving ? 'جاري الحفظ...' : 'حفظ القصة',
      isLoading: widget.isSaving,
    );
  }
}

class _ActionButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color foregroundColor;
  final IconData icon;
  final String label;
  final bool isLoading;

  const _ActionButton({
    required this.onPressed,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.icon,
    required this.label,
    required this.isLoading,
  });

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        if (widget.onPressed != null) {
          _controller.forward();
          HapticFeedback.lightImpact();
        }
      },
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          constraints: const BoxConstraints(minWidth: 120),
          child: Material(
            color: widget.backgroundColor.withOpacity(
              widget.onPressed != null ? 1.0 : 0.6,
            ),
            borderRadius: BorderRadius.circular(20),
            elevation: widget.onPressed != null ? 4 : 2,
            child: InkWell(
              onTap: widget.onPressed,
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.isLoading) ...[
                      SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            widget.foregroundColor,
                          ),
                        ),
                      ),
                    ] else ...[
                      Icon(
                        widget.icon,
                        color: widget.foregroundColor,
                        size: 18,
                      ),
                    ],
                    const SizedBox(width: 8),
                    Text(
                      widget.label,
                      style: getBoldStyle(
                        color: widget.foregroundColor,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// مكون محسن لعرض حالة التحميل في الأزرار
class LoadingButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback? onPressed;
  final String text;
  final String loadingText;
  final IconData icon;
  final Color backgroundColor;
  final Color foregroundColor;
  final double borderRadius;
  final EdgeInsetsGeometry padding;

  const LoadingButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
    required this.text,
    required this.loadingText,
    required this.icon,
    this.backgroundColor = Colors.blue,
    this.foregroundColor = Colors.white,
    this.borderRadius = 12,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: ElevatedButton.icon(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          disabledBackgroundColor: backgroundColor.withOpacity(0.6),
          disabledForegroundColor: foregroundColor.withOpacity(0.7),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          padding: padding,
          elevation: isLoading ? 2 : 4,
        ),
        icon: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: isLoading
              ? SizedBox(
            key: const ValueKey('loading'),
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(foregroundColor),
            ),
          )
              : Icon(
            icon,
            key: const ValueKey('icon'),
            size: 18,
          ),
        ),
        label: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: Text(
            isLoading ? loadingText : text,
            key: ValueKey(isLoading ? 'loading_text' : 'normal_text'),
            style: getBoldStyle(
              color: foregroundColor,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}

// مكون لعرض التقدم مع النص
class ProgressButton extends StatelessWidget {
  final double? progress;
  final String text;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color progressColor;

  const ProgressButton({
    super.key,
    this.progress,
    required this.text,
    this.onPressed,
    this.backgroundColor = Colors.blue,
    this.progressColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: backgroundColor,
      ),
      child: Stack(
        children: [
          if (progress != null)
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    progressColor.withOpacity(0.3),
                  ),
                ),
              ),
            ),
          Center(
            child: Text(
              text,
              style: getBoldStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}