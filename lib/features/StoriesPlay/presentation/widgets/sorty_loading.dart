
import 'package:flutter/material.dart';
import 'package:wise_child/core/resources/color_manager.dart';

class StoryLoading extends StatelessWidget {
  const StoryLoading({super.key, required this.loadingAnimation});
  final Animation<double> loadingAnimation;
  @override
  Widget build(BuildContext context) {
    return  Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            ColorManager.primaryColor.withOpacity(0.8),
            Colors.purple.shade600,
            Colors.indigo.shade700,
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // أيقونة متحركة
            AnimatedBuilder(
              animation: loadingAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: 0.8 + (loadingAnimation.value * 0.4),
                  child: Transform.rotate(
                    angle: loadingAnimation.value * 2 * 3.14159,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.white,
                            Colors.yellow.shade300,
                            Colors.orange.shade300,
                          ],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.5),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.auto_stories_rounded,
                        size: 50,
                        color: ColorManager.primaryColor,
                      ),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 40),

            // نص التحميل
            Text(
              'جاري تحضير القصة الرائعة...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // مؤشر تقدم ملون
            Container(
              width: 200,
              height: 6,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(3),
              ),
              child: AnimatedBuilder(
                animation: loadingAnimation,
                builder: (context, child) {
                  return FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: loadingAnimation.value,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.yellow.shade300,
                            Colors.orange.shade300,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 40),

            // زر الإلغاء
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.2),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                'إلغاء',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
