import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'package:wise_child/core/widgets/custom_app_bar_app.dart';
import 'package:wise_child/features/Home/presentation/bloc/get_home_cubit.dart';
import 'package:wise_child/features/Home/presentation/pages/Home_page.dart';
import 'package:wise_child/features/Home/presentation/widgets/tip_showcase/EnhancedHomeWelcomeHeader.dart';

import '../../../../../core/di/di.dart';
import '../home_error_widget.dart';
import '../loading_shimmer.dart';

class UpdatedHomePage extends StatefulWidget {
  const UpdatedHomePage({super.key});

  @override
  State<UpdatedHomePage> createState() => _UpdatedHomePageState();
}

class _UpdatedHomePageState extends State<UpdatedHomePage> {
  late GetHomeCubit viewModel;

// مفاتيح الشرح
  final GlobalKey _appBarKey = GlobalKey();
  final GlobalKey _welcomeKey = GlobalKey();
  final GlobalKey _quickActionsKey = GlobalKey();
  final GlobalKey _storiesKey = GlobalKey();
  final GlobalKey _categoriesKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    viewModel = getIt.get<GetHomeCubit>();
    viewModel.getHomeData();

// بدء الشرح بعد بناء الواجهة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startShowcaseIfNeeded();
    });
  }

  void _startShowcaseIfNeeded() {
    final preferences = ShowcaseManager.getShowcasePreferences();
    if (preferences.autoStart) {
      ShowcaseManager.startShowcase(
        context,
        [
          _appBarKey,
          _welcomeKey,
          _quickActionsKey,
          _storiesKey,
          _categoriesKey
        ],
        'home',
        onComplete: () {
          ShowcaseManager.markShowcaseAsSeen('home');
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ShowCaseWidget(
      onStart: (index, key) {
// تسجيل بداية كل خطوة
        print('بدأت الخطوة $index');
      },
      onComplete: (index, key) {
// تسجيل انتهاء كل خطوة
        print('انتهت الخطوة $index');
      },
      onFinish: () {
// عند انتهاء الشرح الكامل
        ShowcaseManager.markShowcaseAsSeen('home');
        _showCompletionDialog();
      },
      blurValue: 1,
      builder: (context) =>
          Scaffold(
            backgroundColor: ColorManager.scaffoldBackground,
            body: BlocProvider.value(
              value: viewModel,
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
// شريط التطبيق مع الشرح
                  ShowcaseManager.buildCustomShowcase(
                    key: _appBarKey,
                    title: 'شريط التطبيق',
                    description: 'من هنا يمكنك الوصول للإشعارات ومعلومات التطبيق',
                    emoji: '📱',
                    features: [
                      'عرض الإشعارات الجديدة',
                      'الوصول لإعدادات التطبيق',
                      'معلومات الحساب',
                    ],
                    tip: 'اضغط على أيقونة الجرس لمشاهدة الإشعارات',
                    backgroundColor: ColorManager.primaryColor,
                    child: HomeSliverAppBar(
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
                  ),

                  SliverToBoxAdapter(
                    child: BlocBuilder<GetHomeCubit, GetHomeState>(
                      builder: (context, state) {
                        return AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: _buildStateContent(state),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
// زر المساعدة
            floatingActionButton: Stack(
              children: [
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: FloatingActionButton(
                    onPressed: _showHelpMenu,
                    backgroundColor: ColorManager.primaryColor,
                    child: const Icon(Icons.help_outline, color: Colors.white),
                  ),
                ),
// زر الإعدادات
                Positioned(
                  bottom: 80,
                  right: 16,
                  child: FloatingActionButton.small(
                    onPressed: () =>
                        ShowcaseManager.showShowcaseSettings(context),
                    backgroundColor: Colors.orange,
                    child: const Icon(
                        Icons.settings, color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
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
// رأس الترحيب مع الشرح
        EnhancedHomeWelcomeHeader(showcaseKey: _welcomeKey),
        const SizedBox(height: 20),

// الإجراءات السريعة مع الشرح
       HomeQuickActions(showcaseKey: _quickActionsKey),
        const SizedBox(height: 24),

// القصص الأكثر مشاهدة مع الشرح
        EnhancedHomeStoriesGrid(
          title: 'القصص الأكثر مشاهدة',
          stories: homeData?.data?.topViewedStories ?? [],
          type: StoriesType.topViewed,
          showcaseKey: _storiesKey,
        ),
        const SizedBox(height: 24),

// الفئات مع الشرح
        EnhancedHomeCategories(
          categories: homeData?.data?.storiesByCategory ?? [],
          showcaseKey: _categoriesKey,
        ),
        const SizedBox(height: 24),

// القصص القادمة قريباً
        if (homeData?.data?.topInactiveStories?.isNotEmpty == true)
          EnhancedHomeStoriesGrid(
            title: 'قريباً',
            stories: homeData?.data?.topInactiveStories ?? [],
            type: StoriesType.topInactive,
          ),

// مساحة إضافية في الأسفل
        const SizedBox(height: kBottomNavigationBarHeight + 20),
      ],
    );
  }

  void _showHelpMenu() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) =>
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
// Handle
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

// Header
                Row(
                  children: [
                    Icon(Icons.help, color: ColorManager.primaryColor),
                    const SizedBox(width: 12),
                    Text(
                      'المساعدة والدعم',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

// Options
                _buildHelpOption(
                  icon: Icons.play_circle,
                  title: 'إعادة الشرح التفاعلي',
                  subtitle: 'مشاهدة الشرح مرة أخرى',
                  onTap: () {
                    Navigator.pop(context);
                    _restartShowcase();
                  },
                ),

                _buildHelpOption(
                  icon: Icons.settings,
                  title: 'إعدادات الشرح',
                  subtitle: 'تخصيص تجربة الشرح',
                  onTap: () {
                    Navigator.pop(context);
                    ShowcaseManager.showShowcaseSettings(context);
                  },
                ),

                _buildHelpOption(
                  icon: Icons.video_library,
                  title: 'دليل المستخدم',
                  subtitle: 'شاهد فيديوهات تعليمية',
                  onTap: () {
                    Navigator.pop(context);
                    _showUserGuide();
                  },
                ),

                _buildHelpOption(
                  icon: Icons.support_agent,
                  title: 'تواصل معنا',
                  subtitle: 'احصل على مساعدة مباشرة',
                  onTap: () {
                    Navigator.pop(context);
                    _contactSupport();
                  },
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
    );
  }

  Widget _buildHelpOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: ColorManager.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: ColorManager.primaryColor),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  void _restartShowcase() {
    ShowCaseWidget.of(context).startShowCase([
      _appBarKey,
      _welcomeKey,
      _quickActionsKey,
      _storiesKey,
      _categoriesKey,
    ]);
  }

  void _showUserGuide() {
// Navigate to user guide videos or documentation
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('سيتم إضافة دليل المستخدم قريباً'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _contactSupport() {
// Open support chat or contact form
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('جاري فتح نافذة الدعم...'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
          AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
// Success Icon
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 48,
                  ),
                ),
                const SizedBox(height: 16),

// Title
                Text(
                  'رائع! 🎉',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: ColorManager.primaryColor,
                  ),
                ),
                const SizedBox(height: 8),

// Message
                Text(
                  'لقد أنهيت الشرح التفاعلي بنجاح!\nيمكنك الآن استكشاف التطبيق بحرية.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 20),

// Showcase count
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.star, color: Colors.blue, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'هذه هي المرة رقم ${ShowcaseManager.getShowcaseCount() +
                            1} لمشاهدة الشرح',
                        style: TextStyle(
                          color: Colors.blue[700],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  ShowcaseManager.showShowcaseSettings(context);
                },
                child: Text('الإعدادات'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorManager.primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text('ابدأ الاستكشاف'),
              ),
            ],
          ),
    );
  }
}