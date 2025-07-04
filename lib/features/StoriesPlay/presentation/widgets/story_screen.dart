// الشاشة الرئيسية للقصة مع التحكم والأنيميشن
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wise_child/features/StoriesPlay/data/models/response/story_play_dto.dart';
import 'package:wise_child/features/StoriesPlay/presentation/pages/StoriesPlay_page.dart';
import 'package:wise_child/features/StoriesPlay/presentation/widgets/story_controls.dart';
import 'package:wise_child/features/StoriesPlay/presentation/widgets/story_page_view.dart';
import 'package:wise_child/core/resources/color_manager.dart';

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
  bool _hasShownDialog = false; // لضمان عدم إظهار الـ dialog أكثر من مرة

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

  void _showFinishDialog() {
    if (_hasShownDialog) return;
    _hasShownDialog = true;

    HapticFeedback.heavyImpact();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: Dialog(
          backgroundColor: Colors.transparent,
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
                // أيقونة النجاح مع أنيميشن
                TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 800),
                  tween: Tween(begin: 0.0, end: 1.0),
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.white,
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
                          Icons.check_circle,
                          color: Colors.green.shade600,
                          size: 50,
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 20),

                // رسالة التهنئة
                Text(
                  'أحسنت! 🎉',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  'لقد انتهيت من القصة بنجاح!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 30),

                // أزرار الإجراءات
                Column(
                  children: [
                    // زر الإعادة
                    SizedBox(
                      width: double.infinity,
                      child: _buildDialogButton(
                        icon: Icons.replay_rounded,
                        label: 'إعادة تشغيل',
                        onPressed: () {
                          Navigator.of(context).pop();
                          _restartStory();
                        },
                      ),
                    ),

                    const SizedBox(height: 15),

                    // زر العودة
                    SizedBox(
                      width: double.infinity,
                      child: _buildDialogButton(
                        icon: Icons.home_rounded,
                        label: 'العودة',
                        onPressed: () {
                          Navigator.of(context).pop(); // إغلاق الـ dialog
                          Navigator.of(context).pop(); // العودة للصفحة السابقة
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDialogButton({
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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        elevation: 5,
        shadowColor: Colors.black.withOpacity(0.3),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 22),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  void _restartStory() async {
    setState(() => _hasShownDialog = false);
    _lastCurrentPage = 0;

    if (_pageController.hasClients) {
      await _pageController.animateToPage(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }

    if (mounted) {
      _storyCubit.restartStory();
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
                    // تحديث الصفحة عند تغيير المقطع
                    if (state.currentPage != _lastCurrentPage && _isPageViewReady) {
                      _scrollToPage(state.currentPage);
                    }

                    // إظهار الـ dialog عند الانتهاء
                    if (state.status == PlaybackStatus.finished && !_hasShownDialog) {
                      // تأخير بسيط لضمان انتهاء الأنيميشن
                      Future.delayed(const Duration(milliseconds: 500), () {
                        if (mounted) {
                          _showFinishDialog();
                        }
                      });
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

                        // مؤشر التحميل أثناء التهيئة
                        if (!_isPageViewReady)
                          Center(
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.7),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      ColorManager.primaryColor,
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  Text(
                                    'جاري التحضير...',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
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
}