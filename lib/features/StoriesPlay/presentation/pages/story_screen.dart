import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wise_child/features/StoriesPlay/data/models/response/story_play_dto.dart';
import 'package:wise_child/features/StoriesPlay/presentation/bloc/story_play/story_play_cubit.dart';
import 'package:wise_child/features/StoriesPlay/presentation/bloc/story_play/story_play_state.dart';
import 'package:wise_child/features/StoriesPlay/presentation/pages/StoriesPlay_page.dart';
import 'package:wise_child/features/StoriesPlay/presentation/widgets/bottom_controls.dart';
import 'package:wise_child/features/StoriesPlay/presentation/widgets/finish_dialog_button.dart';
import 'package:wise_child/features/StoriesPlay/presentation/widgets/story_controls.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'dart:async';

class StoryScreen extends StatefulWidget {
  final List<Clips> storyPages;

  const StoryScreen({super.key, required this.storyPages});

  @override
  State<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late StoryCubit _storyCubit;
  late AnimationController _entranceController;
  late AnimationController _controlsController;
  late Animation<double> _entranceAnimation;
  late Animation<double> _controlsAnimation;

  int _lastCurrentPage = 0;
  bool _isPageViewReady = false;
  bool _hasShownDialog = false;
  bool _areControlsVisible = true;
  Timer? _hideTimer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _storyCubit = StoryCubit(widget.storyPages, autoPlay: true);

    // تهيئة تحكم الأنيميشن للدخول
    _entranceController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _entranceAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _entranceController, curve: Curves.easeOutCubic),
    );

    // تهيئة تحكم الأنيميشن للأدوات
    _controlsController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _controlsAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controlsController, curve: Curves.easeInOut),
    );

    // إظهار الأدوات في البداية
    _controlsController.forward();

    // تأخير بسيط قبل بدء الأنيميشن
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _entranceController.forward();
        setState(() => _isPageViewReady = true);
      }
    });

    // بدء العداد لإخفاء الأدوات مرة واحدة فقط في البداية
    _resetHideTimer();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _storyCubit.close();
    _entranceController.dispose();
    _controlsController.dispose();
    _hideTimer?.cancel();
    // إعادة تعيين الاتجاه الافتراضي عند مغادرة الصفحة
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  void _resetHideTimer() {
    _hideTimer?.cancel();
    // إخفاء الأدوات بعد 5 ثوان من البداية فقط
    _hideTimer = Timer(const Duration(seconds: 3), () {
      if (mounted && _areControlsVisible) {
        _hideControls();
      }
    });
  }

  void _showControls() {
    if (!_areControlsVisible) {
      setState(() => _areControlsVisible = true);
      _controlsController.forward();
    }
    // لا نعيد تشغيل التايمر - فقط نظهر الأدوات
  }

  void _hideControls() {
    if (_areControlsVisible) {
      setState(() => _areControlsVisible = false);
      _controlsController.reverse();
    }
  }

  void _toggleControls() {
    if (_areControlsVisible) {
      _hideControls();
    } else {
      _showControls();
    }
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

  void _toggleOrientation() {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    if (isLandscape) {
      // التبديل إلى الوضع الرأسي
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    } else {
      // التبديل إلى الوضع الأفقي
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

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
                    if (state.currentPage != _lastCurrentPage &&
                        _isPageViewReady) {
                      _scrollToPage(state.currentPage);
                    }

                    // إظهار الـ dialog عند الانتهاء (مع إظهار الأدوات)
                    if (state.status == PlaybackStatus.finished &&
                        !_hasShownDialog) {
                      // إظهار الأدوات فقط عند الانتهاء
                      _showControls();
                      Future.delayed(const Duration(milliseconds: 500), () {
                        if (context.mounted) {
                          // _showFinishDialog();
                          showFinishDialog(
                            context: context,
                            hasShownDialog: _hasShownDialog,
                            restartStory: _restartStory,
                          );
                        }
                      });
                    }
                  },
                  builder: (context, state) {
                    return GestureDetector(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        _toggleControls();
                      },
                      child: Stack(
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
                                // لا نعيد إظهار الأدوات عند تغيير الصفحة تلقائياً
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
                          AnimatedBuilder(
                            animation: _controlsAnimation,
                            builder: (context, child) {
                              return Transform.translate(
                                offset: Offset(
                                  0,
                                  -(1 - _controlsAnimation.value) * 100,
                                ),
                                // ✅ هنا الفرق
                                child: Opacity(
                                  opacity: _controlsAnimation.value,
                                  child: BottomControls(
                                    isLandscape: isLandscape,
                                    toggleOrientation: _toggleOrientation,
                                    showControls: _showControls,
                                  ),
                                ),
                              );
                            },
                          ),

                          // أدوات التحكم مع أنيميشن
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: AnimatedBuilder(
                              animation: _controlsAnimation,
                              builder: (context, child) {
                                return Transform.translate(
                                  offset: Offset(
                                    0,
                                    (1 - _controlsAnimation.value) * 100,
                                  ),
                                  child: Opacity(
                                    opacity: _controlsAnimation.value,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        // أزرار التحكم العلوية (الآن في الأسفل)
                                        const SizedBox(height: 10),
                                        // أدوات التحكم الرئيسية
                                        const EnhancedStoryControls(),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),

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
                      ),
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
}
