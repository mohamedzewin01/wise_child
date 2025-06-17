
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wise_child/features/Stories/presentation/pages/Stories_page.dart';

import '../pages/StoriesPlay_page.dart';

class StoryControls extends StatelessWidget {
  const StoryControls({super.key});

  @override
  Widget build(BuildContext context) {
    // Use BlocBuilder to get the latest state and rebuild controls
    return BlocBuilder<StoryCubit, StoryState>(
      builder: (context, state) {
        final cubit = context.read<StoryCubit>();
        final progress = (state.currentPage + 1) / state.totalPages;
        final isPlaying = state.status == PlaybackStatus.playing;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          color: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey[300],
                minHeight: .5,
                color: Colors.black,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(
                      isPlaying
                          ? Icons.pause_circle_filled
                          : Icons.play_circle_filled,
                      color: Colors.white,
                      size: 40,
                    ),
                    onPressed: cubit.togglePlayPause,
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.volume_up_outlined,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () {

                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}