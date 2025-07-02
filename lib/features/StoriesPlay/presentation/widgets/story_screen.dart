// الشاشة الرئيسية للقصة مع التحكم والأنيميشن
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wise_child/features/StoriesPlay/data/models/response/story_play_dto.dart';
import 'package:wise_child/features/StoriesPlay/presentation/pages/StoriesPlay_page.dart';
import 'package:wise_child/features/StoriesPlay/presentation/widgets/story_controls.dart';
import 'package:wise_child/features/StoriesPlay/presentation/widgets/story_page_view.dart';

class EnhancedStoryScreen extends StatefulWidget {
  final List<Clips> storyPages;

  const EnhancedStoryScreen({
    super.key,
    required this.storyPages,
  });

  @override
  State<EnhancedStoryScreen> createState() => _EnhancedStoryScreenState();
}

class _EnhancedStoryScreenState extends State<EnhancedStoryScreen>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late StoryCubit _storyCubit;
  late AnimationController _entranceController;
  late Animation<double> _entranceAnimation;

  int _lastCurrentPage = 0;
  bool _isPageViewReady = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _storyCubit = StoryCubit(widget.storyPages, autoPlay: true);

    _entranceController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _entranceAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _entranceController,
      curve: Curves.easeOutCubic,
    ));

    // تأخير بسيط قبل بدء الأنيميشن
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _entranceController.forward();
        setState(() => _isPageViewReady = true);
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _storyCubit.close();
    _entranceController.dispose();
    super.dispose();
  }

  void _scrollToPage(int pageIndex) {
    if (_pageController.hasClients &&
        pageIndex != _lastCurrentPage &&
        pageIndex >= 0 &&
        pageIndex < widget.storyPages.length &&
        _isPageViewReady) {

      _lastCurrentPage = pageIndex;

      _pageController.animateToPage(
        pageIndex,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<StoryCubit>(
      create: (context) => _storyCubit,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: AnimatedBuilder(
          animation: _entranceAnimation,
          builder: (context, child) {
            return Opacity(
              opacity: _entranceAnimation.value,
              child: Transform.scale(
                scale: 0.95 + (_entranceAnimation.value * 0.05),
                child: BlocConsumer<StoryCubit, StoryState>(
                  listener: (context, state) {
                    if (state.currentPage != _lastCurrentPage && _isPageViewReady) {
                      _scrollToPage(state.currentPage);
                    }
                  },
                  builder: (context, state) {
                    return Stack(
                      children: [
                        // PageView للقصص
                        if (_isPageViewReady)
                          PageView.builder(
                            controller: _pageController,
                            itemCount: widget.storyPages.length,
                            onPageChanged: (index) {
                              if (index != state.currentPage) {
                                context.read<StoryCubit>().pageChanged(index);
                                _lastCurrentPage = index;
                              }
                            },
                            itemBuilder: (context, index) {
                              final clip = widget.storyPages[index];
                              return StoryPageView(
                                imageUrl: clip.imageUrl ?? '',
                                text: clip.clipText ?? '',
                                pageIndex: index,
                                totalPages: widget.storyPages.length,
                              );
                            },
                          ),

                        // أدوات التحكم
                        const Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: EnhancedStoryControls(),
                        ),

                        // زر العودة المحسن
                        _buildBackButton(context),

                        // شاشة انتهاء القصة
                        if (state.status == PlaybackStatus.finished)
                          _buildFinishedOverlay(context, state),
                      ],
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 10,
      right: 16,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black.withOpacity(0.5),
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: IconButton(
          padding: const EdgeInsets.only(right: 2),
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 22,
          ),
          onPressed: () {
            HapticFeedback.lightImpact();
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }

  Widget _buildFinishedOverlay(BuildContext context, StoryState state) {
    return Container(
      color: Colors.black.withOpacity(0.8),
      child: Center(
        child: TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 800),
          tween: Tween(begin: 0.0, end: 1.0),
          builder: (context, value, child) {
            return Transform.scale(
              scale: 0.8 + (value * 0.2),
              child: Opacity(
                opacity: value,
                child: Container(
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.green.shade400,
                        Colors.green.shade600,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.5),
                        blurRadius: 30,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // أيقونة النجاح
                      Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.check_circle,
                          color: Colors.green.shade600,
                          size: 50,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // رسالة الإنجاز
                      const Text(
                        'أحسنت! 🎉',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      const Text(
                        'لقد انتهيت من القصة بنجاح!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 30),

                      // أزرار الإجراءات
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildActionButton(
                            icon: Icons.replay_rounded,
                            label: 'إعادة',
                            onPressed: () async {
                              _lastCurrentPage = 0;
                              if (_pageController.hasClients) {
                                await _pageController.animateToPage(
                                  0,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              }
                              if (context.mounted) {
                                context.read<StoryCubit>().restartStory();
                              }
                            },
                          ),
                          _buildActionButton(
                            icon: Icons.home_rounded,
                            label: 'العودة',
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: () {
        HapticFeedback.lightImpact();
        onPressed();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.green.shade600,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 5,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}