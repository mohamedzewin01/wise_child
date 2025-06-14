import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wise_child/features/Stories/presentation/widgets/story_controls.dart';

import '../../../../core/api/api_constants.dart';
import '../../../../core/di/di.dart';
import '../bloc/Stories_cubit.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:equatable/equatable.dart';
import 'dart:async';

import '../widgets/story_page_view.dart';

class StoriesPage extends StatefulWidget {
  const StoriesPage({super.key});

  @override
  State<StoriesPage> createState() => _StoriesPageState();
}

class _StoriesPageState extends State<StoriesPage> {
  late StoriesCubit viewModel;

  @override
  void initState() {
    viewModel = getIt.get<StoriesCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: viewModel,
        ),
        BlocProvider(
          create: (context) => StoryCubit(storyPages),
        ),
      ],
      child:  Padding(
        padding: const EdgeInsets.only(bottom: kBottomNavigationBarHeight),
        child: StoryScreen(),
      )
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
  final List<StoryPage> storyPages;

  const StoryState({
    required this.currentPage,
    required this.totalPages,
    required this.status,
    required this.storyPages,
  });

  // Initial state factory
  factory StoryState.initial(List<StoryPage> pages) {
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
  final FlutterTts _flutterTts = FlutterTts(

  );

  StoryCubit(List<StoryPage> storyPages)
      : super(StoryState.initial(storyPages)) {
    _initTts();
  }

  Future<void> _initTts() async {
    await _flutterTts.awaitSpeakCompletion(true);
    await _flutterTts.setLanguage("ar-SA");
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setVoice ( {"name": "ar-xa-x-arz-local", "locale":"ar-SA"});
    List voices = await _flutterTts.getVoices;
    print(voices);
    _flutterTts.setCompletionHandler(() {
      if (state.status == PlaybackStatus.playing) {
        if (state.currentPage < state.totalPages - 1) {
          // Move to next page if not the last one
          final nextPage = state.currentPage + 1;
          emit(state.copyWith(currentPage: nextPage));
          _speak(state.storyPages[nextPage].text);
        } else {
          // Story finished
          emit(state.copyWith(status: PlaybackStatus.finished));
        }
      }
    });
  }

  void pageChanged(int page) {
    // If user swipes, stop current speech
    _flutterTts.stop();
    emit(state.copyWith(currentPage: page));
    if (state.status == PlaybackStatus.playing) {
      _speak(state.storyPages[page].text);
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
      _speak(state.storyPages[state.currentPage].text);
    }
  }

  @override
  Future<void> close() {
    _flutterTts.stop();
    return super.close();
  }
}


final storyPages = [
  StoryPage(
    imageUrl:
    "${ApiConstants.urlImage}22222.gif",
    text:
    "فِي يَومٍ مِنَ الأَيَّامِ، كَانَ هُنَاكَ قِطٌّ صَغِيرٌ يُدْعَى مِشْمِش.مُحَمَّد زُوَيْن محمد..",
  ),

  StoryPage(
    imageUrl:
    "https://images.unsplash.com/photo-1573865526739-10659fec78a5?q=85&fm=jpg&crop=entropy&cs=srgb&w=1200",
    text:
    "فِي صَبَاحٍ جَمِيلٍ، رَأَى مِشْمِشُ عُصْفُورًا صَغِيرًا يَسْقُطُ مِنَ العُشِّ...",
  ),
  StoryPage(
    imageUrl:
    "https://images.unsplash.com/photo-1573865526739-10659fec78a5?q=85&fm=jpg&crop=entropy&cs=srgb&w=1200",
    text: "اِسْتَخْدَمَ مِشْمِشُ ذَيْلَهُ لِيَرْفَعَ العُصْفُورَ...",
  ),
  StoryPage(
    imageUrl:
    "https://images.unsplash.com/photo-1573865526739-10659fec78a5?q=85&fm=jpg&crop=entropy&cs=srgb&w=1200",
    text:
    "جَاءَتِ الأُمُّ العُصْفُورَةُ وَقَالَتْ: \"شُكْرًا لَكَ يَا مِشْمِشُ...\"",
  ),
  StoryPage(
    imageUrl:
    "https://images.unsplash.com/photo-1573865526739-10659fec78a5?q=85&fm=jpg&crop=entropy&cs=srgb&w=1200",
    text:
    "اِبْتَسَمَ مِشْمِشُ، وَقَالَ: \"مُسَاعَدَةُ الأَصْدِقَاءِ تُسْعِدُنِي!\"",
  ),
];


class StoryScreen extends StatefulWidget {
  const StoryScreen({super.key});

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {},
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "مِشْمِشُ القِطُّ الذَّكِيُّ",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,

                fontSize: 18,
              ),
            ),
            Text(
              "قصة للأطفال",
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.home_outlined, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: BlocListener<StoryCubit, StoryState>(

        listener: (context, state) {
          if (state.currentPage != _pageController.page?.round()) {
            _pageController.animateToPage(
              state.currentPage,
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
            );
          }
        },
        child: Column(
          children: [
            // Story Page Viewer
            Expanded(
              child: BlocBuilder<StoryCubit, StoryState>(
                builder: (context, state) {
                  final page = state.storyPages[state.currentPage];
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 700),
                    transitionBuilder: (Widget child, Animation<double> animation) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                    child: StoryPageView(
                      key: ValueKey<int>(state.currentPage),
                      imageUrl: page.imageUrl,
                      text: page.text,
                    ),
                  );
                },
              ),
            ),

            // Controls rebuilt by BlocBuilder
            const StoryControls(),
          ],
        ),
      ),
    );
  }
}





