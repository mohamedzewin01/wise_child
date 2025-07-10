import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:just_audio/just_audio.dart';
import 'package:wise_child/core/api/api_constants.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'package:wise_child/features/Analysis/presentation/bloc/Analysis_cubit.dart';
import 'package:wise_child/features/StoriesPlay/presentation/pages/enhanced_story_screen.dart';
import '../../../../core/di/di.dart';
import '../../data/models/response/story_play_dto.dart';
import '../bloc/StoriesPlay_cubit.dart';
import 'dart:async';

class StoriesPlayPage extends StatefulWidget {
  const StoriesPlayPage({
    super.key,
    required this.childId,
    required this.storyId,
  });

  final int childId;
  final int storyId;

  @override
  State<StoriesPlayPage> createState() => _StoriesPlayPageState();
}

class _StoriesPlayPageState extends State<StoriesPlayPage>
    with TickerProviderStateMixin {
  late StoriesPlayCubit viewModel;
  late AnimationController _loadingController;
  late Animation<double> _loadingAnimation;

  @override
  void initState() {
    super.initState();
    viewModel = getIt.get<StoriesPlayCubit>();
    context.read<AnalysisCubit>().addStoryView(widget.storyId, widget.childId);

    _loadingController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _loadingAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _loadingController, curve: Curves.easeInOut),
    );

    _loadingController.repeat();
  }

  @override
  void dispose() {
    _loadingController.dispose();
    // إعادة تعيين الاتجاه الافتراضي عند مغادرة الصفحة
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: viewModel
            ..getStories(childId: widget.childId, storyId: widget.storyId),
        ),
      ],
      child: Scaffold(
        backgroundColor: Colors.black,
        body: BlocBuilder<StoriesPlayCubit, StoriesPlayState>(
          builder: (context, state) {
            if (state is StoriesPlayLoading) {
              return _buildLoadingScreen();
            }

            if (state is StoriesPlayFailure) {
              return _buildErrorScreen();
            }

            if (state is StoriesPlaySuccess) {
              String status = state.storyPlayEntity.status ?? '';
              List<Clips> storyPages = state.storyPlayEntity.clips ?? [];

              if (status == 'processing') {
                return _buildProcessingScreen(
                  state.storyPlayEntity.message ?? '',
                );
              }

              if (storyPages.isEmpty) {
                return _buildNoContentScreen();
              }

              return EnhancedStoryScreen(storyPages: storyPages);
            }

            return _buildLoadingScreen();
          },
        ),
      ),
    );
  }

  Widget _buildLoadingScreen() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            ColorManager.primaryColor.withOpacity(0.8),
            Colors.purple.shade600,
            Colors.indigo.shade700,
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // أيقونة متحركة
            AnimatedBuilder(
              animation: _loadingAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: 0.8 + (_loadingAnimation.value * 0.4),
                  child: Transform.rotate(
                    angle: _loadingAnimation.value * 2 * 3.14159,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.white,
                            Colors.yellow.shade300,
                            Colors.orange.shade300,
                          ],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.5),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.auto_stories_rounded,
                        size: 50,
                        color: ColorManager.primaryColor,
                      ),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 40),

            // نص التحميل
            Text(
              'جاري تحضير القصة الرائعة...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // مؤشر تقدم ملون
            Container(
              width: 200,
              height: 6,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(3),
              ),
              child: AnimatedBuilder(
                animation: _loadingAnimation,
                builder: (context, child) {
                  return FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: _loadingAnimation.value,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.yellow.shade300,
                            Colors.orange.shade300,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 40),

            // زر الإلغاء
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.2),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                'إلغاء',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorScreen() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.red.shade400,
            Colors.red.shade600,
            Colors.red.shade800,
          ],
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline_rounded, size: 80, color: Colors.white),

              const SizedBox(height: 30),

              Text(
                'عذراً! حدث خطأ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              Text(
                'لم نتمكن من تحميل القصة في الوقت الحالي.\nيرجى المحاولة مرة أخرى.',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 40),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      viewModel.getStories(
                        childId: widget.childId,
                        storyId: widget.storyId,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.red.shade600,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.refresh_rounded),
                        const SizedBox(width: 8),
                        Text('إعادة المحاولة'),
                      ],
                    ),
                  ),

                  const SizedBox(width: 15),

                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.2),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: Text(
                      'العودة',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProcessingScreen(String message) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.orange.shade400,
            Colors.orange.shade600,
            Colors.orange.shade800,
          ],
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _loadingAnimation,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _loadingAnimation.value * 2 * 3.14159,
                    child: Icon(
                      Icons.settings_rounded,
                      size: 80,
                      color: Colors.white,
                    ),
                  );
                },
              ),

              const SizedBox(height: 30),

              Text(
                'جاري معالجة القصة...',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              Text(
                message,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 40),

              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.2),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  'العودة',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNoContentScreen() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.grey.shade600,
            Colors.grey.shade700,
            Colors.grey.shade800,
          ],
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.library_books_outlined,
                size: 80,
                color: Colors.white.withOpacity(0.7),
              ),

              const SizedBox(height: 30),

              Text(
                'لا يوجد محتوى',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              Text(
                'هذه القصة لا تحتوي على محتوى حالياً.\nيرجى اختيار قصة أخرى.',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 40),

              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.grey.shade700,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: Text(
                  'العودة',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// باقي الـ classes والـ enums
enum PlaybackStatus { playing, paused, finished, loading }

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

class StoryCubit extends Cubit<StoryState> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _hasCompleted = false;
  StreamSubscription? _playerStateSubscription;
  StreamSubscription? _currentIndexSubscription;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _durationSubscription;

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
        useLazyPreparation: false,
        children: state.storyPages
            .map(
              (clip) => AudioSource.uri(
                Uri.parse('${ApiConstants.urlAudio}${clip.audioUrl}'),
              ),
            )
            .toList(),
      );

      await _audioPlayer.setAudioSource(playlist, preload: true);
      await _audioPlayer.setLoopMode(LoopMode.off);

      await Future.delayed(const Duration(milliseconds: 500));
      await _audioPlayer.play();

      emit(
        state.copyWith(
          status: PlaybackStatus.playing,
          currentPage: 0,
          isFirstPlay: false,
        ),
      );
    } catch (e) {
      print('Error setting playlist: $e');
      emit(state.copyWith(status: PlaybackStatus.paused));
    }
  }

  void _initAudioPlayer() {
    _cancelAllSubscriptions();

    _playerStateSubscription = _audioPlayer.playerStateStream.listen((
      playerState,
    ) {
      if (_hasCompleted || isClosed) return;

      switch (playerState.processingState) {
        case ProcessingState.completed:
          _completeStory();
          break;
        case ProcessingState.ready:
          if (playerState.playing) {
            if (state.status != PlaybackStatus.playing) {
              emit(state.copyWith(status: PlaybackStatus.playing));
            }
          } else {
            if (state.status != PlaybackStatus.paused &&
                state.status != PlaybackStatus.finished) {
              emit(state.copyWith(status: PlaybackStatus.paused));
            }
          }
          break;
        default:
          break;
      }
    });

    _currentIndexSubscription = _audioPlayer.currentIndexStream.listen((index) {
      if (_hasCompleted || isClosed || index == null) return;

      if (index >= 0 &&
          index < state.storyPages.length &&
          index != state.currentPage) {
        emit(state.copyWith(currentPage: index));
      }
    });

    _positionSubscription = _audioPlayer.positionStream.listen((position) {
      if (_hasCompleted || isClosed) return;
      emit(state.copyWith(position: position));
    });

    _durationSubscription = _audioPlayer.durationStream.listen((duration) {
      if (_hasCompleted || isClosed || duration == null) return;
      emit(state.copyWith(duration: duration));
    });
  }

  void _completeStory() {
    if (_hasCompleted || isClosed) return;

    _hasCompleted = true;
    _audioPlayer.stop();

    emit(
      state.copyWith(
        status: PlaybackStatus.finished,
        currentPage: state.storyPages.length - 1,
      ),
    );
  }

  void _cancelAllSubscriptions() {
    _playerStateSubscription?.cancel();
    _currentIndexSubscription?.cancel();
    _positionSubscription?.cancel();
    _durationSubscription?.cancel();
  }

  Future<void> restartStory() async {
    try {
      _hasCompleted = false;
      await _audioPlayer.stop();
      await _audioPlayer.seek(Duration.zero, index: 0);

      emit(
        state.copyWith(
          currentPage: 0,
          status: PlaybackStatus.paused,
          position: Duration.zero,
        ),
      );

      await _audioPlayer.play();
      emit(state.copyWith(status: PlaybackStatus.playing));
    } catch (e) {
      print('Error restarting story: $e');
      emit(state.copyWith(status: PlaybackStatus.paused));
    }
  }

  void pageChanged(int page) async {
    if (_hasCompleted || isClosed) return;

    if (page >= 0 && page < state.storyPages.length) {
      await _audioPlayer.seek(Duration.zero, index: page);
      emit(state.copyWith(currentPage: page, position: Duration.zero));
    }
  }

  void togglePlayPause() {
    if (_hasCompleted) {
      restartStory();
      return;
    }

    if (_audioPlayer.playing) {
      _audioPlayer.pause();
      emit(state.copyWith(status: PlaybackStatus.paused));
    } else {
      _audioPlayer.play();
      emit(state.copyWith(status: PlaybackStatus.playing));
    }
  }

  void seekTo(Duration position) {
    if (_hasCompleted) return;
    _audioPlayer.seek(position);
  }

  @override
  Future<void> close() async {
    _hasCompleted = true;
    _cancelAllSubscriptions();
    await _audioPlayer.dispose();
    return super.close();
  }
}
