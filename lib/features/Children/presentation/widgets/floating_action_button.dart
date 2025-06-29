import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'dart:math' as math;

class CustomfloatingActionButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String? tooltip;
  final IconData icon;
  final bool isExpanded;

  const CustomfloatingActionButton({
    super.key,
    required this.onPressed,
    this.tooltip,
    this.icon = Icons.add,
    this.isExpanded = false,
  });

  @override
  State<CustomfloatingActionButton> createState() => _CustomfloatingActionButtonState();
}

class _CustomfloatingActionButtonState extends State<CustomfloatingActionButton>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _scaleController;
  late AnimationController _rotationController;
  late AnimationController _rippleController;
  late AnimationController _glowController;

  late Animation<double> _pulseAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _rippleAnimation;
  late Animation<double> _glowAnimation;

  bool _isPressed = false;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _rippleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _glowController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.9,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    ));

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.125, // 45 degrees (π/4 / 2π = 0.125)
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.elasticOut,
    ));

    _rippleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _rippleController,
      curve: Curves.easeOut,
    ));

    _glowAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    ));

    _startAnimations();
  }

  void _startAnimations() {
    _pulseController.repeat(reverse: true);
    _glowController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _scaleController.dispose();
    _rotationController.dispose();
    _rippleController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  void _onTapDown() {
    setState(() => _isPressed = true);
    _scaleController.forward();
    _rotationController.forward();
    HapticFeedback.mediumImpact();
  }

  void _onTapUp() {
    setState(() => _isPressed = false);
    _scaleController.reverse();
    _rotationController.reverse();
    _rippleController.forward().then((_) {
      _rippleController.reset();
    });
    widget.onPressed();
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
    _scaleController.reverse();
    _rotationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _pulseAnimation,
        _scaleAnimation,
        _rotationAnimation,
        _rippleAnimation,
        _glowAnimation,
      ]),
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Glow Effect
            _buildGlowEffect(),

            // Ripple Effect
            _buildRippleEffect(),

            // Main FAB
            _buildMainFAB(),

            // Floating Particles
            _buildFloatingParticles(),
          ],
        );
      },
    );
  }

  Widget _buildGlowEffect() {
    return Transform.scale(
      scale: _pulseAnimation.value * (1.0 + _glowAnimation.value * 0.2),
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              ColorManager.primaryColor.withOpacity(0.3 * _glowAnimation.value),
              ColorManager.primaryColor.withOpacity(0.1 * _glowAnimation.value),
              Colors.transparent,
            ],
            stops: const [0.0, 0.7, 1.0],
          ),
        ),
      ),
    );
  }

  Widget _buildRippleEffect() {
    if (_rippleAnimation.value == 0) return const SizedBox.shrink();

    return Transform.scale(
      scale: 1.0 + (_rippleAnimation.value * 1.5),
      child: Opacity(
        opacity: 1.0 - _rippleAnimation.value,
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: ColorManager.primaryColor,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainFAB() {
    return Transform.scale(
      scale: _scaleAnimation.value * _pulseAnimation.value,
      child: Transform.rotate(
        angle: _rotationAnimation.value * 2 * 3.14159,
        child: GestureDetector(
          onTapDown: (_) => _onTapDown(),
          onTapUp: (_) => _onTapUp(),
          onTapCancel: _onTapCancel,
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  ColorManager.primaryColor,
                  ColorManager.primaryColor,
                  Colors.purple.shade400,
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: ColorManager.primaryColor.withOpacity(0.4),
                  blurRadius: _isPressed ? 25 : 20,
                  offset: Offset(0, _isPressed ? 8 : 12),
                  spreadRadius: _isPressed ? 0 : 2,
                ),
                BoxShadow(
                  color: Colors.purple.withOpacity(0.3),
                  blurRadius: _isPressed ? 15 : 12,
                  offset: Offset(0, _isPressed ? 4 : 6),
                  spreadRadius: _isPressed ? -1 : 1,
                ),
                // Inner highlight
                BoxShadow(
                  color: Colors.white.withOpacity(0.3),
                  blurRadius: 5,
                  offset: const Offset(-2, -2),
                  spreadRadius: -3,
                ),
              ],
            ),
            child: Stack(
              children: [
                // Background shine effect
                _buildShineEffect(),

                // Icon
                Center(
                  child: Icon(
                    widget.icon,
                    color: Colors.white,
                    size: 28,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                ),

                // Border highlight
                _buildBorderHighlight(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShineEffect() {
    return ClipOval(
      child: TweenAnimationBuilder<double>(
        duration: const Duration(seconds: 3),
        tween: Tween(begin: -1.0, end: 2.0),
        builder: (context, value, child) {
          return Transform.translate(
            offset: Offset(value * 60, -value * 30),
            child: Transform.rotate(
              angle: 0.5,
              child: Container(
                width: 20,
                height: 100,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      Colors.white.withOpacity(0.4),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBorderHighlight() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1,
        ),
      ),
    );
  }

  Widget _buildFloatingParticles() {
    return Stack(
      children: List.generate(6, (index) {
        final angle = (index * 60.0) * (3.14159 / 180); // Convert to radians
        final radius = 40.0 + (_pulseAnimation.value * 10);

        return TweenAnimationBuilder<double>(
          duration: Duration(milliseconds: 2000 + (index * 200)),
          tween: Tween(begin: 0.0, end: 1.0),
          builder: (context, value, child) {
            final offsetX = radius * math.cos(angle + (value * 2 * 3.14159));
            final offsetY = radius * math.sin(angle + (value * 2 * 3.14159));

            return Transform.translate(
              offset: Offset(offsetX, offsetY),
              child: Opacity(
                opacity: 0.6 * _glowAnimation.value,
                child: Container(
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Colors.white,
                        ColorManager.primaryColor.withOpacity(0.8),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}


