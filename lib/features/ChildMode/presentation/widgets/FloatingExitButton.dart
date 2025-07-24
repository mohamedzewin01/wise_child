// lib/features/ChildMode/presentation/widgets/floating_exit_button.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'dart:math' as math;

import 'PinExitDialog.dart';

class FloatingExitButton extends StatefulWidget {
  const FloatingExitButton({super.key});

  @override
  State<FloatingExitButton> createState() => _FloatingExitButtonState();
}

class _FloatingExitButtonState extends State<FloatingExitButton>
    with TickerProviderStateMixin {
  late AnimationController _floatController;
  late AnimationController _pulseController;
  late AnimationController _hiddenController;
  late Animation<double> _floatAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _scaleAnimation;

  bool _isHidden = true;
  int _tapCount = 0;
  DateTime? _lastTap;

  @override
  void initState() {
    super.initState();

    _floatController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _hiddenController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _floatAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _floatController,
      curve: Curves.easeInOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _hiddenController,
      curve: Curves.elasticOut,
    ));

    _floatController.repeat(reverse: true);
    _pulseController.repeat(reverse: true);

    // إخفاء الزر في البداية
    _hideButton();
  }

  @override
  void dispose() {
    _floatController.dispose();
    _pulseController.dispose();
    _hiddenController.dispose();
    super.dispose();
  }

  void _hideButton() {
    setState(() => _isHidden = true);
    _hiddenController.reverse();
  }

  void _showButton() {
    setState(() => _isHidden = false);
    _hiddenController.forward();
  }

  void _handleSecretTap() {
    final now = DateTime.now();

    // إعادة تعيين العداد إذا مر أكثر من 3 ثوانٍ
    if (_lastTap == null || now.difference(_lastTap!).inSeconds > 3) {
      _tapCount = 0;
    }

    _tapCount++;
    _lastTap = now;

    HapticFeedback.lightImpact();

    // إظهار الزر بعد 5 نقرات سريعة
    if (_tapCount >= 1) {
      _showButton();
      _tapCount = 0;

      // إخفاء الزر تلقائياً بعد 10 ثوانٍ
      Future.delayed(const Duration(seconds: 10), () {
        if (mounted && !_isHidden) {
          _hideButton();
        }
      });
    }
  }

  void _handleExitTap() {
    HapticFeedback.mediumImpact();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const PinExitDialog(),
    ).then((result) {
      if (result == true) {
        // الخروج من وضع الطفل
        Navigator.of(context).pop();
      } else {
        // إخفاء الزر مرة أخرى إذا لم يتم الخروج
        _hideButton();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // منطقة النقر السرية (غير مرئية)
        Positioned(
          top: MediaQuery.of(context).padding.top + 20,
          left: 20,
          child: GestureDetector(
            onTap: _handleSecretTap,
            child: Container(
              width: 60,
              height: 60,
              color: Colors.transparent,
              child: _isHidden && _tapCount > 0
                  ? Center(
                child: Container(
                  width: 8 + (_tapCount * 4.0),
                  height: 8 + (_tapCount * 4.0),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                ),
              )
                  : null,
            ),
          ),
        ),

        // زر الخروج (مرئي فقط عند الحاجة)
        if (!_isHidden)
          Positioned(
            top: MediaQuery.of(context).padding.top + 20,
            left: 20,
            child: AnimatedBuilder(
              animation: Listenable.merge([
                _floatAnimation,
                _pulseAnimation,
                _scaleAnimation,
              ]),
              builder: (context, child) {
                final floatOffset = math.sin(_floatAnimation.value * 2 * math.pi) * 3;

                return Transform.translate(
                  offset: Offset(0, floatOffset),
                  child: Transform.scale(
                    scale: _scaleAnimation.value * _pulseAnimation.value,
                    child: GestureDetector(
                      onTap: _handleExitTap,
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.red.shade400,
                              Colors.red.shade600,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.red.withOpacity(0.4),
                              blurRadius: 15,
                              offset: const Offset(0, 8),
                              spreadRadius: 2,
                            ),
                            BoxShadow(
                              color: Colors.white.withOpacity(0.3),
                              blurRadius: 5,
                              offset: const Offset(0, -2),
                              spreadRadius: -1,
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            // أيقونة الخروج
                            Center(
                              child: Icon(
                                Icons.exit_to_app_rounded,
                                color: Colors.white,
                                size: 25,
                              ),
                            ),

                            // تأثير الضوء المتحرك
                            Positioned.fill(
                              child: AnimatedBuilder(
                                animation: _floatAnimation,
                                builder: (context, child) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: SweepGradient(
                                        colors: [
                                          Colors.transparent,
                                          Colors.white.withOpacity(0.2),
                                          Colors.transparent,
                                        ],
                                        stops: const [0.0, 0.5, 1.0],
                                        transform: GradientRotation(
                                          _floatAnimation.value * 2 * math.pi,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

        // مؤشر النقرات (للتغذية البصرية)
        if (_isHidden && _tapCount > 0)
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${5 - _tapCount} نقرات متبقية للخروج',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}