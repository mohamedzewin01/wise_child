import 'dart:math' as math;

import 'package:flutter/material.dart';

class FloatingParticles extends StatelessWidget {
  const FloatingParticles({super.key, required this.animationController});
final   AnimationController animationController;
  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: AnimatedBuilder(
        animation: animationController,
        builder: (context, child) {
          return Stack(
            children: List.generate(6, (index) {
              final offset = (index * 0.3) % 1.0;
              final animationValue = (animationController.value + offset) % 1.0;

              return Positioned(
                left: (index % 3) * (MediaQuery.of(context).size.width / 3) +
                    math.sin(animationValue * 2 * math.pi) * 20,
                top: MediaQuery.of(context).size.height * 0.2 +
                    math.cos(animationValue * 2 * math.pi) * 30,
                child: Opacity(
                  opacity: 0.6 * (1 - animationValue),
                  child: Transform.scale(
                    scale: 0.5 + (animationValue * 0.5),
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.7),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.5),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
