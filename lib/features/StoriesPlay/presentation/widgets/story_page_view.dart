
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wise_child/core/resources/cashed_image.dart';
import '../../data/models/response/story_play_dto.dart';
import '../pages/StoriesPlay_page.dart';
import 'story_controls.dart';

class StoryPageView extends StatelessWidget {
  final String imageUrl;
  final String text;

  const StoryPageView({
    super.key,
    required this.imageUrl,
    required this.text
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          CustomImage(
              url: imageUrl
          ),

          // Gradient overlay for better text readability
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 250,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.8)
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ),

          // Story text
          Positioned(
            bottom: 120,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  height: 1.6,
                  fontFamily: 'Cairo', // Use Arabic font if available
                  shadows: [
                    Shadow(
                      blurRadius: 8.0,
                      color: Colors.black87,
                      offset: Offset(1.0, 1.0),
                    ),
                    Shadow(
                      blurRadius: 4.0,
                      color: Colors.black54,
                      offset: Offset(0.5, 0.5),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// StoryScreen widget that handles the PageView and auto-play
class StoryScreen extends StatefulWidget {
  final List<Clips> storyPages;

  const StoryScreen({
    super.key,
    required this.storyPages,
  });

  @override
  State<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> {
  late PageController _pageController;
  late StoryCubit _storyCubit;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    // Initialize StoryCubit with auto-play enabled
    _storyCubit = StoryCubit(widget.storyPages, autoPlay: true);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _storyCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<StoryCubit>(
      create: (context) => _storyCubit,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: BlocListener<StoryCubit, StoryState>(
          listener: (context, state) {
            // Auto-scroll to current page when state changes
            if (_pageController.hasClients &&
                _pageController.page?.round() != state.currentPage) {
              _pageController.animateToPage(
                state.currentPage,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            }
          },
          child: BlocBuilder<StoryCubit, StoryState>(
            builder: (context, state) {
              return Stack(
                children: [
                  // PageView for story pages
                  PageView.builder(
                    controller: _pageController,
                    itemCount: widget.storyPages.length,
                    onPageChanged: (index) {
                      // Update cubit when user manually swipes
                      context.read<StoryCubit>().pageChanged(index);
                    },
                    itemBuilder: (context, index) {
                      final clip = widget.storyPages[index];
                      return StoryPageView(
                        imageUrl: clip.imageUrl ?? '',
                        text: clip.clipText ?? '',
                      );
                    },
                  ),

                  // Story controls overlay
                  const Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: StoryControls(),
                  ),

                  // Back button
                  Positioned(
                    top: MediaQuery.of(context).padding.top + 10,
                    left: 16,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black.withOpacity(0.5),
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                  ),

                  // Story finished overlay
                  if (state.status == PlaybackStatus.finished)
                    Container(
                      color: Colors.black.withOpacity(0.7),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 80,
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'انتهت القصة!',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    // Replay story
                                    context.read<StoryCubit>().pageChanged(0);
                                    context.read<StoryCubit>().togglePlayPause();
                                  },
                                  child: const Text('إعادة تشغيل'),
                                ),
                                const SizedBox(width: 20),
                                ElevatedButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('العودة'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}