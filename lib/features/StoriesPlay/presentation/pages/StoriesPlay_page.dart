import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:wise_child/features/StoriesPlay/domain/entities/story_entity.dart';
import '../../../../core/di/di.dart';
import '../bloc/StoriesPlay_cubit.dart';
import '../widgets/story_controls.dart';
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
        // BlocProvider(
        //   create: (context) => StoryCubit(storyPages),
        // ),
      ],
      child: Padding(
        padding: const EdgeInsets.only(bottom: kBottomNavigationBarHeight),
        child: BlocBuilder<StoriesPlayCubit, StoriesPlayState>(
          builder: (context, state) {
            if (state is StoriesPlayLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is StoriesPlayFailure) {}
            if (state is StoriesPlaySuccess) {
              List<ClipEntity> storyPages = state.storyPlayEntity.clips ?? [];
              return StoryScreen(storyPages: storyPages);
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}

class StoryPage {
  final String imageUrl;
  final String text;

  StoryPage({required this.imageUrl, required this.text});
}

enum PlaybackStatus { playing, paused, finished }

class StoryState extends Equatable {
  final int currentPage;
  final int totalPages;
  final PlaybackStatus status;
  final List<ClipEntity> storyPages;

  const StoryState({
    required this.currentPage,
    required this.totalPages,
    required this.status,
    required this.storyPages,
  });

  // Initial state factory
  factory StoryState.initial(List<ClipEntity> pages) {
    return StoryState(
      currentPage: 0,
      totalPages: pages.length,
      status: PlaybackStatus.paused,
      storyPages: pages,
    );
  }

  StoryState copyWith({int? currentPage, PlaybackStatus? status}) {
    return StoryState(
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages,
      status: status ?? this.status,
      storyPages: storyPages,
    );
  }

  @override
  List<Object?> get props => [currentPage, status, totalPages, storyPages];
}

class StoryCubit extends Cubit<StoryState> {
  final FlutterTts _flutterTts = FlutterTts();

  StoryCubit(List<ClipEntity> storyPages)
    : super(StoryState.initial(storyPages)) {
    _initTts();
  }

  Future<void> _initTts() async {
    await _flutterTts.awaitSpeakCompletion(true);
    await _flutterTts.setLanguage("ar-EG");
    await _flutterTts.setSpeechRate(0.35);
    await _flutterTts.setPitch(1.0);
    await _flutterTts.setPitch(1.0);
    printVoices();
    _flutterTts.setCompletionHandler(() async {
      if (state.status == PlaybackStatus.playing) {
        if (state.currentPage < state.totalPages - 1) {
          final nextPage = state.currentPage + 1;
          emit(state.copyWith(currentPage: nextPage));
          await Future.delayed(Duration(milliseconds: 500));
          _speak(state.storyPages[nextPage].clipText!);
        } else {
          // Story finished
          emit(state.copyWith(status: PlaybackStatus.finished));
        }
      }
    });
  }

  void printVoices() async {
    List<dynamic> voices = await _flutterTts.getVoices;
    for (var voice in voices) {
      print(voice);
    }
  }

  void pageChanged(int page) {
    // If user swipes, stop current speech
    _flutterTts.stop();
    emit(state.copyWith(currentPage: page));
    if (state.status == PlaybackStatus.playing) {
      _speak(state.storyPages[page].clipText!);
    }
  }

  Future<void> _speak(String text) async {
    await _flutterTts.speak(text);
  }

  void togglePlayPause() {
    if (state.status == PlaybackStatus.playing) {
      _flutterTts.stop();
      emit(state.copyWith(status: PlaybackStatus.paused));
    } else {
      emit(state.copyWith(status: PlaybackStatus.playing));
      _speak(state.storyPages[state.currentPage].clipText!);
    }
  }

  @override
  Future<void> close() {
    _flutterTts.stop();
    return super.close();
  }
}

class StoryScreen extends StatefulWidget {
  const StoryScreen({super.key, required this.storyPages});

  final List<ClipEntity> storyPages;

  @override
  State<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StoryCubit(widget.storyPages),
      child: Scaffold(
        body: BlocListener<StoryCubit, StoryState>(
          listener: (context, state) {
            if (_pageController.hasClients &&
                state.currentPage != _pageController.page?.round()) {
              _pageController.animateToPage(
                state.currentPage,
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
              );
            }
          },
          child: Column(
            children: [
              Expanded(
                child: BlocBuilder<StoryCubit, StoryState>(
                  builder: (context, state) {
                    final page = state.storyPages[state.currentPage];
                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 700),
                      transitionBuilder:
                          (Widget child, Animation<double> animation) {
                            return FadeTransition(
                              opacity: animation,
                              child: child,
                            );
                          },
                      child: Stack(
                        fit: StackFit.expand,
                        alignment: Alignment.bottomCenter,
                        children: [
                          StoryPageView(
                            key: ValueKey<int>(state.currentPage),
                            imageUrl: page.imageUrl ?? '',
                            text: page.clipText ?? '',
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,

                            child: StoryControls(),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
