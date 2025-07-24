import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'package:wise_child/core/resources/style_manager.dart';

class StoriesError extends StatefulWidget {
  final String error;
  final VoidCallback onRetry;
  final bool isRTL;

  const StoriesError({
    super.key,
    required this.error,
    required this.onRetry,
    required this.isRTL,
  });

  @override
  State<StoriesError> createState() => _StoriesErrorState();
}

class _StoriesErrorState extends State<StoriesError>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onRetry() {
    HapticFeedback.lightImpact();
    widget.onRetry();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40),
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 60),

                // Error Icon
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red.shade50,
                    border: Border.all(
                      color: Colors.red.shade200,
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    Icons.error_outline_rounded,
                    color: Colors.red.shade400,
                    size: 50,
                  ),
                ),

                const SizedBox(height: 24),

                // Error Title
                Text(
                  widget.isRTL ? 'حدث خطأ!' : 'Something went wrong!',
                  style: getBoldStyle(
                    color: Colors.red.shade600,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                  textDirection: widget.isRTL ? TextDirection.rtl : TextDirection.ltr,
                ),

                const SizedBox(height: 12),

                // Error Message
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.red.shade100,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    widget.isRTL
                        ? 'تعذر تحميل القصص. يرجى المحاولة مرة أخرى.'
                        : 'Failed to load stories. Please try again.',
                    style: TextStyle(
                      color: Colors.red.shade700,
                      fontSize: 14,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                    textDirection: widget.isRTL ? TextDirection.rtl : TextDirection.ltr,
                  ),
                ),

                const SizedBox(height: 32),

                // Retry Button
                _buildRetryButton(),

                const SizedBox(height: 20),

                // Additional Help
                _buildHelpSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRetryButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: _onRetry,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                ColorManager.primaryColor,
                ColorManager.primaryColor.withOpacity(0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: ColorManager.primaryColor.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            textDirection: widget.isRTL ? TextDirection.rtl : TextDirection.ltr,
            children: [
              Icon(
                Icons.refresh_rounded,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                widget.isRTL ? 'إعادة المحاولة' : 'Try Again',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHelpSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            textDirection: widget.isRTL ? TextDirection.rtl : TextDirection.ltr,
            children: [
              Icon(
                Icons.help_outline_rounded,
                color: Colors.grey.shade600,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                widget.isRTL ? 'نصائح للمساعدة:' : 'Helpful tips:',
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildHelpItem(
            widget.isRTL ? 'تحقق من اتصال الإنترنت' : 'Check your internet connection',
          ),
          _buildHelpItem(
            widget.isRTL ? 'تأكد من وجود قصص للطفل' : 'Make sure the child has stories',
          ),
          _buildHelpItem(
            widget.isRTL ? 'أعد تشغيل التطبيق إذا استمرت المشكلة' : 'Restart the app if the problem persists',
          ),
        ],
      ),
    );
  }

  Widget _buildHelpItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        textDirection: widget.isRTL ? TextDirection.rtl : TextDirection.ltr,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade500,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
                height: 1.3,
              ),
              textDirection: widget.isRTL ? TextDirection.rtl : TextDirection.ltr,
            ),
          ),
        ],
      ),
    );
  }
}