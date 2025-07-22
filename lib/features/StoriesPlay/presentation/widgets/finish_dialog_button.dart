import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void showFinishDialog({required BuildContext context, required bool hasShownDialog,required VoidCallback restartStory}) {
  if (hasShownDialog) return;
  hasShownDialog = true;

  HapticFeedback.heavyImpact();

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => WillPopScope(
      onWillPop: () async => false,
      child: Dialog(
        backgroundColor: Colors.transparent,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
            final screenHeight = MediaQuery.of(context).size.height;
            final maxHeight = screenHeight * (isLandscape ? 0.8 : 0.6);

            return ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: maxHeight,
                maxWidth: isLandscape ? 500 : double.infinity,
              ),
              child: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.all(isLandscape ? 10 : 20),
                  padding: EdgeInsets.all(isLandscape ? 20 : 30),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.green.shade400,
                        Colors.green.shade600,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(isLandscape ? 20 : 30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.5),
                        blurRadius: 30,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // أيقونة النجاح مع أنيميشن
                      TweenAnimationBuilder<double>(
                        duration: const Duration(milliseconds: 800),
                        tween: Tween(begin: 0.0, end: 1.0),
                        builder: (context, value, child) {
                          return Transform.scale(
                            scale: value,
                            child: Container(
                              padding: EdgeInsets.all(isLandscape ? 10 : 15),
                              decoration: BoxDecoration(
                                color: Colors.white,
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
                                Icons.check_circle,
                                color: Colors.green.shade600,
                                size: isLandscape ? 35 : 50,
                              ),
                            ),
                          );
                        },
                      ),

                      SizedBox(height: isLandscape ? 15 : 20),

                      // رسالة التهنئة
                      Text(
                        'أحسنت! 🎉',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isLandscape ? 22 : 28,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: isLandscape ? 8 : 10),

                      Text(
                        'لقد انتهيت من القصة بنجاح!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isLandscape ? 14 : 16,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: isLandscape ? 20 : 30),

                      // أزرار الإجراءات
                      if (isLandscape)
                      // في الوضع الأفقي: أزرار جنباً إلى جنب
                        Row(
                          children: [
                            Expanded(
                              child: _buildDialogButton(
                                icon: Icons.replay_rounded,
                                label: 'إعادة تشغيل',
                                isCompact: true,
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  restartStory();
                                },
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: _buildDialogButton(
                                icon: Icons.home_rounded,
                                label: 'العودة',
                                isCompact: true,
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                },
                              ),
                            ),
                          ],
                        )
                      else
                      // في الوضع الرأسي: أزرار عمودية
                        Column(
                          children: [
                            // زر الإعادة
                            SizedBox(
                              width: double.infinity,
                              child: _buildDialogButton(
                                icon: Icons.replay_rounded,
                                label: 'إعادة تشغيل',
                                isCompact: false,
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  restartStory();
                                },
                              ),
                            ),

                            const SizedBox(height: 15),

                            // زر العودة
                            SizedBox(
                              width: double.infinity,
                              child: _buildDialogButton(
                                icon: Icons.home_rounded,
                                label: 'العودة',
                                isCompact: false,
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                },
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    ),
  );
}

Widget _buildDialogButton({
  required IconData icon,
  required String label,
  required VoidCallback onPressed,
  bool isCompact = false,
}) {
  return ElevatedButton(
    onPressed: () {
      HapticFeedback.lightImpact();
      onPressed();
    },
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.white,
      foregroundColor: Colors.green.shade600,
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 12 : 20,
        vertical: isCompact ? 10 : 15,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(isCompact ? 20 : 25),
      ),
      elevation: 5,
      shadowColor: Colors.black.withOpacity(0.3),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: isCompact ? 18 : 22),
        SizedBox(width: isCompact ? 6 : 10),
        Flexible(
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: isCompact ? 14 : 16,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    ),
  );
}


// void _restartStory({required BuildContext context, required bool hasShownDialog,}) async {
//   setState(() => hasShownDialog = false);
//   _lastCurrentPage = 0;
//
//   if (_pageController.hasClients) {
//     await _pageController.animateToPage(
//       0,
//       duration: const Duration(milliseconds: 300),
//       curve: Curves.easeInOut,
//     );
//   }
//
//   if (mounted) {
//     _storyCubit.restartStory();
//   }
// }