// import 'dart:async';
//
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:wise_child/core/api/api_constants.dart';
// import 'package:wise_child/features/StoriesPlay/data/models/response/story_play_dto.dart';
// import 'package:wise_child/features/StoriesPlay/presentation/bloc/story_play/story_play_state.dart';
// import 'package:wise_child/features/StoriesPlay/presentation/widgets/story_screen.dart';
//
//
//
// enum PlaybackStatus { playing, paused, finished, loading }
// class StoryCubit extends Cubit<StoryState> {
//   final AudioPlayer _audioPlayer = AudioPlayer();
//   bool _hasCompleted = false;
//   StreamSubscription? _playerStateSubscription;
//   StreamSubscription? _currentIndexSubscription;
//   StreamSubscription? _positionSubscription;
//   StreamSubscription? _durationSubscription;
//
//   StoryCubit(List<Clips> storyPages, {bool autoPlay = true})
//       : super(StoryState.initial(storyPages)) {
//     _initAudioPlayer();
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
//             .map(
//               (clip) => AudioSource.uri(
//             Uri.parse('${ApiConstants.urlAudio}${clip.audioUrl}'),
//           ),
//         )
//             .toList(),
//       );
//
//       await _audioPlayer.setAudioSource(playlist, preload: true);
//       await _audioPlayer.setLoopMode(LoopMode.off);
//
//       await Future.delayed(const Duration(milliseconds: 500));
//       await _audioPlayer.play();
//
//       emit(
//         state.copyWith(
//           status: PlaybackStatus.playing,
//           currentPage: 0,
//           isFirstPlay: false,
//         ),
//       );
//     } catch (e) {
//       print('Error setting playlist: $e');
//       emit(state.copyWith(status: PlaybackStatus.paused));
//     }
//   }
//
//   void _initAudioPlayer() {
//     _cancelAllSubscriptions();
//
//     _playerStateSubscription = _audioPlayer.playerStateStream.listen((
//         playerState,
//         ) {
//       if (_hasCompleted || isClosed) return;
//
//       switch (playerState.processingState) {
//         case ProcessingState.completed:
//           _completeStory();
//           break;
//         case ProcessingState.ready:
//           if (playerState.playing) {
//             if (state.status != PlaybackStatus.playing) {
//               emit(state.copyWith(status: PlaybackStatus.playing));
//             }
//           } else {
//             if (state.status != PlaybackStatus.paused &&
//                 state.status != PlaybackStatus.finished) {
//               emit(state.copyWith(status: PlaybackStatus.paused));
//             }
//           }
//           break;
//         default:
//           break;
//       }
//     });
//
//     _currentIndexSubscription = _audioPlayer.currentIndexStream.listen((index) {
//       if (_hasCompleted || isClosed || index == null) return;
//
//       if (index >= 0 &&
//           index < state.storyPages.length &&
//           index != state.currentPage) {
//         emit(state.copyWith(currentPage: index));
//       }
//     });
//
//     _positionSubscription = _audioPlayer.positionStream.listen((position) {
//       if (_hasCompleted || isClosed) return;
//       emit(state.copyWith(position: position));
//     });
//
//     _durationSubscription = _audioPlayer.durationStream.listen((duration) {
//       if (_hasCompleted || isClosed || duration == null) return;
//       emit(state.copyWith(duration: duration));
//     });
//   }
//
//   void _completeStory() {
//     if (_hasCompleted || isClosed) return;
//
//     _hasCompleted = true;
//     _audioPlayer.stop();
//
//     emit(
//       state.copyWith(
//         status: PlaybackStatus.finished,
//         currentPage: state.storyPages.length - 1,
//       ),
//     );
//   }
//
//   void _cancelAllSubscriptions() {
//     _playerStateSubscription?.cancel();
//     _currentIndexSubscription?.cancel();
//     _positionSubscription?.cancel();
//     _durationSubscription?.cancel();
//   }
//
//   Future<void> restartStory() async {
//     try {
//       _hasCompleted = false;
//       await _audioPlayer.stop();
//       await _audioPlayer.seek(Duration.zero, index: 0);
//
//       emit(
//         state.copyWith(
//           currentPage: 0,
//           status: PlaybackStatus.paused,
//           position: Duration.zero,
//         ),
//       );
//
//       await _audioPlayer.play();
//       emit(state.copyWith(status: PlaybackStatus.playing));
//     } catch (e) {
//       print('Error restarting story: $e');
//       emit(state.copyWith(status: PlaybackStatus.paused));
//     }
//   }
//
//   void pageChanged(int page) async {
//     if (_hasCompleted || isClosed) return;
//
//     if (page >= 0 && page < state.storyPages.length) {
//       await _audioPlayer.seek(Duration.zero, index: page);
//       emit(state.copyWith(currentPage: page, position: Duration.zero));
//     }
//   }
//
//   void togglePlayPause() {
//     if (_hasCompleted) {
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
//     if (_hasCompleted) return;
//     _audioPlayer.seek(position);
//   }
//
//   @override
//   Future<void> close() async {
//     _hasCompleted = true;
//     _cancelAllSubscriptions();
//     await _audioPlayer.dispose();
//     return super.close();
//   }
// }

import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:wise_child/core/api/api_constants.dart';
import 'package:wise_child/features/StoriesPlay/data/models/response/story_play_dto.dart';
import 'package:wise_child/features/StoriesPlay/presentation/bloc/story_play/story_play_state.dart';

enum PlaybackStatus { playing, paused, finished, loading }

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

  // تم تحديث هذه الدالة لتعمل بشكل أفضل مع AnimatedSwitcher
  void pageChanged(int page) async {
    if (_hasCompleted || isClosed) return;

    if (page >= 0 && page < state.storyPages.length) {
      // تحديث الصفحة الحالية فوراً لـ AnimatedSwitcher
      emit(state.copyWith(currentPage: page));

      // ثم تحديث موضع الصوت
      try {
        await _audioPlayer.seek(Duration.zero, index: page);
        emit(state.copyWith(position: Duration.zero));
      } catch (e) {
        print('Error seeking to page $page: $e');
      }
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

  // دالة إضافية للتنقل المباشر بين الصفحات (مفيدة للـ gesture navigation)
  void goToNextPage() {
    if (state.currentPage < state.storyPages.length - 1) {
      pageChanged(state.currentPage + 1);
    }
  }

  void goToPreviousPage() {
    if (state.currentPage > 0) {
      pageChanged(state.currentPage - 1);
    }
  }

  @override
  Future<void> close() async {
    _hasCompleted = true;
    _cancelAllSubscriptions();
    await _audioPlayer.dispose();
    return super.close();
  }
}