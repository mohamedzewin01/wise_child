

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wise_child/assets_manager.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'package:wise_child/core/widgets/custom_app_bar_app.dart';
import 'package:wise_child/features/Home/presentation/widgets/loading_shimmer.dart';
import 'package:wise_child/l10n/app_localizations.dart';
import '../../../../core/di/di.dart';
import '../bloc/get_home_cubit.dart';
import '../widgets/home_welcome_header.dart';
import '../widgets/home_statistics_overview.dart';
import '../widgets/home_stories_grid.dart';
import '../widgets/home_gender_statistics.dart';
import '../widgets/home_age_groups.dart';
import '../widgets/home_categories.dart';
import '../widgets/home_quick_actions.dart';
import '../widgets/home_error_widget.dart';
import '../widgets/home_analytics_dashboard.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late GetHomeCubit viewModel;

  @override
  void initState() {
    viewModel = getIt.get<GetHomeCubit>();
    viewModel.getHomeData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: viewModel,
      child: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
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
                    /// Handle notifications action
                  },
                ),
              ],
            ),

            _buildMainContent(),
            _buildBottomPadding(),
          ],
        ),
      ),
    );
  }


  Widget _buildMainContent() {
    return SliverToBoxAdapter(
      child: BlocBuilder<GetHomeCubit, GetHomeState>(
        builder: (context, state) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _buildStateContent(state),
          );
        },
      ),
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
        // Welcome Header
        const HomeWelcomeHeader(),
        const SizedBox(height: 20),

        // Quick Actions
        const HomeQuickActions(),
        const SizedBox(height: 24),

        // Statistics Overview
        HomeStatisticsOverview(data: homeData?.data),
        const SizedBox(height: 24),

        // Analytics Dashboard
        HomeAnalyticsDashboard(data: homeData?.data),
        const SizedBox(height: 24),

        // Top Viewed Stories
        HomeStoriesGrid(
          title: 'القصص الأكثر مشاهدة',
          stories: homeData?.data?.topViewedStories ?? [],
          type: StoriesType.topViewed,
        ),
        const SizedBox(height: 24),

        // Gender Statistics
        HomeGenderStatistics(data: homeData?.data?.storiesByGender),
        const SizedBox(height: 24),

        // Age Groups
        HomeAgeGroups(ageGroups: homeData?.data?.storiesByAgeGroup ?? []),
        const SizedBox(height: 24),

        // Categories
        HomeCategories(categories: homeData?.data?.storiesByCategory ?? []),
        const SizedBox(height: 24),

        // Top Inactive Stories
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
      child: SizedBox(height: kBottomNavigationBarHeight + 20),
    );
  }
}
