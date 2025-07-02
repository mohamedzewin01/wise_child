//
//
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../pages/StoriesPlay_page.dart';
//
// class StoryControls extends StatelessWidget {
//   const StoryControls({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<StoryCubit, StoryState>(
//       builder: (context, state) {
//         final cubit = context.read<StoryCubit>();
//         final isPlaying = state.status == PlaybackStatus.playing;
//         final isLoading = state.status == PlaybackStatus.loading;
//
//         double currentPosition = 0;
//         double maxDuration = 1;
//         if (state.duration != null && state.position != null) {
//           maxDuration = state.duration!.inMilliseconds.toDouble();
//           currentPosition = state.position!.inMilliseconds.toDouble();
//
//           // Ensure position doesn't exceed duration
//           if (currentPosition > maxDuration) {
//             currentPosition = maxDuration;
//           }
//
//           // Ensure values are not negative
//           if (currentPosition < 0) currentPosition = 0;
//           if (maxDuration < 0) maxDuration = 0;
//
//           // Ensure minimum duration to prevent division by zero
//           if (maxDuration == 0) maxDuration = 1;
//         }
//
//         return Container(
//           padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//               colors: [
//                 Colors.transparent,
//                 Colors.black.withOpacity(0.7),
//               ],
//             ),
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//
//               if (state.duration != null &&
//                   state.position != null &&
//                   maxDuration > 0)
//                 Column(
//                   children: [
//                     SliderTheme(
//                       data: SliderTheme.of(context).copyWith(
//                         trackHeight: 2,
//                         thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
//                         overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
//                         activeTrackColor: Colors.white,
//                         inactiveTrackColor: Colors.white.withOpacity(0.3),
//                         thumbColor: Colors.white,
//                         overlayColor: Colors.white.withOpacity(0.2),
//                       ),
//                       child: Slider(
//                         value: currentPosition.clamp(0.0, maxDuration),
//                         min: 0.0,
//                         max: maxDuration,
//                         onChanged: (value) {
//                           // Only allow seeking if not loading
//                           if (!isLoading) {
//                             cubit.seekTo(Duration(milliseconds: value.toInt()));
//                           }
//                         },
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 16),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             _formatDuration(state.position ?? Duration.zero),
//                             style: const TextStyle(
//                               color: Colors.white70,
//                               fontSize: 12,
//                             ),
//                           ),
//                           Text(
//                             _formatDuration(state.duration ?? Duration.zero),
//                             style: const TextStyle(
//                               color: Colors.white70,
//                               fontSize: 12,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                   ],
//                 ),
//
//               // Control buttons
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   // Previous button
//                   IconButton(
//                     icon: Icon(
//                       Icons.skip_previous,
//                       color: state.currentPage > 0
//                           ? Colors.white
//                           : Colors.white.withOpacity(0.5),
//                       size: 32,
//                     ),
//                     onPressed: state.currentPage > 0
//                         ? () => cubit.pageChanged(state.currentPage - 1)
//                         : null,
//                   ),
//
//                   // Play/Pause button
//                   Container(
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: Colors.white.withOpacity(0.2),
//                     ),
//                     child: IconButton(
//                       icon: isLoading
//                           ? const SizedBox(
//                         width: 24,
//                         height: 24,
//                         child: CircularProgressIndicator(
//                           strokeWidth: 2,
//                           valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                         ),
//                       )
//                           : Icon(
//                         isPlaying
//                             ? Icons.pause_circle_filled
//                             : Icons.play_circle_filled,
//                         color: Colors.white,
//                         size: 48,
//                       ),
//                       onPressed: isLoading ? null : cubit.togglePlayPause,
//                     ),
//                   ),
//
//                   // Next button
//                   IconButton(
//                     icon: Icon(
//                       Icons.skip_next,
//                       color: state.currentPage < state.totalPages - 1
//                           ? Colors.white
//                           : Colors.white.withOpacity(0.5),
//                       size: 32,
//                     ),
//                     onPressed: state.currentPage < state.totalPages - 1
//                         ? () => cubit.pageChanged(state.currentPage + 1)
//                         : null,
//                   ),
//                 ],
//               ),
//
//               // Page indicator
//               const SizedBox(height: 8),
//               Text(
//                 '${state.currentPage + 1} من ${state.totalPages}',
//                 style: const TextStyle(
//                   color: Colors.white70,
//                   fontSize: 14,
//                 ),
//                 textDirection: TextDirection.rtl,
//               ),
//
//               // Status indicator
//               if (state.status == PlaybackStatus.finished)
//                 const Padding(
//                   padding: EdgeInsets.only(top: 8.0),
//                   child: Text(
//                     'انتهت القصة',
//                     style: TextStyle(
//                       color: Colors.green,
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   String _formatDuration(Duration duration) {
//     if (duration.inMilliseconds < 0) {
//       return '00:00';
//     }
//
//     String twoDigits(int n) => n.toString().padLeft(2, '0');
//     final minutes = twoDigits(duration.inMinutes.remainder(60));
//     final seconds = twoDigits(duration.inSeconds.remainder(60));
//     return '$minutes:$seconds';
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import '../pages/StoriesPlay_page.dart';
import 'dart:math' as math;

class EnhancedStoryControls extends StatefulWidget {
  const EnhancedStoryControls({super.key});

  @override
  State<EnhancedStoryControls> createState() => _EnhancedStoryControlsState();
}

class _EnhancedStoryControlsState extends State<EnhancedStoryControls>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _progressController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _progressAnimation;

  bool _isVisible = true;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _progressController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeOutCubic,
    ));

    _pulseController.repeat(reverse: true);
    _progressController.forward();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  void _toggleVisibility() {
    setState(() => _isVisible = !_isVisible);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoryCubit, StoryState>(
      builder: (context, state) {
        final cubit = context.read<StoryCubit>();
        final isPlaying = state.status == PlaybackStatus.playing;
        final isLoading = state.status == PlaybackStatus.loading;
        final isFinished = state.status == PlaybackStatus.finished;

        // حساب التقدم
        double currentPosition = 0;
        double maxDuration = 1;
        if (state.duration != null && state.position != null) {
          maxDuration = state.duration!.inMilliseconds.toDouble();
          currentPosition = state.position!.inMilliseconds.toDouble();

          if (currentPosition > maxDuration) currentPosition = maxDuration;
          if (currentPosition < 0) currentPosition = 0;
          if (maxDuration <= 0) maxDuration = 1;
        }

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          transform: Matrix4.translationValues(
            0,
            _isVisible ? 0 : 100,
            0,
          ),
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.4),
                  Colors.black.withOpacity(0.8),
                  Colors.black.withOpacity(0.95),
                ],
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // شريط التقدم المحسن
                if (state.duration != null && state.position != null && !isFinished)
                  _buildProgressSection(currentPosition, maxDuration, cubit, isLoading),

                const SizedBox(height: 0),

                // أزرار التحكم الرئيسية
                _buildMainControls(cubit, state, isPlaying, isLoading, isFinished),

                const SizedBox(height: 10),

                // معلومات إضافية
                _buildInfoSection(state),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProgressSection(
      double currentPosition,
      double maxDuration,
      StoryCubit cubit,
      bool isLoading,
      ) {
    return Column(
      children: [
        // شريط التقدم مع تصميم محسن
        Stack(
          children: [
            // الخلفية
            Container(
              height: 6,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(3),
              ),
            ),

            // التقدم الحالي
            FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: (currentPosition / maxDuration).clamp(0.0, 1.0),
              child: Container(
                height: 6,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      ColorManager.primaryColor,
                      Colors.cyan.shade400,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(3),
                  boxShadow: [
                    BoxShadow(
                      color: ColorManager.primaryColor.withOpacity(0.5),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
            ),

            // مؤشر التقدم المتحرك
            Positioned.fill(
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 4,
                  thumbShape: _CustomSliderThumb(),
                  overlayShape: const RoundSliderOverlayShape(overlayRadius: 15),
                  activeTrackColor: Colors.transparent,
                  inactiveTrackColor: Colors.transparent,
                  thumbColor: Colors.white,
                  overlayColor: ColorManager.primaryColor.withOpacity(0.2),
                ),
                child: Slider(
                  value: currentPosition.clamp(0.0, maxDuration),
                  min: 0.0,
                  max: maxDuration,
                  onChanged: isLoading ? null : (value) {
                    cubit.seekTo(Duration(milliseconds: value.toInt()));
                  },
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        // أوقات التشغيل
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildTimeDisplay(_formatDuration(Duration(milliseconds: currentPosition.toInt()))),
            _buildTimeDisplay(_formatDuration(Duration(milliseconds: maxDuration.toInt()))),
          ],
        ),
      ],
    );
  }

  Widget _buildMainControls(
      StoryCubit cubit,
      StoryState state,
      bool isPlaying,
      bool isLoading,
      bool isFinished,
      ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // زر السابق
        _buildControlButton(
          icon: Icons.skip_previous_rounded,
          size: 25,
          isEnabled: state.currentPage > 0,
          onPressed: state.currentPage > 0
              ? () {
            HapticFeedback.lightImpact();
            cubit.pageChanged(state.currentPage - 1);
          }
              : null,
        ),

        // زر التشغيل/الإيقاف الرئيسي
        AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: isPlaying ? _pulseAnimation.value : 1.0,
              child: _buildMainPlayButton(
                isPlaying: isPlaying,
                isLoading: isLoading,
                isFinished: isFinished,
                onPressed: () {
                  HapticFeedback.mediumImpact();
                  if (isFinished) {
                    cubit.restartStory();
                  } else {
                    cubit.togglePlayPause();
                  }
                },
              ),
            );
          },
        ),

        // زر التالي
        _buildControlButton(
          icon: Icons.skip_next_rounded,
          size: 25,
          isEnabled: state.currentPage < state.totalPages - 1,
          onPressed: state.currentPage < state.totalPages - 1
              ? () {
            HapticFeedback.lightImpact();
            cubit.pageChanged(state.currentPage + 1);
          }
              : null,
        ),
      ],
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required double size,
    required bool isEnabled,
    VoidCallback? onPressed,
  }) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isEnabled
            ? Colors.white.withOpacity(0.2)
            : Colors.white.withOpacity(0.1),
        border: Border.all(
          color: isEnabled
              ? Colors.white.withOpacity(0.3)
              : Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: IconButton(
        icon: Icon(
          icon,
          color: isEnabled
              ? Colors.white
              : Colors.white.withOpacity(0.4),
          size: size,
        ),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildMainPlayButton({
    required bool isPlaying,
    required bool isLoading,
    required bool isFinished,
    required VoidCallback onPressed,
  }) {
    IconData icon;
    if (isLoading) {
      icon = Icons.hourglass_empty_rounded;
    } else if (isFinished) {
      icon = Icons.replay_rounded;
    } else {
      icon = isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded;
    }

    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            ColorManager.primaryColor,
            Colors.cyan.shade400,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: ColorManager.primaryColor.withOpacity(0.4),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(35),
          onTap: onPressed,
          child: Center(
            child: isLoading
                ? SizedBox(
              width: 30,
              height: 30,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
                : Icon(
              icon,
              color: Colors.white,
              size: 40,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection(StoryState state) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          // // مؤشر الصفحات
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: List.generate(
          //     math.min(state.totalPages, 5), // عرض حد أقصى 5 نقاط
          //         (index) {
          //       int pageIndex;
          //       if (state.totalPages <= 5) {
          //         pageIndex = index;
          //       } else {
          //         // حساب النقاط المعروضة حول الصفحة الحالية
          //         int start = math.max(0, state.currentPage - 2);
          //         int end = math.min(state.totalPages, start + 5);
          //         start = math.max(0, end - 5);
          //         pageIndex = start + index;
          //       }
          //
          //       final isActive = pageIndex == state.currentPage;
          //
          //       return AnimatedContainer(
          //         duration: const Duration(milliseconds: 300),
          //         margin: const EdgeInsets.symmetric(horizontal: 3),
          //         width: isActive ? 20 : 8,
          //         height: 8,
          //         decoration: BoxDecoration(
          //           color: isActive
          //               ? Colors.white
          //               : Colors.white.withOpacity(0.4),
          //           borderRadius: BorderRadius.circular(4),
          //           boxShadow: isActive ? [
          //             BoxShadow(
          //               color: Colors.white.withOpacity(0.5),
          //               blurRadius: 8,
          //               spreadRadius: 1,
          //             ),
          //           ] : [],
          //         ),
          //       );
          //     },
          //   ),
          // ),
          //
          // const SizedBox(height: 15),

          // معلومات الصفحة الحالية
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.menu_book_rounded,
                  color: Colors.white.withOpacity(0.8),
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  '${state.currentPage + 1} من ${state.totalPages}',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          // حالة التشغيل
          if (state.status == PlaybackStatus.finished)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.green.shade400,
                      Colors.green.shade600,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.check_circle_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'انتهت القصة',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTimeDisplay(String time) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        time,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          fontFeatures: [FontFeature.tabularFigures()],
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    if (duration.inMilliseconds < 0) {
      return '00:00';
    }

    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}

// شكل مخصص لمؤشر السلايدر
class _CustomSliderThumb extends SliderComponentShape {
  final double thumbRadius;

  const _CustomSliderThumb({this.thumbRadius = 8.0});

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbRadius);
  }

  @override
  void paint(
      PaintingContext context,
      Offset center, {
        required Animation<double> activationAnimation,
        required Animation<double> enableAnimation,
        required bool isDiscrete,
        required TextPainter labelPainter,
        required RenderBox parentBox,
        required SliderThemeData sliderTheme,
        required TextDirection textDirection,
        required double value,
        required double textScaleFactor,
        required Size sizeWithOverflow,
      }) {
    final Canvas canvas = context.canvas;

    // رسم الظل
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    canvas.drawCircle(
      center + const Offset(0, 2),
      thumbRadius + 2,
      shadowPaint,
    );

    // رسم الحلقة الخارجية
    final outerPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, thumbRadius + 2, outerPaint);

    // رسم المؤشر الداخلي
    final innerPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          ColorManager.primaryColor,
          Colors.cyan.shade400,
        ],
      ).createShader(Rect.fromCircle(center: center, radius: thumbRadius));

    canvas.drawCircle(center, thumbRadius, innerPaint);

    // رسم نقطة مضيئة في المنتصف
    final centerPaint = Paint()
      ..color = Colors.white.withOpacity(0.8)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, thumbRadius / 3, centerPaint);
  }
}