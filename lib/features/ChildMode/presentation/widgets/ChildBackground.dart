// lib/features/ChildMode/presentation/widgets/child_background.dart

import 'package:flutter/material.dart';
import 'dart:math' as math;

class ChildBackground extends StatelessWidget {
  final Animation<double> animation;

  const ChildBackground({
    super.key,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.blue.shade200,
            Colors.purple.shade200,
            Colors.pink.shade200,
            Colors.orange.shade200,
          ],
          stops: const [0.0, 0.3, 0.7, 1.0],
        ),
      ),
      child: Stack(
        children: [
          // عناصر متحركة في الخلفية
          ...List.generate(15, (index) => _buildFloatingElement(index)),

          // نمط الشبكة الخفيف
          _buildGridPattern(),

          // تأثير الضوء المتحرك
          _buildLightEffect(),
        ],
      ),
    );
  }

  Widget _buildFloatingElement(int index) {
    final double offset = (index * 0.1) % 1.0;
    final double delay = (index * 0.15) % 1.0;

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final animationValue = (animation.value + delay) % 1.0;
        final yPosition = (animationValue * 1.2 - 0.1);
        final xOffset = math.sin((animation.value + offset) * 2 * math.pi) * 30;

        return Positioned(
          left: (index % 5) * 80.0 + 50 + xOffset,
          top: MediaQuery.of(context).size.height * yPosition,
          child: Transform.rotate(
            angle: (animation.value + offset) * 2 * math.pi,
            child: _getFloatingIcon(index),
          ),
        );
      },
    );
  }

  Widget _getFloatingIcon(int index) {
    final icons = [
      Icons.star_rounded,
      Icons.favorite_rounded,
      Icons.auto_stories_rounded,
      Icons.emoji_emotions_rounded,
      Icons.pets_rounded,
      Icons.cake_rounded,
      Icons.toys_rounded,
      Icons.child_care_rounded,
    ];

    final colors = [
      Colors.yellow.shade300,
      Colors.pink.shade300,
      Colors.blue.shade300,
      Colors.green.shade300,
      Colors.orange.shade300,
      Colors.purple.shade300,
      Colors.red.shade300,
      Colors.cyan.shade300,
    ];

    final iconIndex = index % icons.length;
    final colorIndex = index % colors.length;

    return Container(
      width: 30 + (index % 3) * 10,
      height: 30 + (index % 3) * 10,
      decoration: BoxDecoration(
        color: colors[colorIndex].withOpacity(0.3),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: colors[colorIndex].withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Icon(
        icons[iconIndex],
        size: 15 + (index % 3) * 5,
        color: colors[colorIndex],
      ),
    );
  }

  Widget _buildGridPattern() {
    return Opacity(
      opacity: 0.1,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: _createGridPattern(),
            repeat: ImageRepeat.repeat,
          ),
        ),
      ),
    );
  }

  ImageProvider _createGridPattern() {
    // إنشاء نمط شبكة بسيط
    return const AssetImage('assets/images/grid_pattern.png'); // يمكن استبدالها بنمط مخصص
  }

  Widget _buildLightEffect() {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(
                math.sin(animation.value * 2 * math.pi) * 0.3,
                math.cos(animation.value * 2 * math.pi) * 0.3,
              ),
              radius: 0.8,
              colors: [
                Colors.white.withOpacity(0.1),
                Colors.transparent,
              ],
              stops: const [0.0, 1.0],
            ),
          ),
        );
      },
    );
  }
}

// Widget للأنماط الهندسية المرحة
class PlayfulShapes extends StatelessWidget {
  final Animation<double> animation;

  const PlayfulShapes({
    super.key,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return CustomPaint(
          painter: ShapesPainter(animation.value),
          child: Container(),
        );
      },
    );
  }
}

class ShapesPainter extends CustomPainter {
  final double animationValue;

  ShapesPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 2;

    // رسم أشكال هندسية ملونة متحركة
    for (int i = 0; i < 10; i++) {
      final xPos = (size.width / 10) * i +
          math.sin((animationValue + i * 0.1) * 2 * math.pi) * 20;
      final yPos = size.height * 0.1 +
          math.cos((animationValue + i * 0.1) * 2 * math.pi) * 10;

      paint.color = HSVColor.fromAHSV(
        0.3,
        (animationValue * 360 + i * 36) % 360,
        0.7,
        0.9,
      ).toColor();

      switch (i % 4) {
        case 0:
          canvas.drawCircle(Offset(xPos, yPos), 15, paint);
          break;
        case 1:
          canvas.drawRect(
            Rect.fromCenter(center: Offset(xPos, yPos), width: 25, height: 25),
            paint,
          );
          break;
        case 2:
          _drawTriangle(canvas, paint, Offset(xPos, yPos), 20);
          break;
        case 3:
          _drawStar(canvas, paint, Offset(xPos, yPos), 15);
          break;
      }
    }
  }

  void _drawTriangle(Canvas canvas, Paint paint, Offset center, double size) {
    final path = Path();
    path.moveTo(center.dx, center.dy - size);
    path.lineTo(center.dx - size, center.dy + size);
    path.lineTo(center.dx + size, center.dy + size);
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawStar(Canvas canvas, Paint paint, Offset center, double size) {
    final path = Path();
    const int points = 5;
    const double angle = 2 * math.pi / points;

    for (int i = 0; i < points * 2; i++) {
      final double radius = (i % 2 == 0) ? size : size * 0.5;
      final double x = center.dx + radius * math.cos(i * angle / 2 - math.pi / 2);
      final double y = center.dy + radius * math.sin(i * angle / 2 - math.pi / 2);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}