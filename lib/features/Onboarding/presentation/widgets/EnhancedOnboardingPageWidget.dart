import 'package:flutter/material.dart';
import 'package:wise_child/core/resources/style_manager.dart';
import 'dart:math' as math;

import 'package:wise_child/features/Onboarding/presentation/pages/Onboarding_page.dart';

// Enhanced Page Widget with Advanced Animations
class EnhancedOnboardingPageWidget extends StatefulWidget {
  final OnboardingData data;
  final int pageIndex;
  final bool isActive;

  const EnhancedOnboardingPageWidget({
    super.key,
    required this.data,
    required this.pageIndex,
    required this.isActive,
  });

  @override
  State<EnhancedOnboardingPageWidget> createState() => _EnhancedOnboardingPageWidgetState();
}

class _EnhancedOnboardingPageWidgetState extends State<EnhancedOnboardingPageWidget>
    with TickerProviderStateMixin {

  // Animation Controllers
  late AnimationController _imageController;
  late AnimationController _textController;
  late AnimationController _floatingController;
  late AnimationController _pulseController;

  // Animations
  late Animation<double> _imageScaleAnimation;
  late Animation<double> _imageRotationAnimation;
  late Animation<Offset> _imageSlideAnimation;
  late Animation<double> _imageFadeAnimation;

  late Animation<double> _titleFadeAnimation;
  late Animation<Offset> _titleSlideAnimation;
  late Animation<double> _subtitleFadeAnimation;
  late Animation<Offset> _subtitleSlideAnimation;

  late Animation<double> _floatingAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    if (widget.isActive) {
      _startAnimations();
    }
  }

  @override
  void didUpdateWidget(EnhancedOnboardingPageWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive != oldWidget.isActive) {
      if (widget.isActive) {
        _startAnimations();
      }
    }
  }

  void _initializeAnimations() {
    // Image Animation Controller
    _imageController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // Text Animation Controller
    _textController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Floating Animation Controller
    _floatingController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    // Pulse Animation Controller
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    // Image Animations
    _imageScaleAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _imageController,
      curve: const Interval(0.0, 0.8, curve: Curves.elasticOut),
    ));

    _imageRotationAnimation = Tween<double>(
      begin: 0.2,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _imageController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack),
    ));

    _imageSlideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _imageController,
      curve: const Interval(0.2, 0.8, curve: Curves.easeOutCubic),
    ));

    _imageFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _imageController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    // Text Animations
    _titleFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: const Interval(0.3, 0.7, curve: Curves.easeOut),
    ));

    _titleSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.8),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: const Interval(0.3, 0.8, curve: Curves.easeOutBack),
    ));

    _subtitleFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: const Interval(0.5, 0.9, curve: Curves.easeOut),
    ));

    _subtitleSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: const Interval(0.5, 1.0, curve: Curves.easeOutBack),
    ));

    // Floating Animation
    _floatingAnimation = Tween<double>(
      begin: -10.0,
      end: 10.0,
    ).animate(CurvedAnimation(
      parent: _floatingController,
      curve: Curves.easeInOut,
    ));

    // Pulse Animation
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
  }

  void _startAnimations() {
    _imageController.reset();
    _textController.reset();

    _imageController.forward();
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) {
        _textController.forward();
      }
    });
  }

  @override
  void dispose() {
    _imageController.dispose();
    _textController.dispose();
    _floatingController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),

            // Enhanced Image Container
            _buildEnhancedImageContainer(),

            const SizedBox(height: 10),

            // Enhanced Title
            _buildEnhancedTitle(),

            const SizedBox(height: 24),

            // Enhanced Subtitle
            _buildEnhancedSubtitle(),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildEnhancedImageContainer() {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _imageController,
        _floatingController,
        _pulseController,
      ]),
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _floatingAnimation.value),
          child: SlideTransition(
            position: _imageSlideAnimation,
            child: FadeTransition(
              opacity: _imageFadeAnimation,
              child: Transform.rotate(
                angle: _imageRotationAnimation.value,
                child: Transform.scale(
                  scale: _imageScaleAnimation.value,
                  child: Container(
                    width: 320,
                    height: 320,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          widget.data.primaryColor.withOpacity(0.3),
                          widget.data.secondaryColor.withOpacity(0.1),
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.7, 1.0],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: widget.data.primaryColor.withOpacity(0.3),
                          blurRadius: 40,
                          spreadRadius: 10,
                          offset: const Offset(0, 20),
                        ),
                        BoxShadow(
                          color: Colors.white.withOpacity(0.1),
                          blurRadius: 60,
                          spreadRadius: 20,
                          offset: const Offset(0, -10),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        // Pulse Effect Background
                        Center(
                          child: Transform.scale(
                            scale: _pulseAnimation.value,
                            child: Container(
                              width: 280,
                              height: 280,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Main Image Container
                        Center(
                          child: Container(
                            width: 270,
                            height: 270,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.white.withOpacity(0.2),
                                  Colors.white.withOpacity(0.1),
                                ],
                              ),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                                width: 3,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(130),
                              child: Image.asset(
                                widget.data.image,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return _buildFallbackImage();
                                },
                              ),
                            ),
                          ),
                        ),

                        // Floating Icon
                        Positioned(
                          bottom: 20,
                          right: 20,
                          child: Transform.scale(
                            scale: _pulseAnimation.value * 0.8,
                            child: Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: widget.data.primaryColor,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: widget.data.primaryColor.withOpacity(0.4),
                                    blurRadius: 15,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Icon(
                                widget.data.icon,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
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
      },
    );
  }

  Widget _buildFallbackImage() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            widget.data.primaryColor.withOpacity(0.8),
            widget.data.secondaryColor.withOpacity(0.6),
          ],
        ),
        borderRadius: BorderRadius.circular(130),
      ),
      child: Center(
        child: Icon(
          widget.data.icon,
          size: 100,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildEnhancedTitle() {
    return SlideTransition(
      position: _titleSlideAnimation,
      child: FadeTransition(
        opacity: _titleFadeAnimation,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Text(
            widget.data.title,
            textAlign: TextAlign.center,
            style: getBoldStyle(
              fontSize: 20,
              color: Colors.white,
            ).copyWith(
              height: 1.3,
              letterSpacing: 0.5,
              shadows: [
                Shadow(
                  offset: const Offset(0, 2),
                  blurRadius: 8,
                  color: Colors.black.withOpacity(0.3),
                ),
                Shadow(
                  offset: const Offset(0, 4),
                  blurRadius: 16,
                  color: widget.data.primaryColor.withOpacity(0.2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedSubtitle() {
    return SlideTransition(
      position: _subtitleSlideAnimation,
      child: FadeTransition(
        opacity: _subtitleFadeAnimation,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Text(
            widget.data.subtitle,
            textAlign: TextAlign.center,
            style: getRegularStyle(
              fontSize: 18,
              color: Colors.white.withOpacity(0.95),
            ).copyWith(
              height: 1.6,
              letterSpacing: 0.3,
              shadows: [
                Shadow(
                  offset: const Offset(0, 1),
                  blurRadius: 4,
                  color: Colors.black.withOpacity(0.2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Enhanced Page Indicator with Advanced Animations
class EnhancedPageIndicator extends StatefulWidget {
  final int currentPage;
  final int totalPages;
  final Color activeColor;
  final Color inactiveColor;

  const EnhancedPageIndicator({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.activeColor,
    required this.inactiveColor,
  });

  @override
  State<EnhancedPageIndicator> createState() => _EnhancedPageIndicatorState();
}

class _EnhancedPageIndicatorState extends State<EnhancedPageIndicator>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _glowAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void didUpdateWidget(EnhancedPageIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentPage != oldWidget.currentPage) {
      _animationController.reset();
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.totalPages,
                (index) => _buildIndicatorDot(index),
          ),
        );
      },
    );
  }

  Widget _buildIndicatorDot(int index) {
    final isActive = index == widget.currentPage;
    final scale = isActive ? _scaleAnimation.value : 1.0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOutCubic,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      width: isActive ? 30 : 12,
      height: 10,
      decoration: BoxDecoration(
        color: isActive ? widget.activeColor : widget.inactiveColor,
        borderRadius: BorderRadius.circular(6),
        boxShadow: isActive
            ? [
          BoxShadow(
            color: widget.activeColor.withOpacity(0.6 * _glowAnimation.value),
            blurRadius: 15 * _glowAnimation.value,
            spreadRadius: 3 * _glowAnimation.value,
          ),
          BoxShadow(
            color: widget.activeColor.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ]
            : [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: isActive
          ? Transform.scale(
        scale: scale,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            gradient: LinearGradient(
              colors: [
                widget.activeColor,
                widget.activeColor.withOpacity(0.8),
              ],
            ),
          ),
        ),
      )
          : null,
    );
  }
}

// Floating Action Button with Advanced Effects
class FloatingActionButtonWithEffects extends StatefulWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String? text;
  final Color backgroundColor;
  final Color foregroundColor;
  final bool isExpanded;

  const FloatingActionButtonWithEffects({
    super.key,
    required this.onPressed,
    required this.icon,
    this.text,
    required this.backgroundColor,
    required this.foregroundColor,
    this.isExpanded = false,
  });

  @override
  State<FloatingActionButtonWithEffects> createState() => _FloatingActionButtonWithEffectsState();
}

class _FloatingActionButtonWithEffectsState extends State<FloatingActionButtonWithEffects>
    with TickerProviderStateMixin {
  late AnimationController _rippleController;
  late AnimationController _bounceController;
  late Animation<double> _rippleAnimation;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();

    _rippleController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _rippleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _rippleController,
      curve: Curves.easeOut,
    ));

    _bounceAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _bounceController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _rippleController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  void _handleTap() {
    _bounceController.forward().then((_) {
      _bounceController.reverse();
    });
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_rippleController, _bounceController]),
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Ripple Effect
            Transform.scale(
              scale: _rippleAnimation.value * 2,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.backgroundColor.withOpacity(
                    0.3 * (1 - _rippleAnimation.value),
                  ),
                ),
              ),
            ),

            // Main Button
            Transform.scale(
              scale: _bounceAnimation.value,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                curve: Curves.elasticOut,
                width: widget.isExpanded ? 180 : 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      widget.backgroundColor,
                      widget.backgroundColor.withOpacity(0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: widget.backgroundColor.withOpacity(0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                      spreadRadius: 2,
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(30),
                    onTap: _handleTap,
                    child: Container(
                      alignment: Alignment.center,
                      child: widget.isExpanded && widget.text != null
                          ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.text!,
                            style: TextStyle(
                              color: widget.foregroundColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            widget.icon,
                            color: widget.foregroundColor,
                            size: 20,
                          ),
                        ],
                      )
                          : Icon(
                        widget.icon,
                        color: widget.foregroundColor,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// Data Model for Onboarding (needed for the main file)
// class OnboardingData {
//   final String image;
//   final String title;
//   final String subtitle;
//   final Color primaryColor;
//   final Color secondaryColor;
//   final IconData icon;
//
//   OnboardingData({
//     required this.image,
//     required this.title,
//     required this.subtitle,
//     required this.primaryColor,
//     required this.secondaryColor,
//     required this.icon,
//   });
// }