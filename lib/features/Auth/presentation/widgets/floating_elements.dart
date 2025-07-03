
import 'package:flutter/material.dart';

class FloatingElements extends StatefulWidget {
  const FloatingElements({super.key});

  @override
  State<FloatingElements> createState() => _FloatingElementsState();
}

class _FloatingElementsState extends State<FloatingElements>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(6, (index) {
      return AnimationController(
        duration: Duration(seconds: 4 + (index % 3)),
        vsync: this,
      )..repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Floating geometric shapes
        ..._controllers.asMap().entries.map((entry) {
          final index = entry.key;
          final controller = entry.value;

          return AnimatedBuilder(
            animation: controller,
            builder: (context, child) {
              return Positioned(
                left: 50 + (index * 60) + (controller.value * 40),
                top: 100 + (index * 100) + (controller.value * 60),
                child: Transform.rotate(
                  angle: controller.value * 6.28,
                  child: Container(
                    width: 20 + (index * 5),
                    height: 20 + (index * 5),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      shape: index % 2 == 0 ? BoxShape.circle : BoxShape.rectangle,
                      borderRadius: index % 2 == 1 ? BorderRadius.circular(5) : null,
                    ),
                  ),
                ),
              );
            },
          );
        }).toList(),
      ],
    );
  }
}