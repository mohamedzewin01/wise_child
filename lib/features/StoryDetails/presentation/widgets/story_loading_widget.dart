import 'package:flutter/material.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'package:wise_child/core/resources/style_manager.dart';

class StoryLoadingWidget extends StatefulWidget {
  final VoidCallback onRetry;

  const StoryLoadingWidget({
    super.key,
    required this.onRetry,
  });

  @override
  State<StoryLoadingWidget> createState() => _StoryLoadingWidgetState();
}

class _StoryLoadingWidgetState extends State<StoryLoadingWidget>
    with TickerProviderStateMixin {
  late AnimationController _loadingController;
  late AnimationController _pulseController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _loadingController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _loadingController, curve: Curves.easeInOut),
    );

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _loadingController.forward();
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _loadingController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              ColorManager.primaryColor.withOpacity(0.1),
              Colors.white,
              ColorManager.primaryColor.withOpacity(0.05),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom App Bar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: ColorManager.primaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: Container(
                          height: 20,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: Center(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Animated Loading Icon
                        ScaleTransition(
                          scale: _pulseAnimation,
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: ColorManager.primaryColor.withOpacity(0.1),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: ColorManager.primaryColor.withOpacity(0.3),
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.auto_stories,
                                size: 50,
                                color: ColorManager.primaryColor,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Loading Indicator
                        SizedBox(
                          width: 40,
                          height: 40,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              ColorManager.primaryColor,
                            ),
                            strokeWidth: 3,
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Loading Text
                        Text(
                          'جاري تحميل تفاصيل القصة...',
                          style: getBoldStyle(
                            color: ColorManager.primaryColor,
                            fontSize: 18,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          'يرجى الانتظار قليلاً',
                          style: getRegularStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                        ),

                        const SizedBox(height: 40),

                        // Loading Animation Bars
                        _buildLoadingBars(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingBars() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return AnimatedBuilder(
          animation: _loadingController,
          builder: (context, child) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              width: 4,
              height: 20 + (10 * (_fadeAnimation.value * (index + 1) / 5)),
              decoration: BoxDecoration(
                color: ColorManager.primaryColor.withOpacity(
                  0.3 + (0.7 * _fadeAnimation.value * (index + 1) / 5),
                ),
                borderRadius: BorderRadius.circular(2),
              ),
            );
          },
        );
      }),
    );
  }
}