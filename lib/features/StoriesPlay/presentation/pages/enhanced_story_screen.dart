
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wise_child/features/StoriesPlay/data/models/response/story_play_dto.dart';
import 'package:wise_child/features/StoriesPlay/presentation/pages/StoriesPlay_page.dart';
import 'package:wise_child/features/StoriesPlay/presentation/widgets/story_controls.dart';

import 'package:wise_child/core/resources/color_manager.dart';
import 'dart:async';

import 'package:wise_child/features/StoriesPlay/presentation/widgets/story_screen.dart';

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

    _entranceAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _entranceController,
      curve: Curves.easeOutCubic,
    ));

    // تهيئة تحكم الأنيميشن للأدوات
    _controlsController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _controlsAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controlsController,
      curve: Curves.easeInOut,
    ));

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
    _hideTimer = Timer(const Duration(seconds: 5), () {
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
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
              final screenHeight = MediaQuery.of(context).size.height;
              final maxHeight = screenHeight * (isLandscape ? 0.8 : 0.6);

              return ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: maxHeight,
                  maxWidth: isLandscape ? 500 : double.infinity,
                ),
                child: SingleChildScrollView(
                  child: Container(
                    margin: EdgeInsets.all(isLandscape ? 10 : 20),
                    padding: EdgeInsets.all(isLandscape ? 20 : 30),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.green.shade400,
                          Colors.green.shade600,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(isLandscape ? 20 : 30),
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
                                padding: EdgeInsets.all(isLandscape ? 10 : 15),
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
                                  size: isLandscape ? 35 : 50,
                                ),
                              ),
                            );
                          },
                        ),

                        SizedBox(height: isLandscape ? 15 : 20),

                        // رسالة التهنئة
                        Text(
                          'أحسنت! 🎉',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isLandscape ? 22 : 28,
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

                        SizedBox(height: isLandscape ? 8 : 10),

                        Text(
                          'لقد انتهيت من القصة بنجاح!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isLandscape ? 14 : 16,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        SizedBox(height: isLandscape ? 20 : 30),

                        // أزرار الإجراءات
                        if (isLandscape)
                        // في الوضع الأفقي: أزرار جنباً إلى جنب
                          Row(
                            children: [
                              Expanded(
                                child: _buildDialogButton(
                                  icon: Icons.replay_rounded,
                                  label: 'إعادة تشغيل',
                                  isCompact: true,
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    _restartStory();
                                  },
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: _buildDialogButton(
                                  icon: Icons.home_rounded,
                                  label: 'العودة',
                                  isCompact: true,
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ),
                            ],
                          )
                        else
                        // في الوضع الرأسي: أزرار عمودية
                          Column(
                            children: [
                              // زر الإعادة
                              SizedBox(
                                width: double.infinity,
                                child: _buildDialogButton(
                                  icon: Icons.replay_rounded,
                                  label: 'إعادة تشغيل',
                                  isCompact: false,
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
                                  isCompact: false,
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                  },
                                ),
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
      ),
    );
  }

  Widget _buildDialogButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    bool isCompact = false,
  }) {
    return ElevatedButton(
      onPressed: () {
        HapticFeedback.lightImpact();
        onPressed();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.green.shade600,
        padding: EdgeInsets.symmetric(
          horizontal: isCompact ? 12 : 20,
          vertical: isCompact ? 10 : 15,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(isCompact ? 20 : 25),
        ),
        elevation: 5,
        shadowColor: Colors.black.withOpacity(0.3),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: isCompact ? 18 : 22),
          SizedBox(width: isCompact ? 6 : 10),
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: isCompact ? 14 : 16,
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

  void _toggleOrientation() {
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

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
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

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

                    // إظهار الـ dialog عند الانتهاء (مع إظهار الأدوات)
                    if (state.status == PlaybackStatus.finished && !_hasShownDialog) {
                      // إظهار الأدوات فقط عند الانتهاء
                      _showControls();
                      Future.delayed(const Duration(milliseconds: 500), () {
                        if (mounted) {
                          _showFinishDialog();
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
                                offset: Offset(0, -(1 - _controlsAnimation.value) * 100), // ✅ هنا الفرق
                                child: Opacity(
                                  opacity: _controlsAnimation.value,
                                  child:  _buildBottomControls(context, isLandscape),
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
                                  offset: Offset(0, (1 - _controlsAnimation.value) * 100),
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

  Widget _buildBottomControls(BuildContext context, bool isLandscape) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // زر تدوير الشاشة
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black.withOpacity(0.5),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: IconButton(
                icon: Icon(
                  isLandscape
                      ? Icons.fullscreen_exit: Icons.fullscreen,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: () {
                  HapticFeedback.lightImpact();
                  _toggleOrientation();
                  _showControls(); // إظهار الأدوات بعد التدوير
                },
              ),
            ),

            // زر العودة
            Container(
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
                  size: 20,
                ),
                onPressed: () {
                  HapticFeedback.lightImpact();
                  // إعادة تعيين الاتجاه الافتراضي عند الخروج
                  SystemChrome.setPreferredOrientations([
                    DeviceOrientation.portraitUp,
                    DeviceOrientation.portraitDown,
                  ]);
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}