// lib/features/ChildMode/presentation/widgets/pin_exit_dialog.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'package:wise_child/core/resources/style_manager.dart';
import 'package:wise_child/core/utils/cashed_data_shared_preferences.dart';
import 'dart:math' as math;

class PinExitDialog extends StatefulWidget {
  const PinExitDialog({super.key});

  @override
  State<PinExitDialog> createState() => _PinExitDialogState();
}

class _PinExitDialogState extends State<PinExitDialog>
    with TickerProviderStateMixin {
  late AnimationController _bounceController;
  late AnimationController _shakeController;
  late Animation<double> _bounceAnimation;
  late Animation<double> _shakeAnimation;

  String _enteredPin = '';
  final String _correctPin = '1234'; // يمكن جعله قابل للتخصيص
  bool _isWrongPin = false;
  int _attemptsLeft = 3;

  @override
  void initState() {
    super.initState();

    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _bounceAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _bounceController,
      curve: Curves.elasticOut,
    ));

    _shakeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _shakeController,
      curve: Curves.elasticInOut,
    ));

    _bounceController.forward();
  }

  @override
  void dispose() {
    _bounceController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  void _onNumberTap(String number) {
    if (_enteredPin.length < 4) {
      setState(() {
        _enteredPin += number;
        _isWrongPin = false;
      });

      HapticFeedback.lightImpact();

      if (_enteredPin.length == 4) {
        _checkPin();
      }
    }
  }

  void _onDeleteTap() {
    if (_enteredPin.isNotEmpty) {
      setState(() {
        _enteredPin = _enteredPin.substring(0, _enteredPin.length - 1);
        _isWrongPin = false;
      });
      HapticFeedback.lightImpact();
    }
  }

  void _checkPin() {
    if (_enteredPin == _correctPin) {
      // PIN صحيح - الخروج من وضع الطفل
      HapticFeedback.heavyImpact();
      Navigator.of(context).pop(true);
    } else {
      // PIN خاطئ
      _attemptsLeft--;

      if (_attemptsLeft <= 0) {
        // لا توجد محاولات متبقية
        HapticFeedback.heavyImpact();
        Navigator.of(context).pop(false);
        _showTooManyAttemptsMessage();
      } else {
        // محاولة خاطئة - إعادة تعيين
        setState(() {
          _isWrongPin = true;
          _enteredPin = '';
        });

        _shakeController.reset();
        _shakeController.forward();
        HapticFeedback.heavyImpact();
      }
    }
  }

  void _showTooManyAttemptsMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم تجاوز عدد المحاولات المسموحة'),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),
      child: AnimatedBuilder(
        animation: _bounceAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _bounceAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white,
                    Colors.blue.shade50,
                    Colors.purple.shade50,
                  ],
                ),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 30,
                    offset: const Offset(0, 15),
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 30),
                    _buildPinDisplay(),
                    const SizedBox(height: 30),
                    _buildNumberPad(),
                    const SizedBox(height: 20),
                    _buildActionButtons(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        // أيقونة الحماية
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.blue.shade400,
                Colors.purple.shade400,
              ],
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Icon(
            Icons.security_rounded,
            size: 40,
            color: Colors.white,
          ),
        ),

        const SizedBox(height: 20),

        // العنوان
        Text(
          'رقم الأمان للكبار',
          style: getBoldStyle(
            fontSize: 22,
            color: ColorManager.primaryColor,
          ),
        ),

        const SizedBox(height: 10),

        // الوصف
        Text(
          'أدخل الرقم السري للخروج من وضع الأطفال',
          style: getMediumStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
          textAlign: TextAlign.center,
        ),

        // عداد المحاولات
        if (_isWrongPin)
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: AnimatedBuilder(
              animation: _shakeAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(
                    math.sin(_shakeAnimation.value * 2 * math.pi) * 10,
                    0,
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.red.shade100,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.red.shade300),
                    ),
                    child: Text(
                      'رقم خاطئ! المحاولات المتبقية: $_attemptsLeft',
                      style: TextStyle(
                        color: Colors.red.shade700,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildPinDisplay() {
    return AnimatedBuilder(
      animation: _shakeAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: _isWrongPin
              ? Offset(math.sin(_shakeAnimation.value * 4 * math.pi) * 5, 0)
              : Offset.zero,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(4, (index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                child: _buildPinDot(index),
              );
            }),
          ),
        );
      },
    );
  }

  Widget _buildPinDot(int index) {
    final bool isFilled = index < _enteredPin.length;
    final bool isError = _isWrongPin;

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 200),
      tween: Tween(begin: 0.0, end: isFilled ? 1.0 : 0.0),
      builder: (context, value, child) {
        return Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            gradient: isFilled
                ? LinearGradient(
              colors: isError
                  ? [Colors.red.shade400, Colors.red.shade600]
                  : [Colors.blue.shade400, Colors.purple.shade400],
            )
                : null,
            color: !isFilled ? Colors.grey.shade300 : null,
            shape: BoxShape.circle,
            border: Border.all(
              color: isError ? Colors.red.shade300 : Colors.grey.shade400,
              width: 2,
            ),
            boxShadow: isFilled
                ? [
              BoxShadow(
                color: (isError ? Colors.red : Colors.blue).withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ]
                : [],
          ),
          child: Center(
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: value,
              child: Icon(
                Icons.circle,
                size: 8,
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNumberPad() {
    return Container(
      width: 250,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
        ),
        itemCount: 12,
        itemBuilder: (context, index) {
          if (index == 9) {
            // زر فارغ
            return const SizedBox();
          } else if (index == 10) {
            // رقم 0
            return _buildNumberButton('0');
          } else if (index == 11) {
            // زر الحذف
            return _buildDeleteButton();
          } else {
            // الأرقام 1-9
            return _buildNumberButton('${index + 1}');
          }
        },
      ),
    );
  }

  Widget _buildNumberButton(String number) {
    return GestureDetector(
      onTap: () => _onNumberTap(number),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white,
              Colors.grey.shade50,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Colors.grey.shade300,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            number,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: ColorManager.primaryColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDeleteButton() {
    return GestureDetector(
      onTap: _onDeleteTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.red.shade100,
              Colors.red.shade50,
            ],
          ),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Colors.red.shade200,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.red.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Icon(
            Icons.backspace_outlined,
            size: 28,
            color: Colors.red.shade600,
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        // زر الإلغاء
        Expanded(
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(false),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: Colors.grey.shade300,
                  width: 2,
                ),
              ),
              child: Center(
                child: Text(
                  'إلغاء',
                  style: getBoldStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
            ),
          ),
        ),

        const SizedBox(width: 15),

        // زر المساعدة
        Expanded(
          child: GestureDetector(
            onTap: _showHelpDialog,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.orange.shade300,
                    Colors.orange.shade400,
                  ],
                ),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.help_outline_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'مساعدة',
                      style: getBoldStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Icon(
              Icons.info_outline_rounded,
              color: Colors.blue.shade600,
            ),
            const SizedBox(width: 10),
            Text('مساعدة'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'الرقم السري الافتراضي هو: 1234',
              style: getBoldStyle(
                fontSize: 16,
                color: ColorManager.primaryColor,
              ),
            ),
            const SizedBox(height: 15),
            Text(
              'يمكن للوالدين تغيير الرقم السري من الإعدادات.',
              style: getMediumStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.amber.shade200),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.amber.shade700,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'هذا الرقم للكبار فقط!',
                      style: TextStyle(
                        color: Colors.amber.shade800,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'فهمت',
              style: getBoldStyle(
                fontSize: 16,
                color: ColorManager.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}