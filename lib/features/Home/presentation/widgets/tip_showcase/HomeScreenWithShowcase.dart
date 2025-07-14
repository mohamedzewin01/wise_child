import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'package:wise_child/core/utils/cashed_data_shared_preferences.dart';
import 'package:wise_child/core/widgets/custom_app_bar_app.dart';
import 'package:wise_child/features/Home/presentation/bloc/get_home_cubit.dart';
import 'package:wise_child/features/Home/presentation/widgets/home_categories.dart';
import 'package:wise_child/features/Home/presentation/widgets/home_error_widget.dart';
import 'package:wise_child/features/Home/presentation/widgets/home_quick_actions.dart';
import 'package:wise_child/features/Home/presentation/widgets/home_stories_grid.dart';
import 'package:wise_child/features/Home/presentation/widgets/home_welcome_header.dart';

import '../../../../AllStoriesByUser/presentation/widgets/loading_shimmer.dart';

class HomeScreenWithShowcase extends StatefulWidget {
  const HomeScreenWithShowcase({super.key});

  @override
  State<HomeScreenWithShowcase> createState() => _HomeScreenWithShowcaseState();
}

class _HomeScreenWithShowcaseState extends State<HomeScreenWithShowcase>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // مفاتيح الشرح
  final GlobalKey _welcomeKey = GlobalKey();
  final GlobalKey _quickActionsKey = GlobalKey();
  final GlobalKey _topStoriesKey = GlobalKey();
  final GlobalKey _categoriesKey = GlobalKey();
  final GlobalKey _appBarKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _setupAnimations();

    // بدء الشرح بعد انتهاء البناء
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndStartShowcase();
    });
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  void _checkAndStartShowcase() {
    // فحص إذا كان المستخدم شاهد الشرح من قبل
    final hasSeenShowcase =
        CacheService.getData(key: CacheKeys.homeShowCaseSeen) ?? false;

    if (!hasSeenShowcase) {
      // بدء الشرح التفاعلي
      ShowCaseWidget.of(context).startShowCase([
        // _appBarKey,
        _welcomeKey,
        _quickActionsKey,
        _topStoriesKey,
        // _categoriesKey,
      ]);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.scaffoldBackground,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            HomeSliverAppBar(
              title: 'ابطالنا',
              subtitle: 'مرحباً بك في عالم القصص',
              actions: [
                SliverAppBarActionButton(
                  icon: Icons.notifications,
                  onPressed: () {
                    // Handle notifications action
                  },
                ),
              ],
            ),

            SliverToBoxAdapter(child: _buildMainContent()),

            _buildBottomPadding(),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return BlocBuilder<GetHomeCubit, GetHomeState>(
      builder: (context, state) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _buildStateContent(state),
        );
      },
    );
  }

  Widget _buildStateContent(GetHomeState state) {
    switch (state) {
      case HomeLoading():
        return const LoadingShimmer();
      case HomeFailure():
        return HomeErrorWidget(
          error: state.exception.toString(),
          onRetry: () => context.read<GetHomeCubit>().getHomeData(),
        );
      case HomeSuccess():
        return _buildHomeContent(state.data);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildHomeContent(homeData) {
    return Column(
      children: [
        // رأس الترحيب مع الشرح
        Showcase(
          key: _welcomeKey,
          title: 'مرحباً بك! 👋',
          description:
              'هذا هو قسم الترحيب الذي يظهر معلومات حسابك الشخصي ويرحب بك في التطبيق',
          titleTextStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          descTextStyle: const TextStyle(fontSize: 14, color: Colors.white70),
          tooltipBackgroundColor: Colors.blue,
          overlayColor: Colors.black.withOpacity(0.7),
          // shapeBorder: RoundedRectangleBorder(
          //   borderRadius: BorderRadius.circular(16),
          // ),
          child: const HomeWelcomeHeader(),
        ),
        const SizedBox(height: 20),

        // الإجراءات السريعة مع الشرح
        Showcase(
          key: _quickActionsKey,
          title: 'الإجراءات السريعة ⚡',
          description:
              'اضغط على هذه الأزرار للوصول السريع للميزات الأساسية مثل إضافة طفل أو عرض القصص',
          titleTextStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          descTextStyle: const TextStyle(fontSize: 14, color: Colors.white70),
          tooltipBackgroundColor: Colors.green,
          overlayColor: Colors.black.withOpacity(0.7),
          // shapeBorder: RoundedRectangleBorder(
          //   borderRadius: BorderRadius.circular(16),
          // ),
          child: const HomeQuickActions(),
        ),
        const SizedBox(height: 24),

        // القصص الأكثر مشاهدة مع الشرح
        Showcase(
          key: _topStoriesKey,
          title: 'القصص الأكثر مشاهدة 📚',
          description:
              'هنا تجد أشهر القصص التي يحبها الأطفال. يمكنك تصفحها أو عرض المزيد',
          titleTextStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          descTextStyle: const TextStyle(fontSize: 14, color: Colors.white70),
          tooltipBackgroundColor: Colors.orange,
          overlayColor: Colors.black.withOpacity(0.7),
          // shapeBorder: RoundedRectangleBorder(
          //   borderRadius: BorderRadius.circular(16),
          // ),
          child: HomeStoriesGrid(
            title: 'القصص الأكثر مشاهدة',
            stories: homeData?.data?.topViewedStories ?? [],
            type: StoriesType.topViewed,
          ),
        ),
        const SizedBox(height: 24),

        // الفئات مع الشرح
        Showcase(
          key: _categoriesKey,
          title: 'فئات القصص 🏷️',
          description:
              'تصفح القصص حسب الفئات المختلفة مثل التعليمية، المغامرات، والحكايات',
          titleTextStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          descTextStyle: const TextStyle(fontSize: 14, color: Colors.white70),
          tooltipBackgroundColor: Colors.purple,
          overlayColor: Colors.black.withOpacity(0.7),
          // shapeBorder: RoundedRectangleBorder(
          //   borderRadius: BorderRadius.circular(16),
          // ),
          child: HomeCategories(
            categories: homeData?.data?.storiesByCategory ?? [],
          ),
        ),
        const SizedBox(height: 24),

        // القصص القادمة قريباً
        if (homeData?.data?.topInactiveStories?.isNotEmpty == true)
          HomeStoriesGrid(
            title: 'قريباً',
            stories: homeData?.data?.topInactiveStories ?? [],
            type: StoriesType.topInactive,
          ),
      ],
    );
  }

  Widget _buildBottomPadding() {
    return const SliverToBoxAdapter(
      child: SizedBox(height: kBottomNavigationBarHeight + 30),
    );
  }
}
