import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'package:wise_child/core/resources/style_manager.dart';

class StoriesEmpty extends StatefulWidget {
  final String childName;
  final VoidCallback onRefresh;
  final bool isRTL;

  const StoriesEmpty({
    super.key,
    required this.childName,
    required this.onRefresh,
    required this.isRTL,
  });

  @override
  State<StoriesEmpty> createState() => _StoriesEmptyState();
}

class _StoriesEmptyState extends State<StoriesEmpty>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _floatingController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _floatingAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _floatingController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(
      begin: 0.5,
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
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _floatingAnimation = Tween<double>(
      begin: -8.0,
      end: 8.0,
    ).animate(CurvedAnimation(
      parent: _floatingController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _floatingController.dispose();
    super.dispose();
  }

  void _onRefresh() {
    HapticFeedback.lightImpact();
    widget.onRefresh();
  }

  void _onCreateStory() {
    HapticFeedback.selectionClick();
    // Navigate to create story page
    // Navigator.push(context, MaterialPageRoute(
    //   builder: (context) => CreateStoryPage(childName: widget.childName),
    // ));
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

                // Floating Books Animation
                AnimatedBuilder(
                  animation: _floatingAnimation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, _floatingAnimation.value),
                      child: _buildEmptyIllustration(),
                    );
                  },
                ),

                const SizedBox(height: 32),

                // Title
                Text(
                  widget.isRTL
                      ? 'لا توجد قصص لـ ${widget.childName} بعد!'
                      : 'No stories for ${widget.childName} yet!',
                  style: getBoldStyle(
                    color: ColorManager.primaryColor,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                  textDirection: widget.isRTL ? TextDirection.rtl : TextDirection.ltr,
                ),

                const SizedBox(height: 16),

                // Description
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: ColorManager.primaryColor.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: ColorManager.primaryColor.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    widget.isRTL
                        ? 'ابدأ رحلة ${widget.childName} التعليمية بإنشاء قصص تفاعلية مخصصة له.'
                        : 'Start ${widget.childName}\'s learning journey by creating personalized interactive stories.',
                    style: TextStyle(
                      color: ColorManager.primaryColor,
                      fontSize: 14,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                    textDirection: widget.isRTL ? TextDirection.rtl : TextDirection.ltr,
                  ),
                ),

                const SizedBox(height: 32),

                // Action Buttons
                Column(
                  children: [
                    _buildCreateStoryButton(),
                    const SizedBox(height: 16),
                    _buildRefreshButton(),
                  ],
                ),

                const SizedBox(height: 24),

                // Features List
                _buildFeaturesList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyIllustration() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            ColorManager.primaryColor.withOpacity(0.1),
            ColorManager.primaryColor.withOpacity(0.05),
          ],
        ),
        border: Border.all(
          color: ColorManager.primaryColor.withOpacity(0.2),
          width: 2,
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background books
          Positioned(
            top: 25,
            left: 25,
            child: Transform.rotate(
              angle: -0.3,
              child: Icon(
                Icons.menu_book_outlined,
                color: ColorManager.primaryColor.withOpacity(0.3),
                size: 24,
              ),
            ),
          ),
          Positioned(
            bottom: 25,
            right: 25,
            child: Transform.rotate(
              angle: 0.3,
              child: Icon(
                Icons.auto_stories_outlined,
                color: ColorManager.primaryColor.withOpacity(0.3),
                size: 20,
              ),
            ),
          ),

          // Main icon
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: ColorManager.primaryColor.withOpacity(0.1),
            ),
            child: Icon(
              Icons.library_add_outlined,
              color: ColorManager.primaryColor,
              size: 32,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreateStoryButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: _onCreateStory,
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
                Icons.add_circle_outline_rounded,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                widget.isRTL ? 'إنشاء قصة جديدة' : 'Create New Story',
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

  Widget _buildRefreshButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: _onRefresh,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: ColorManager.primaryColor.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            textDirection: widget.isRTL ? TextDirection.rtl : TextDirection.ltr,
            children: [
              Icon(
                Icons.refresh_rounded,
                color: ColorManager.primaryColor,
                size: 18,
              ),
              const SizedBox(width: 6),
              Text(
                widget.isRTL ? 'تحديث' : 'Refresh',
                style: TextStyle(
                  color: ColorManager.primaryColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturesList() {
    final features = widget.isRTL
        ? [
      'قصص تفاعلية مخصصة',
      'محتوى تعليمي آمن',
      'متابعة التقدم',
    ]
        : [
      'Personalized interactive stories',
      'Safe educational content',
      'Progress tracking',
    ];

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
                Icons.star_outline_rounded,
                color: Colors.amber.shade600,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                widget.isRTL ? 'مميزات القصص:' : 'Story features:',
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...features.map((feature) => _buildFeatureItem(feature)),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(String text) {
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
              color: ColorManager.primaryColor,
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