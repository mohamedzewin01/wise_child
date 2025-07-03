// lib/features/welcome/presentation/widgets/animated_welcome_background.dart
import 'package:flutter/material.dart';

class AnimatedWelcomeBackground extends StatefulWidget {
  const AnimatedWelcomeBackground({super.key});

  @override
  State<AnimatedWelcomeBackground> createState() => _AnimatedWelcomeBackgroundState();
}

class _AnimatedWelcomeBackgroundState extends State<AnimatedWelcomeBackground>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late List<AnimationController> _bubbleControllers;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 15),
      vsync: this,
    )..repeat();

    _bubbleControllers = List.generate(5, (index) {
      return AnimationController(
        duration: Duration(seconds: 3 + (index % 3)),
        vsync: this,
      )..repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    for (var controller in _bubbleControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF667eea),
            Color(0xFF764ba2),
            Color(0xFF6B73FF),
            Color(0xFF9644B5),
          ],
          stops: [0.0, 0.3, 0.7, 1.0],
        ),
      ),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Stack(
            children: [
              // Floating bubbles
              ..._buildFloatingBubbles(),

              // Gradient overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.1),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  List<Widget> _buildFloatingBubbles() {
    return List.generate(8, (index) {
      final animation = _bubbleControllers[index % _bubbleControllers.length];
      final size = 60.0 + (index * 20);
      final opacity = 0.1 + (index * 0.02);

      return AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          return Positioned(
            left: 50 + (index * 40) + (animation.value * 30),
            top: 100 + (index * 80) + (animation.value * 50),
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(opacity),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.1),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }
}

// lib/features/welcome/presentation/widgets/feature_card.dart

