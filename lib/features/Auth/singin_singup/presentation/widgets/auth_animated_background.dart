// lib/features/Auth/presentation/widgets/auth_animated_background.dart
import 'package:flutter/material.dart';

class AuthAnimatedBackground extends StatefulWidget {
  const AuthAnimatedBackground({super.key});

  @override
  State<AuthAnimatedBackground> createState() => _AuthAnimatedBackgroundState();
}

class _AuthAnimatedBackgroundState extends State<AuthAnimatedBackground>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late List<AnimationController> _particleControllers;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 12),
      vsync: this,
    )..repeat();

    _particleControllers = List.generate(8, (index) {
      return AnimationController(
        duration: Duration(seconds: 3 + (index % 4)),
        vsync: this,
      )..repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    for (var controller in _particleControllers) {
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
            Color(0xFF667eea),
            Color(0xFF9644B5),
          ],
          stops: [0.0, 0.4, 0.7, 1.0],
        ),
      ),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Stack(
            children: [
              // Main gradient animation
              Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment(
                      0.5 + (_controller.value * 0.3 - 0.15),
                      0.5 + (_controller.value * 0.2 - 0.1),
                    ),
                    radius: 1.5,
                    colors: [
                      Colors.white.withOpacity(0.1),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),

              // Floating particles
              ..._buildFloatingParticles(),

              // Gradient overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.1),
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

  List<Widget> _buildFloatingParticles() {
    return List.generate(12, (index) {
      final animation = _particleControllers[index % _particleControllers.length];
      final size = 30.0 + (index * 10);
      final opacity = 0.03 + (index * 0.015);

      return AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          return Positioned(
            left: 20 + (index * 35) + (animation.value * 50),
            top: 60 + (index * 60) + (animation.value * 80),
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







