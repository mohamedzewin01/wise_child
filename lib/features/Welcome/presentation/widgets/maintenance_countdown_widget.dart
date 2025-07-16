import 'dart:async';
import 'package:flutter/material.dart';
import 'package:wise_child/core/resources/style_manager.dart';

class MaintenanceCountdownWidget extends StatefulWidget {
  final String? maintenanceUntil;

  const MaintenanceCountdownWidget({
    super.key,
    this.maintenanceUntil,
  });

  @override
  State<MaintenanceCountdownWidget> createState() => _MaintenanceCountdownWidgetState();
}

class _MaintenanceCountdownWidgetState extends State<MaintenanceCountdownWidget>
    with TickerProviderStateMixin {

  Timer? _timer;
  Duration _remainingTime = Duration.zero;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  bool _isExpired = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimation();
    _calculateRemainingTime();
    _startTimer();
  }

  void _initializeAnimation() {
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 0.95,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _pulseController.repeat(reverse: true);
  }

  void _calculateRemainingTime() {
    if (widget.maintenanceUntil == null || widget.maintenanceUntil!.isEmpty) {
      setState(() {
        _isExpired = true;
      });
      return;
    }

    try {
      // إذا كان التاريخ لا يحتوي على معلومات المنطقة الزمنية، أضف Z للإشارة إلى UTC
      String dateString = widget.maintenanceUntil!;

      // إزالة أي مسافات إضافية
      dateString = dateString.trim();

      // إذا لم يحتوي على معلومات المنطقة الزمنية، اعتبره توقيت محلي
      DateTime targetTime;
      if (dateString.contains('T') || dateString.contains('Z') || dateString.contains('+')) {
        // التاريخ بصيغة ISO
        targetTime = DateTime.parse(dateString);
        if (!dateString.contains('Z') && !dateString.contains('+') && !dateString.contains('-', 10)) {
          // إذا لم يحتوي على معلومات المنطقة الزمنية، اعتبره UTC
          targetTime = DateTime.parse(dateString + 'Z').toLocal();
        }
      } else {
        // التاريخ بصيغة بسيطة، اعتبره توقيت محلي
        targetTime = DateTime.parse(dateString);
      }

      final now = DateTime.now();

      debugPrint('Target time: $targetTime');
      debugPrint('Current time: $now');

      if (targetTime.isAfter(now)) {
        setState(() {
          _remainingTime = targetTime.difference(now);
          _isExpired = false;
        });
        debugPrint('Remaining time: ${_remainingTime.toString()}');
      } else {
        setState(() {
          _remainingTime = Duration.zero;
          _isExpired = true;
        });
        debugPrint('Maintenance time has expired');
      }
    } catch (e) {
      debugPrint('خطأ في تحليل وقت الصيانة: $e');
      setState(() {
        _isExpired = true;
      });
    }
  }

  void _startTimer() {
    _timer?.cancel(); // إلغاء أي مؤقت سابق

    if (_isExpired || _remainingTime.inSeconds <= 0) {
      return;
    }

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted && _remainingTime.inSeconds > 0) {
        setState(() {
          _remainingTime = _remainingTime - const Duration(seconds: 1);
        });
      } else {
        setState(() {
          _isExpired = true;
        });
        timer.cancel();
      }
    });
  }

  @override
  void didUpdateWidget(MaintenanceCountdownWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.maintenanceUntil != widget.maintenanceUntil) {
      _calculateRemainingTime();
      _startTimer();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // إذا لم يكن هناك وقت صيانة أو انتهى الوقت، لا تعرض شيئاً
    if (widget.maintenanceUntil == null ||
        widget.maintenanceUntil!.isEmpty ||
        _isExpired ||
        _remainingTime.inSeconds <= 0) {
      return const SizedBox.shrink();
    }

    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blue.withOpacity(0.2),
                  Colors.purple.withOpacity(0.2),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.blue.withOpacity(0.3),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.2),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.schedule,
                      color: Colors.white.withOpacity(0.9),
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "الوقت المتبقي للصيانة",
                      style: getMediumStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildCountdownDisplay(),
                const SizedBox(height: 10),
                _buildTargetTimeDisplay(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCountdownDisplay() {
    final days = _remainingTime.inDays;
    final hours = _remainingTime.inHours % 24;
    final minutes = _remainingTime.inMinutes % 60;
    final seconds = _remainingTime.inSeconds % 60;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildTimeUnit(days, "يوم"),
        _buildSeparator(),
        _buildTimeUnit(hours, "ساعة"),
        _buildSeparator(),
        _buildTimeUnit(minutes, "دقيقة"),
        _buildSeparator(),
        _buildTimeUnit(seconds, "ثانية"),
      ],
    );
  }

  Widget _buildTimeUnit(int value, String label) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Center(
            child: Text(
              value.toString().padLeft(2, '0'),
              style: getBoldStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: getRegularStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildSeparator() {
    return Text(
      ":",
      style: getBoldStyle(
        color: Colors.white.withOpacity(0.5),
        fontSize: 20,
      ),
    );
  }

  Widget _buildTargetTimeDisplay() {
    if (widget.maintenanceUntil == null) return const SizedBox.shrink();

    try {
      String dateString = widget.maintenanceUntil!.trim();
      DateTime targetTime = DateTime.parse(dateString);

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          "انتهاء الصيانة: ${_formatDateTime(targetTime)}",
          style: getRegularStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 12,
          ),
        ),
      );
    } catch (e) {
      return const SizedBox.shrink();
    }
  }

  String _formatDateTime(DateTime dateTime) {
    // تنسيق التاريخ والوقت بشكل مفهوم
    final day = dateTime.day.toString().padLeft(2, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final year = dateTime.year.toString();
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');

    return "$day/$month/$year - $hour:$minute";
  }
}