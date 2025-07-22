import 'package:flutter/material.dart';

class ProcessingScreen extends StatelessWidget {
  const ProcessingScreen({super.key, required this.message, required this.loadingAnimation});
final String message;
final    Animation<double> loadingAnimation;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.orange.shade400,
            Colors.orange.shade600,
            Colors.orange.shade800,
          ],
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: loadingAnimation,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: loadingAnimation.value * 2 * 3.14159,
                    child: Icon(
                      Icons.settings_rounded,
                      size: 80,
                      color: Colors.white,
                    ),
                  );
                },
              ),

              const SizedBox(height: 30),

              Text(
                'جاري معالجة القصة...',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              Text(
                message,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 40),

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
                  'العودة',
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
      ),
    );
  }
}
