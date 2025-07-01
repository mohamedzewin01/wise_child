// // child_details_floating_actions.dart
// import 'package:flutter/material.dart';
// import 'package:wise_child/core/resources/color_manager.dart';
// import 'package:wise_child/features/Children/data/models/response/get_children_dto.dart';
//
// class ChildDetailsFloatingActions extends StatelessWidget {
//   final Children child;
//   final VoidCallback onEditPressed;
//   final VoidCallback onPlayPressed;
//
//   const ChildDetailsFloatingActions({
//     super.key,
//     required this.child,
//     required this.onEditPressed,
//     required this.onPlayPressed,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         FloatingActionButton(
//           heroTag: 'edit',
//           onPressed: onEditPressed,
//           backgroundColor: ColorManager.primaryColor,
//           child: const Icon(Icons.edit_rounded, color: Colors.white),
//         ),
//         const SizedBox(height: 12),
//         FloatingActionButton(
//           heroTag: 'play',
//           onPressed: onPlayPressed,
//           backgroundColor: Colors.green,
//           child: const Icon(Icons.gamepad_rounded, color: Colors.white),
//         ),
//       ],
//     );
//   }
// }
//
//
//
//
//
//
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'package:wise_child/features/Children/data/models/response/get_children_dto.dart';

class ChildDetailsFloatingActions extends StatefulWidget {
  final Children child;
  final VoidCallback onEditPressed;
  final VoidCallback onPlayPressed;

  const ChildDetailsFloatingActions({
    super.key,
    required this.child,
    required this.onEditPressed,
    required this.onPlayPressed,
  });

  @override
  State<ChildDetailsFloatingActions> createState() => _ChildDetailsFloatingActionsState();
}

class _ChildDetailsFloatingActionsState extends State<ChildDetailsFloatingActions>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _pulseController;
  late AnimationController _rotateController;

  late Animation<Offset> _editSlideAnimation;
  late Animation<Offset> _playSlideAnimation;
  late Animation<double> _editScaleAnimation;
  late Animation<double> _playScaleAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rotateAnimation;

  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startInitialAnimation();
  }

  void _initializeAnimations() {
    // Main slide controller
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Pulse animation controller
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Rotate animation controller
    _rotateController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // Slide animations
    _editSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: const Interval(0.0, 0.7, curve: Curves.elasticOut),
    ));

    _playSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: const Interval(0.3, 1.0, curve: Curves.elasticOut),
    ));

    // Scale animations
    _editScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: const Interval(0.0, 0.7, curve: Curves.easeOutBack),
    ));

    _playScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: const Interval(0.3, 1.0, curve: Curves.easeOutBack),
    ));

    // Pulse animation
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    // Rotate animation
    _rotateAnimation = Tween<double>(
      begin: 0.0,
      end: 0.25,
    ).animate(CurvedAnimation(
      parent: _rotateController,
      curve: Curves.easeInOut,
    ));
  }

  void _startInitialAnimation() {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _slideController.forward();
        _startPulseAnimation();
      }
    });
  }

  void _startPulseAnimation() {
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _slideController.dispose();
    _pulseController.dispose();
    _rotateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Edit Button
        SlideTransition(
          position: _editSlideAnimation,
          child: ScaleTransition(
            scale: _editScaleAnimation,
            child: _buildEditButton(),
          ),
        ),

        const SizedBox(height: 16),

        // Play Button (Main Action)
        SlideTransition(
          position: _playSlideAnimation,
          child: ScaleTransition(
            scale: _playScaleAnimation,
            child: AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _pulseAnimation.value,
                  child: _buildPlayButton(),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEditButton() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: ColorManager.primaryColor.withOpacity(0.3),
            offset: const Offset(0, 8),
            blurRadius: 20,
            spreadRadius: 2,
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.8),
            offset: const Offset(0, -2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(28),
          onTap: () => _handleEditPressed(),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  ColorManager.primaryColor,
                  ColorManager.primaryColor.withOpacity(0.8),
                ],
              ),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Background glow effect
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                ),
                // Icon
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // Profile icon
                    const Icon(
                      Icons.account_circle_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                    // Edit pencil overlay
                    Positioned(
                      right:-1,
                      bottom: -1,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade600,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.transparent,
                            width: 1,
                          ),
                        ),
                        child: const Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 8,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlayButton() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.4),
            offset: const Offset(0, 12),
            blurRadius: 25,
            spreadRadius: 3,
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.8),
            offset: const Offset(0, -3),
            blurRadius: 10,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(35),
          onTap: () => _handlePlayPressed(),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.deepPurple.shade400,
                  Colors.purple.shade600,
                ],
              ),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withOpacity(0.4),
                width: 3,
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Animated background circles
                _buildAnimatedCircle(30, Colors.white.withOpacity(0.1)),
                _buildAnimatedCircle(20, Colors.white.withOpacity(0.2)),

                // Main icon with rotation
                AnimatedBuilder(
                  animation: _rotateAnimation,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _rotateAnimation.value * 2 * 3.14159,
                      child: Stack(
                        alignment: Alignment.center,
                        clipBehavior: Clip.none,
                        children: [
                          // Book icon (main)
                          const Icon(
                            Icons.menu_book_rounded,
                            color: Colors.white,
                            size: 30,
                          ),
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: -5,
                            child: Container(
                              padding: const EdgeInsets.all(1),
                              decoration: BoxDecoration(
                                color: Colors.orange.shade500,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1,
                                ),
                              ),
                              child: const Icon(
                                Icons.add_rounded,
                                color: Colors.white,
                                size: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),

                // Sparkle effects
                Positioned(
                  top: 8,
                  right: 12,
                  child: _buildSparkle(6),
                ),
                Positioned(
                  bottom: 12,
                  left: 8,
                  child: _buildSparkle(4),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedCircle(double size, Color color) {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Container(
          width: size * _pulseAnimation.value,
          height: size * _pulseAnimation.value,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }

  Widget _buildSparkle(double size) {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Opacity(
          opacity: _pulseAnimation.value - 1.0 + 0.5,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.6),
                  blurRadius: 4,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleEditPressed() {
    HapticFeedback.lightImpact();

    // Quick scale animation
    _slideController.reverse().then((_) {
      _slideController.forward();
    });

    widget.onEditPressed();
  }

  void _handlePlayPressed() {
    HapticFeedback.mediumImpact();

    // Rotate animation
    _rotateController.forward().then((_) {
      _rotateController.reverse();
    });

    // Stop pulse temporarily and restart
    _pulseController.stop();
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _pulseController.repeat(reverse: true);
      }
    });

    widget.onPlayPressed();
  }
}