

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../pages/StoriesPlay_page.dart';

class StoryControls extends StatelessWidget {
  const StoryControls({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoryCubit, StoryState>(
      builder: (context, state) {
        final cubit = context.read<StoryCubit>();
        final isPlaying = state.status == PlaybackStatus.playing;
        final isLoading = state.status == PlaybackStatus.loading;

        double currentPosition = 0;
        double maxDuration = 1;
        if (state.duration != null && state.position != null) {
          maxDuration = state.duration!.inMilliseconds.toDouble();
          currentPosition = state.position!.inMilliseconds.toDouble();

          // Ensure position doesn't exceed duration
          if (currentPosition > maxDuration) {
            currentPosition = maxDuration;
          }

          // Ensure values are not negative
          if (currentPosition < 0) currentPosition = 0;
          if (maxDuration < 0) maxDuration = 0;

          // Ensure minimum duration to prevent division by zero
          if (maxDuration == 0) maxDuration = 1;
        }

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withOpacity(0.7),
              ],
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              if (state.duration != null &&
                  state.position != null &&
                  maxDuration > 0)
                Column(
                  children: [
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 2,
                        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                        overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
                        activeTrackColor: Colors.white,
                        inactiveTrackColor: Colors.white.withOpacity(0.3),
                        thumbColor: Colors.white,
                        overlayColor: Colors.white.withOpacity(0.2),
                      ),
                      child: Slider(
                        value: currentPosition.clamp(0.0, maxDuration),
                        min: 0.0,
                        max: maxDuration,
                        onChanged: (value) {
                          // Only allow seeking if not loading
                          if (!isLoading) {
                            cubit.seekTo(Duration(milliseconds: value.toInt()));
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _formatDuration(state.position ?? Duration.zero),
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            _formatDuration(state.duration ?? Duration.zero),
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),

              // Control buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Previous button
                  IconButton(
                    icon: Icon(
                      Icons.skip_previous,
                      color: state.currentPage > 0
                          ? Colors.white
                          : Colors.white.withOpacity(0.5),
                      size: 32,
                    ),
                    onPressed: state.currentPage > 0
                        ? () => cubit.pageChanged(state.currentPage - 1)
                        : null,
                  ),

                  // Play/Pause button
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.2),
                    ),
                    child: IconButton(
                      icon: isLoading
                          ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                          : Icon(
                        isPlaying
                            ? Icons.pause_circle_filled
                            : Icons.play_circle_filled,
                        color: Colors.white,
                        size: 48,
                      ),
                      onPressed: isLoading ? null : cubit.togglePlayPause,
                    ),
                  ),

                  // Next button
                  IconButton(
                    icon: Icon(
                      Icons.skip_next,
                      color: state.currentPage < state.totalPages - 1
                          ? Colors.white
                          : Colors.white.withOpacity(0.5),
                      size: 32,
                    ),
                    onPressed: state.currentPage < state.totalPages - 1
                        ? () => cubit.pageChanged(state.currentPage + 1)
                        : null,
                  ),
                ],
              ),

              // Page indicator
              const SizedBox(height: 8),
              Text(
                '${state.currentPage + 1} من ${state.totalPages}',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
                textDirection: TextDirection.rtl,
              ),

              // Status indicator
              if (state.status == PlaybackStatus.finished)
                const Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Text(
                    'انتهت القصة',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
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