
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
    if (widget.maintenanceUntil == null) return;

    try {
      final targetTime = DateTime.parse(widget.maintenanceUntil!).toLocal();
      final now = DateTime.now();

      if (targetTime.isAfter(now)) {
        _remainingTime = targetTime.difference(now);
      }
    } catch (e) {
      debugPrint('خطأ في تحليل وقت الصيانة: $e');
    }
  }


  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime.inSeconds > 0) {
        setState(() {
          _remainingTime = _remainingTime - const Duration(seconds: 1);
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.maintenanceUntil == null || _remainingTime.inSeconds <= 0) {
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
}