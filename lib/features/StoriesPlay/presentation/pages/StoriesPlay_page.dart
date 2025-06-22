

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
              return const Center(child: Text('حدث خطأ في تحميل القصة', style: TextStyle(color: Colors.red)));
            }
            if (state is StoriesPlaySuccess) {
         String status = state.storyPlayEntity.status ?? '';

              List<Clips> storyPages = state.storyPlayEntity.clips ?? [];
              return status == 'processing' ?  Center(child: Text(state.storyPlayEntity.message ?? '')) : StoryScreen(storyPages: storyPages);
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
  }

  Future<void> _setPlaylistAndPlay() async {
    try {
      emit(state.copyWith(status: PlaybackStatus.loading));

      final playlist = ConcatenatingAudioSource(
        useLazyPreparation: false, // تحميل مسبق لكل المقاطع لتفادي التقطيع
        children: state.storyPages
            .map((clip) => AudioSource.uri(Uri.parse('${ApiConstants.urlAudio}${clip.audioUrl}')))
            .toList(),
      );

      await _audioPlayer.setAudioSource(playlist, preload: true);

      // إعداد التشغيل لعدم التكرار
      await _audioPlayer.setLoopMode(LoopMode.off);

      await _audioPlayer.play();

      emit(state.copyWith(status: PlaybackStatus.playing, currentPage: 0));
    } catch (e) {
      print('Error setting playlist: $e');
      emit(state.copyWith(status: PlaybackStatus.paused));
    }
  }

  void _initAudioPlayer() {
    // مراقبة حالة المشغل
    _audioPlayer.playerStateStream.listen((playerState) {
      print('Player state changed: ${playerState.processingState}, playing: ${playerState.playing}');

      // التحقق من انتهاء القائمة
      if (playerState.processingState == ProcessingState.completed) {
        print('Playlist completed');
        // التأكد من أننا انتهينا فعلاً من كل المقاطع
        emit(state.copyWith(
            status: PlaybackStatus.finished,
            currentPage: state.storyPages.length - 1
        ));
      } else if (playerState.playing && playerState.processingState != ProcessingState.completed) {
        if (state.status != PlaybackStatus.playing) {
          emit(state.copyWith(status: PlaybackStatus.playing));
        }
      } else if (playerState.processingState == ProcessingState.ready && !playerState.playing) {
        if (state.status != PlaybackStatus.paused && state.status != PlaybackStatus.finished) {
          emit(state.copyWith(status: PlaybackStatus.paused));
        }
      }
    });

    // مراقبة التغيير في المقطع الحالي
    _audioPlayer.currentIndexStream.listen((index) {
      if (index != null && !isClosed) {
        print('Audio track changed to index: $index');
        // التأكد من أن الفهرس صحيح
        if (index >= 0 && index < state.storyPages.length && index != state.currentPage) {
          emit(state.copyWith(currentPage: index));
        }
      }
    });

    // مراقبة الموضع
    _audioPlayer.positionStream.listen((position) {
      if (!isClosed) {
        emit(state.copyWith(position: position));
      }
    });

    // مراقبة المدة
    _audioPlayer.durationStream.listen((duration) {
      if (duration != null && !isClosed) {
        emit(state.copyWith(duration: duration));
      }
    });
  }

  // إضافة دالة لإعادة تشغيل القصة من البداية
  Future<void> restartStory() async {
    try {
      print('Restarting story from beginning');

      // إيقاف التشغيل أولاً
      await _audioPlayer.stop();

      // الذهاب إلى المقطع الأول
      await _audioPlayer.seek(Duration.zero, index: 0);

      // تحديث الحالة
      emit(state.copyWith(
          currentPage: 0,
          status: PlaybackStatus.paused,
          position: Duration.zero
      ));

      // بدء التشغيل
      await _audioPlayer.play();

      emit(state.copyWith(status: PlaybackStatus.playing));

    } catch (e) {
      print('Error restarting story: $e');
      emit(state.copyWith(status: PlaybackStatus.paused));
    }
  }

  void pageChanged(int page) async {
    if (!isClosed && page >= 0 && page < state.storyPages.length) {
      print('Manually changing to page: $page');
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