// import 'package:equatable/equatable.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:wise_child/core/api/api_constants.dart';
// import '../../../../core/di/di.dart';
// import '../../data/models/response/story_play_dto.dart';
// import '../bloc/StoriesPlay_cubit.dart';
// import '../widgets/story_page_view.dart';
//
// class StoriesPlayPage extends StatefulWidget {
//   const StoriesPlayPage(
//       {super.key, required this.childId, required this.storyId});
//
//   final int childId;
//   final int storyId;
//
//   @override
//   State<StoriesPlayPage> createState() => _StoriesPlayPageState();
// }
//
// class _StoriesPlayPageState extends State<StoriesPlayPage> {
//   late StoriesPlayCubit viewModel;
//
//   @override
//   void initState() {
//     viewModel = getIt.get<StoriesPlayCubit>();
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider.value(value: viewModel
//           ..getStories(childId: widget.childId, storyId: widget.storyId)),
//       ],
//       child: Padding(
//         padding: const EdgeInsets.only(bottom: kBottomNavigationBarHeight),
//         child: BlocBuilder<StoriesPlayCubit, StoriesPlayState>(
//           builder: (context, state) {
//             if (state is StoriesPlayLoading) {
//               return const Center(child: CircularProgressIndicator());
//             }
//             if (state is StoriesPlayFailure) {
//               return const Center(child: Text('حدث خطأ في تحميل القصة',
//                   style: TextStyle(color: Colors.red)));
//             }
//             if (state is StoriesPlaySuccess) {
//               String status = state.storyPlayEntity.status ?? '';
//
//               List<Clips> storyPages = state.storyPlayEntity.clips ?? [];
//               return status == 'processing'
//                   ? Center(child: Text(state.storyPlayEntity.message ?? ''))
//                   : StoryScreen(storyPages: storyPages);
//             }
//             return const Center(child: CircularProgressIndicator());
//           },
//         ),
//       ),
//     );
//   }
// }
//
// enum PlaybackStatus { playing, paused, finished, loading }
//
// class StoryState extends Equatable {
//   final int currentPage;
//   final int totalPages;
//   final PlaybackStatus status;
//   final List<Clips> storyPages;
//   final Duration? duration;
//   final Duration? position;
//
//   const StoryState({
//     required this.currentPage,
//     required this.totalPages,
//     required this.status,
//     required this.storyPages,
//     this.duration,
//     this.position,
//   });
//
//   // Initial state factory
//   factory StoryState.initial(List<Clips> pages) {
//     return StoryState(
//       currentPage: 0,
//       totalPages: pages.length,
//       status: PlaybackStatus.paused,
//       storyPages: pages,
//     );
//   }
//
//   StoryState copyWith({
//     int? currentPage,
//     PlaybackStatus? status,
//     Duration? duration,
//     Duration? position,
//   }) {
//     return StoryState(
//       currentPage: currentPage ?? this.currentPage,
//       totalPages: totalPages,
//       status: status ?? this.status,
//       storyPages: storyPages,
//       duration: duration ?? this.duration,
//       position: position ?? this.position,
//     );
//   }
//
//   @override
//   List<Object?> get props =>
//       [currentPage, status, totalPages, storyPages, duration, position];
// }
//
// class StoryCubit extends Cubit<StoryState> {
//   final AudioPlayer _audioPlayer = AudioPlayer();
//
//   StoryCubit(List<Clips> storyPages, {bool autoPlay = true})
//       : super(StoryState.initial(storyPages)) {
//     _initAudioPlayer();
//
//     if (autoPlay) {
//       _setPlaylistAndPlay();
//     }
//   }
//
//   Future<void> _setPlaylistAndPlay() async {
//     try {
//       emit(state.copyWith(status: PlaybackStatus.loading));
//
//       final playlist = ConcatenatingAudioSource(
//         useLazyPreparation: false, // تحميل مسبق لكل المقاطع لتفادي التقطيع
//         children: state.storyPages
//             .map((clip) =>
//             AudioSource.uri(
//                 Uri.parse('${ApiConstants.urlAudio}${clip.audioUrl}')))
//             .toList(),
//       );
//
//       await _audioPlayer.setAudioSource(playlist, preload: true);
//
//       // إعداد التشغيل لعدم التكرار
//       await _audioPlayer.setLoopMode(LoopMode.off);
//
//       await _audioPlayer.play();
//
//       emit(state.copyWith(status: PlaybackStatus.playing, currentPage: 0));
//     } catch (e) {
//       print('Error setting playlist: $e');
//       emit(state.copyWith(status: PlaybackStatus.paused));
//     }
//   }
//
//   void _initAudioPlayer() {
//     // مراقبة حالة المشغل
//     _audioPlayer.playerStateStream.listen((playerState) {
//       print('Player state changed: ${playerState
//           .processingState}, playing: ${playerState.playing}');
//
//       // التحقق من انتهاء القائمة
//       if (playerState.processingState == ProcessingState.completed) {
//         print('Playlist completed');
//         // التأكد من أننا انتهينا فعلاً من كل المقاطع
//         emit(state.copyWith(
//             status: PlaybackStatus.finished,
//             currentPage: state.storyPages.length - 1
//         ));
//       } else if (playerState.playing &&
//           playerState.processingState != ProcessingState.completed) {
//         if (state.status != PlaybackStatus.playing) {
//           emit(state.copyWith(status: PlaybackStatus.playing));
//         }
//       } else if (playerState.processingState == ProcessingState.ready &&
//           !playerState.playing) {
//         if (state.status != PlaybackStatus.paused &&
//             state.status != PlaybackStatus.finished) {
//           emit(state.copyWith(status: PlaybackStatus.paused));
//         }
//       }
//     });
//
//     // مراقبة التغيير في المقطع الحالي
//     _audioPlayer.currentIndexStream.listen((index) {
//       if (index != null && !isClosed) {
//         print('Audio track changed to index: $index');
//         // التأكد من أن الفهرس صحيح
//         if (index >= 0 && index < state.storyPages.length &&
//             index != state.currentPage) {
//           emit(state.copyWith(currentPage: index));
//         }
//       }
//     });
//
//     // مراقبة الموضع
//     _audioPlayer.positionStream.listen((position) {
//       if (!isClosed) {
//         emit(state.copyWith(position: position));
//       }
//     });
//
//     // مراقبة المدة
//     _audioPlayer.durationStream.listen((duration) {
//       if (duration != null && !isClosed) {
//         emit(state.copyWith(duration: duration));
//       }
//     });
//   }
//
//   // إضافة دالة لإعادة تشغيل القصة من البداية
//   Future<void> restartStory() async {
//     try {
//       print('Restarting story from beginning');
//
//       // إيقاف التشغيل أولاً
//       await _audioPlayer.stop();
//
//       // الذهاب إلى المقطع الأول
//       await _audioPlayer.seek(Duration.zero, index: 0);
//
//       // تحديث الحالة
//       emit(state.copyWith(
//           currentPage: 0,
//           status: PlaybackStatus.paused,
//           position: Duration.zero
//       ));
//
//       // بدء التشغيل
//       await _audioPlayer.play();
//
//       emit(state.copyWith(status: PlaybackStatus.playing));
//     } catch (e) {
//       print('Error restarting story: $e');
//       emit(state.copyWith(status: PlaybackStatus.paused));
//     }
//   }
//
//   void pageChanged(int page) async {
//     if (!isClosed && page >= 0 && page < state.storyPages.length) {
//       print('Manually changing to page: $page');
//       await _audioPlayer.seek(Duration.zero, index: page);
//       emit(state.copyWith(currentPage: page, position: Duration.zero));
//     }
//   }
//
//   void togglePlayPause() {
//     if (_audioPlayer.playing) {
//       _audioPlayer.pause();
//       emit(state.copyWith(status: PlaybackStatus.paused));
//     } else {
//       _audioPlayer.play();
//       emit(state.copyWith(status: PlaybackStatus.playing));
//     }
//   }
//
//   void seekTo(Duration position) {
//     _audioPlayer.seek(position);
//   }
//
//   @override
//   Future<void> close() async {
//     await _audioPlayer.dispose();
//     return super.close();
//   }
// }


import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:wise_child/core/api/api_constants.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'package:wise_child/features/StoriesPlay/presentation/widgets/story_screen.dart';
import '../../../../core/di/di.dart';
import '../../data/models/response/story_play_dto.dart';
import '../bloc/StoriesPlay_cubit.dart';
import '../widgets/story_page_view.dart';

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

    _loadingController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _loadingAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _loadingController,
      curve: Curves.easeInOut,
    ));

    _loadingController.repeat();
  }

  @override
  void dispose() {
    _loadingController.dispose();
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
                return _buildProcessingScreen(state.storyPlayEntity.message ?? '');
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
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
              Icon(
                Icons.error_outline_rounded,
                size: 80,
                color: Colors.white,
              ),

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
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// باقي الـ Enums والـ Classes كما هي...
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

// class StoryCubit extends Cubit<StoryState> {
//   final AudioPlayer _audioPlayer = AudioPlayer();
//   bool _isCompleted = false; // متغير لتتبع حالة الانتهاء
//
//   StoryCubit(List<Clips> storyPages, {bool autoPlay = true})
//       : super(StoryState.initial(storyPages)) {
//     _initAudioPlayer();
//
//     if (autoPlay) {
//       _setPlaylistAndPlay();
//     }
//   }
//
//   Future<void> _setPlaylistAndPlay() async {
//     try {
//       emit(state.copyWith(status: PlaybackStatus.loading));
//
//       final playlist = ConcatenatingAudioSource(
//         useLazyPreparation: false,
//         children: state.storyPages
//             .map((clip) => AudioSource.uri(
//             Uri.parse('${ApiConstants.urlAudio}${clip.audioUrl}')))
//             .toList(),
//       );
//
//       await _audioPlayer.setAudioSource(playlist, preload: true);
//       await _audioPlayer.setLoopMode(LoopMode.off);
//
//       // تأخير قصير قبل بدء التشغيل للسماح بالانتقال السلس
//       await Future.delayed(const Duration(milliseconds: 500));
//
//       await _audioPlayer.play();
//
//       emit(state.copyWith(
//         status: PlaybackStatus.playing,
//         currentPage: 0,
//         isFirstPlay: false,
//       ));
//     } catch (e) {
//       print('Error setting playlist: $e');
//       emit(state.copyWith(status: PlaybackStatus.paused));
//     }
//   }
//
//   void _initAudioPlayer() {
//     // مراقبة حالة المشغل
//     _audioPlayer.playerStateStream.listen((playerState) {
//       print('Player state: ${playerState.processingState}, playing: ${playerState.playing}');
//
//       // التحقق من انتهاء القائمة
//       if (playerState.processingState == ProcessingState.completed && !_isCompleted) {
//         print('Playlist completed - stopping all playback');
//         _isCompleted = true;
//
//         // إيقاف المشغل تماماً
//         _audioPlayer.stop();
//
//         emit(state.copyWith(
//           status: PlaybackStatus.finished,
//           currentPage: state.storyPages.length - 1,
//         ));
//       } else if (playerState.playing &&
//           playerState.processingState != ProcessingState.completed &&
//           !_isCompleted) {
//         if (state.status != PlaybackStatus.playing) {
//           emit(state.copyWith(status: PlaybackStatus.playing));
//         }
//       } else if (playerState.processingState == ProcessingState.ready &&
//           !playerState.playing &&
//           !_isCompleted) {
//         if (state.status != PlaybackStatus.paused &&
//             state.status != PlaybackStatus.finished) {
//           emit(state.copyWith(status: PlaybackStatus.paused));
//         }
//       }
//     });
//
//     // مراقبة التغيير في المقطع الحالي
//     _audioPlayer.currentIndexStream.listen((index) {
//       if (index != null && !isClosed && !_isCompleted) {
//         print('Audio track changed to index: $index');
//
//         // التأكد من صحة الفهرس
//         if (index >= 0 && index < state.storyPages.length) {
//           // إذا وصلنا للمقطع الأخير، نراقب بعناية
//           if (index == state.storyPages.length - 1) {
//             print('Reached last track');
//           }
//
//           if (index != state.currentPage) {
//             emit(state.copyWith(currentPage: index));
//           }
//         }
//       }
//     });
//
//     // مراقبة الموضع
//     _audioPlayer.positionStream.listen((position) {
//       if (!isClosed && !_isCompleted) {
//         emit(state.copyWith(position: position));
//       }
//     });
//
//     // مراقبة المدة
//     _audioPlayer.durationStream.listen((duration) {
//       if (duration != null && !isClosed && !_isCompleted) {
//         emit(state.copyWith(duration: duration));
//       }
//     });
//
//     // مراقبة إضافية لانتهاء المقطع الأخير
//     _audioPlayer.sequenceStateStream.listen((sequenceState) {
//       if (sequenceState != null && !_isCompleted) {
//         final currentIndex = sequenceState.currentIndex;
//         final isLastTrack = currentIndex == state.storyPages.length - 1;
//
//         // إذا كنا في المقطع الأخير، نراقب انتهاءه
//         if (isLastTrack) {
//           _audioPlayer.positionStream.listen((position) {
//             if (position != null &&
//                 _audioPlayer.duration != null &&
//                 !_isCompleted) {
//
//               // إذا اقتربنا من نهاية المقطع الأخير (آخر ثانية)
//               final remaining = _audioPlayer.duration! - position;
//               if (remaining.inMilliseconds <= 1000) {
//                 print('Approaching end of last track');
//
//                 // تأخير بسيط ثم إنهاء القصة
//                 Future.delayed(remaining + const Duration(milliseconds: 500), () {
//                   if (!_isCompleted && !isClosed) {
//                     print('Force completing story');
//                     _isCompleted = true;
//                     _audioPlayer.stop();
//                     emit(state.copyWith(
//                       status: PlaybackStatus.finished,
//                       currentPage: state.storyPages.length - 1,
//                     ));
//                   }
//                 });
//               }
//             }
//           });
//         }
//       }
//     });
//   }
//
//   Future<void> restartStory() async {
//     try {
//       print('Restarting story from beginning');
//
//       // إعادة تعيين حالة الانتهاء
//       _isCompleted = false;
//
//       // إيقاف التشغيل أولاً
//       await _audioPlayer.stop();
//
//       // الذهاب إلى المقطع الأول
//       await _audioPlayer.seek(Duration.zero, index: 0);
//
//       // تحديث الحالة
//       emit(state.copyWith(
//         currentPage: 0,
//         status: PlaybackStatus.paused,
//         position: Duration.zero,
//       ));
//
//       // بدء التشغيل
//       await _audioPlayer.play();
//
//       emit(state.copyWith(status: PlaybackStatus.playing));
//     } catch (e) {
//       print('Error restarting story: $e');
//       emit(state.copyWith(status: PlaybackStatus.paused));
//     }
//   }
//
//   void pageChanged(int page) async {
//     if (!isClosed &&
//         page >= 0 &&
//         page < state.storyPages.length &&
//         !_isCompleted) {
//       print('Manually changing to page: $page');
//
//       await _audioPlayer.seek(Duration.zero, index: page);
//       emit(state.copyWith(currentPage: page, position: Duration.zero));
//     }
//   }
//
//   void togglePlayPause() {
//     if (_isCompleted) {
//       // إذا انتهت القصة، ابدأ من جديد
//       restartStory();
//       return;
//     }
//
//     if (_audioPlayer.playing) {
//       _audioPlayer.pause();
//       emit(state.copyWith(status: PlaybackStatus.paused));
//     } else {
//       _audioPlayer.play();
//       emit(state.copyWith(status: PlaybackStatus.playing));
//     }
//   }
//
//   void seekTo(Duration position) {
//     if (!_isCompleted) {
//       _audioPlayer.seek(position);
//     }
//   }
//
//   @override
//   Future<void> close() async {
//     _isCompleted = true; // منع أي عمليات أخرى
//     await _audioPlayer.dispose();
//     return super.close();
//   }
// }
class StoryCubit extends Cubit<StoryState> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  late final int _totalTracks; // عدد المقاطع الإجمالي
  bool _hasFinished = false; // لمنع التكرار

  StoryCubit(List<Clips> storyPages, {bool autoPlay = true})
      : super(StoryState.initial(storyPages)) {
    _totalTracks = storyPages.length;
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
            .map((clip) => AudioSource.uri(
            Uri.parse('${ApiConstants.urlAudio}${clip.audioUrl}')))
            .toList(),
      );

      await _audioPlayer.setAudioSource(playlist, preload: true);
      await _audioPlayer.setLoopMode(LoopMode.off);

      await Future.delayed(const Duration(milliseconds: 500));
      await _audioPlayer.play();

      emit(state.copyWith(
        status: PlaybackStatus.playing,
        currentPage: 0,
        isFirstPlay: false,
      ));
    } catch (e) {
      print('Error setting playlist: $e');
      emit(state.copyWith(status: PlaybackStatus.paused));
    }
  }

  void _initAudioPlayer() {
    // مراقبة التغيير في المقطع الحالي
    _audioPlayer.currentIndexStream.listen((index) {
      if (index != null && !isClosed && !_hasFinished) {
        print('Current track: $index of $_totalTracks');

        if (index >= 0 && index < _totalTracks) {
          // تحديث الصفحة الحالية
          if (index != state.currentPage) {
            emit(state.copyWith(currentPage: index));
          }

          // إذا وصلنا للمقطع الأخير
          if (index == _totalTracks - 1) {
            print('Reached last track - monitoring for completion');
            _monitorLastTrack();
          }
        }
      }
    });

    // مراقبة حالة التشغيل العامة
    _audioPlayer.playerStateStream.listen((playerState) {
      if (!_hasFinished && !isClosed) {
        if (playerState.processingState == ProcessingState.completed) {
          _finishStory();
        } else if (playerState.playing) {
          if (state.status != PlaybackStatus.playing) {
            emit(state.copyWith(status: PlaybackStatus.playing));
          }
        } else if (!playerState.playing &&
            playerState.processingState == ProcessingState.ready) {
          if (state.status != PlaybackStatus.paused &&
              state.status != PlaybackStatus.finished) {
            emit(state.copyWith(status: PlaybackStatus.paused));
          }
        }
      }
    });

    // مراقبة الموضع
    _audioPlayer.positionStream.listen((position) {
      if (!isClosed && !_hasFinished) {
        emit(state.copyWith(position: position));
      }
    });

    // مراقبة المدة
    _audioPlayer.durationStream.listen((duration) {
      if (duration != null && !isClosed && !_hasFinished) {
        emit(state.copyWith(duration: duration));
      }
    });
  }

  void _monitorLastTrack() {
    // مراقبة خاصة للمقطع الأخير
    _audioPlayer.positionStream.listen((position) {
      if (position != null && !_hasFinished && !isClosed) {
        _audioPlayer.durationStream.listen((duration) {
          if (duration != null && !_hasFinished) {
            // إذا اقتربنا من النهاية (آخر ثانية)
            final remaining = duration - position;
            if (remaining.inMilliseconds <= 1000 &&
                state.currentPage == _totalTracks - 1) {
              print('Last track finishing - preparing to complete story');

              // انتظار انتهاء المقطع ثم إنهاء القصة
              Future.delayed(remaining + const Duration(milliseconds: 300), () {
                if (!_hasFinished && !isClosed) {
                  _finishStory();
                }
              });
            }
          }
        });
      }
    });
  }

  void _finishStory() {
    if (!_hasFinished && !isClosed) {
      print('🎉 Story finished! Showing completion dialog');
      _hasFinished = true;

      emit(state.copyWith(
        status: PlaybackStatus.finished,
        currentPage: _totalTracks - 1,
      ));
    }
  }

  Future<void> restartStory() async {
    try {
      print('🔄 Restarting story from beginning');

      // إعادة تعيين كل شيء
      _hasFinished = false;

      await _audioPlayer.stop();
      await _audioPlayer.seek(Duration.zero, index: 0);

      emit(state.copyWith(
        currentPage: 0,
        status: PlaybackStatus.paused,
        position: Duration.zero,
      ));

      await _audioPlayer.play();
      emit(state.copyWith(status: PlaybackStatus.playing));
    } catch (e) {
      print('Error restarting story: $e');
      emit(state.copyWith(status: PlaybackStatus.paused));
    }
  }

  void pageChanged(int page) async {
    if (!isClosed && page >= 0 && page < _totalTracks && !_hasFinished) {
      print('📖 Manual page change to: $page');
      await _audioPlayer.seek(Duration.zero, index: page);
      emit(state.copyWith(currentPage: page, position: Duration.zero));
    }
  }

  void togglePlayPause() {
    if (_hasFinished) {
      // إذا انتهت القصة، ابدأ من جديد
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
    if (!_hasFinished) {
      _audioPlayer.seek(position);
    }
  }

  @override
  Future<void> close() async {
    _hasFinished = true;
    await _audioPlayer.dispose();
    return super.close();
  }
}