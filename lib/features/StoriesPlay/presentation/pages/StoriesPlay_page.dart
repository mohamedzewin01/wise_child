
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:wise_child/core/api/api_constants.dart';
import '../../../../core/di/di.dart';
import '../../data/models/response/story_play_dto.dart';
import '../bloc/StoriesPlay_cubit.dart';
import '../widgets/story_page_view.dart';

class StoriesPlayPage extends StatefulWidget {
  const StoriesPlayPage({super.key});

  @override
  State<StoriesPlayPage> createState() => _StoriesPlayPageState();
}

class _StoriesPlayPageState extends State<StoriesPlayPage> {
  late StoriesPlayCubit viewModel;

  @override
  void initState() {
    viewModel = getIt.get<StoriesPlayCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: viewModel..getStories()),
      ],
      child: Padding(
        padding: const EdgeInsets.only(bottom: kBottomNavigationBarHeight),
        child: BlocBuilder<StoriesPlayCubit, StoriesPlayState>(
          builder: (context, state) {
            if (state is StoriesPlayLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is StoriesPlayFailure) {
              return const Center(child: Text('حدث خطأ في تحميل القصة'));
            }
            if (state is StoriesPlaySuccess) {
              List<Clips> storyPages = state.storyPlayEntity.clips ?? [];
              return StoryScreen(storyPages: storyPages);
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}

enum PlaybackStatus { playing, paused, finished, loading }

class StoryState extends Equatable {
  final int currentPage;
  final int totalPages;
  final PlaybackStatus status;
  final List<Clips> storyPages;
  final Duration? duration;
  final Duration? position;

  const StoryState({
    required this.currentPage,
    required this.totalPages,
    required this.status,
    required this.storyPages,
    this.duration,
    this.position,
  });

  // Initial state factory
  factory StoryState.initial(List<Clips> pages) {
    return StoryState(
      currentPage: 0,
      totalPages: pages.length,
      status: PlaybackStatus.paused,
      storyPages: pages,
    );
  }

  StoryState copyWith({
    int? currentPage,
    PlaybackStatus? status,
    Duration? duration,
    Duration? position,
  }) {
    return StoryState(
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages,
      status: status ?? this.status,
      storyPages: storyPages,
      duration: duration ?? this.duration,
      position: position ?? this.position,
    );
  }

  @override
  List<Object?> get props => [currentPage, status, totalPages, storyPages, duration, position];
}

class StoryCubit extends Cubit<StoryState> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  StoryCubit(List<Clips> storyPages, {bool autoPlay = true})
      : super(StoryState.initial(storyPages)) {
    _initAudioPlayer();

    if (autoPlay) {
      _setPlaylistAndPlay();
    }
    _audioPlayer.positionStream.listen((position) {
      if (isClosed) return;

      final currentIndex = _audioPlayer.currentIndex ?? 0;

      emit(state.copyWith(
        currentPage: currentIndex,
        position: position,
      ));
    });

  }

  Future<void> _setPlaylistAndPlay() async {
    try {

      final playlist = ConcatenatingAudioSource(
        useLazyPreparation: false, // تحميل مسبق لكل المقاطع لتفادي التقطيع
        children: state.storyPages
            .map((clip) => AudioSource.uri(Uri.parse('${ApiConstants.urlAudio}${clip.audioUrl}')))
            .toList(),
      );

      await _audioPlayer.setAudioSource(playlist, preload: true);
      await _audioPlayer.play();

      emit(state.copyWith(status: PlaybackStatus.playing, currentPage: 0));
    } catch (e) {
      print('Error setting playlist: $e');
      emit(state.copyWith(status: PlaybackStatus.paused));
    }
  }

  void _initAudioPlayer() {
    _audioPlayer.playerStateStream.listen((playerState) {
      print('Player state changed: ${playerState.processingState}, playing: ${playerState.playing}');

      if (playerState.processingState == ProcessingState.completed) {
        print('Playlist completed');
        emit(state.copyWith(status: PlaybackStatus.finished));
      }
    });

    _audioPlayer.positionStream.listen((position) {
      final currentIndex = _audioPlayer.currentIndex ?? 0;

      if (!isClosed && currentIndex != state.currentPage) {
        emit(state.copyWith(currentPage: currentIndex));
      }

      if (!isClosed) {
        emit(state.copyWith(position: position));
      }
    });

    _audioPlayer.durationStream.listen((duration) {
      if (duration != null && !isClosed) {
        emit(state.copyWith(duration: duration));
      }
    });
  }

  void pageChanged(int page) async {
    if (!isClosed) {
      await _audioPlayer.seek(Duration.zero, index: page);
      emit(state.copyWith(currentPage: page, position: Duration.zero));
    }
  }

  void togglePlayPause() {
    if (_audioPlayer.playing) {
      _audioPlayer.pause();
      emit(state.copyWith(status: PlaybackStatus.paused));
    } else {
      _audioPlayer.play();
      emit(state.copyWith(status: PlaybackStatus.playing));
    }
  }

  void seekTo(Duration position) {
    _audioPlayer.seek(position);
  }

  @override
  Future<void> close() async {
    await _audioPlayer.dispose();
    return super.close();
  }
}
