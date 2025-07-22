import 'package:equatable/equatable.dart';
import 'package:wise_child/features/StoriesPlay/data/models/response/story_play_dto.dart';
import 'package:wise_child/features/StoriesPlay/presentation/bloc/story_play/story_play_cubit.dart';
import 'package:wise_child/features/StoriesPlay/presentation/widgets/story_screen.dart';

class StoryState extends Equatable {
  final int currentPage;
  final int totalPages;
  final PlaybackStatus status;
  final List<Clips> storyPages;
  final Duration? duration;
  final Duration? position;
  final bool isFirstPlay;

  const StoryState({
    required this.currentPage,
    required this.totalPages,
    required this.status,
    required this.storyPages,
    this.duration,
    this.position,
    this.isFirstPlay = true,
  });

  factory StoryState.initial(List<Clips> pages) {
    return StoryState(
      currentPage: 0,
      totalPages: pages.length,
      status: PlaybackStatus.loading,
      storyPages: pages,
      isFirstPlay: true,
    );
  }

  StoryState copyWith({
    int? currentPage,
    PlaybackStatus? status,
    Duration? duration,
    Duration? position,
    bool? isFirstPlay,
  }) {
    return StoryState(
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages,
      status: status ?? this.status,
      storyPages: storyPages,
      duration: duration ?? this.duration,
      position: position ?? this.position,
      isFirstPlay: isFirstPlay ?? this.isFirstPlay,
    );
  }

  @override
  List<Object?> get props => [
    currentPage,
    status,
    totalPages,
    storyPages,
    duration,
    position,
    isFirstPlay,
  ];
}