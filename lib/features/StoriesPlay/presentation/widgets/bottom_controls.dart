
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BottomControls extends StatelessWidget {
  const BottomControls({super.key, required this.isLandscape, required this.toggleOrientation, required this.showControls});
final  bool isLandscape;
final VoidCallback toggleOrientation;
final VoidCallback showControls;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // زر تدوير الشاشة
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black.withOpacity(0.5),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: IconButton(
                icon: Icon(
                  isLandscape ? Icons.fullscreen_exit : Icons.fullscreen,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: () {
                  HapticFeedback.lightImpact();
                  toggleOrientation();
                  showControls(); // إظهار الأدوات بعد التدوير
                },
              ),
            ),

            // زر العودة
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black.withOpacity(0.5),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: IconButton(
                padding: const EdgeInsets.only(right: 2),
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: () {
                  HapticFeedback.lightImpact();
                  // إعادة تعيين الاتجاه الافتراضي عند الخروج
                  SystemChrome.setPreferredOrientations([
                    DeviceOrientation.portraitUp,
                    DeviceOrientation.portraitDown,
                  ]);
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
