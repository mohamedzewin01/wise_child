// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:wise_child/core/api/api_constants.dart';
// import 'package:wise_child/core/utils/cashed_data_shared_preferences.dart';
// import 'package:wise_child/core/widgets/custom_app_bar.dart';
// import 'package:wise_child/l10n/app_localizations.dart';
//
// import '../../../../core/di/di.dart';
// import '../bloc/Home_cubit.dart';
//
// class HomePage extends StatefulWidget {
//   const HomePage({super.key});
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   late HomeCubit viewModel;
//
//   @override
//   void initState() {
//     viewModel = getIt.get<HomeCubit>();
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider.value(value: viewModel, child: HomeScreen());
//   }
// }
//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   @override
//   Widget build(BuildContext context) {
//     final textTheme = Theme.of(context).textTheme;
//
//     return Scaffold(
//       body: CustomScrollView(
//         slivers: [
//           SliverCustomAppBar(),
//           SliverToBoxAdapter(child: _buildHeader(textTheme)),
//           SliverToBoxAdapter(child: const SizedBox(height: 24)),
//           SliverToBoxAdapter(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16.0),
//               child: Text('Progress Overview', style: textTheme.titleMedium),
//             ),
//           ),
//           SliverToBoxAdapter(child: const SizedBox(height: 12)),
//           SliverToBoxAdapter(child: _buildProgressOverview(textTheme)),
//           SliverToBoxAdapter(child: const SizedBox(height: 24)),
//           SliverToBoxAdapter(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16.0),
//               child: Text(
//                 AppLocalizations.of(context)!.myChildren,
//                 style: textTheme.titleMedium,
//               ),
//             ),
//           ),
//           SliverToBoxAdapter(child: const SizedBox(height: 12)),
//           SliverToBoxAdapter(child: _buildMyChildren()),
//           SliverToBoxAdapter(child: const SizedBox(height: 30)),
//           SliverToBoxAdapter(child: _buildUploadCustomStoryButton(textTheme)),
//           SliverToBoxAdapter(
//             child: const SizedBox(height: kBottomNavigationBarHeight),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildHeader(TextTheme textTheme) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const SizedBox(height: 16),
//           Row(
//             children: [
//               CircleAvatar(
//                 radius: 40,
//                 backgroundImage: NetworkImage(
//                   CacheService.getData(key: CacheKeys.userPhoto),
//                 ),
//                 // Use your asset
//                 backgroundColor: Colors.grey[200],
//               ),
//               const SizedBox(width: 16),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Hi, ${CacheService.getData(key: CacheKeys.userFirstName)} ${CacheService.getData(key: CacheKeys.userLastName)}!',
//                     style: textTheme.titleLarge,
//                   ),
//                   Text(
//                     'Welcome back',
//                     style: textTheme.bodyMedium?.copyWith(fontSize: 16),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildProgressOverview(TextTheme textTheme) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16.0),
//       child: Row(
//         children: [
//           Expanded(child: _buildProgressCard(textTheme, 'Stories Read', '15')),
//           const SizedBox(width: 16),
//           Expanded(child: _buildProgressCard(textTheme, 'Days Active', '22')),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildProgressCard(TextTheme textTheme, String title, String value) {
//     return Card(
//       elevation: 1,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
//       color: Colors.grey[50],
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
//         child: Column(
//           children: [
//             Text(
//               title,
//               style: textTheme.bodyMedium?.copyWith(color: Colors.black54),
//             ),
//             const SizedBox(height: 8),
//             Text(value, style: textTheme.headlineSmall?.copyWith(fontSize: 28)),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildMyChildren() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16.0),
//       child: Row(
//         children: [
//           _buildChildAvatar(),
//           const SizedBox(width: 10),
//           _buildChildAvatar(),
//           // Add more children or an "add child" button
//         ],
//       ),
//     );
//   }
//
//   Widget _buildChildAvatar() {
//     return Container(
//       padding: const EdgeInsets.all(2), // For border effect if needed
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         color: Colors.white, // Background for the border
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.2),
//             spreadRadius: 1,
//             blurRadius: 3,
//           ),
//         ],
//       ),
//       child: CircleAvatar(
//         radius: 25,
//         backgroundImage: NetworkImage(
//           CacheService.getData(key: CacheKeys.userPhoto),
//         ), // Use your asset
//         backgroundColor: Colors.grey[200],
//       ),
//     );
//   }
//
//   Widget _buildUploadCustomStoryButton(TextTheme textTheme) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16.0),
//       child: Center(
//         child: TextButton(
//           onPressed: () {
//             /* TODO: Upload action */
//           },
//           child: Text(
//             'Upload Custom Story',
//             style: textTheme.bodyLarge?.copyWith(
//               color: Theme.of(context).colorScheme.primary,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

///
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wise_child/core/api/api_constants.dart';
import 'package:wise_child/core/utils/cashed_data_shared_preferences.dart';
import 'package:wise_child/core/widgets/custom_app_bar.dart';
import 'package:wise_child/l10n/app_localizations.dart';

import '../../../../core/di/di.dart';
import '../bloc/Home_cubit.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomeCubit viewModel;

  @override
  void initState() {
    viewModel = getIt.get<HomeCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(value: viewModel, child: HomeScreen());
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
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
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
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: CustomScrollView(
          slivers: [
            SliverCustomAppBar(),
            SliverToBoxAdapter(child: _buildWelcomeHeader(textTheme, colorScheme)),
            SliverToBoxAdapter(child: const SizedBox(height: 24)),
            SliverToBoxAdapter(child: _buildQuickActions(colorScheme)),
            SliverToBoxAdapter(child: const SizedBox(height: 24)),
            SliverToBoxAdapter(child: _buildProgressSection(textTheme, colorScheme)),
            SliverToBoxAdapter(child: const SizedBox(height: 24)),
            SliverToBoxAdapter(child: _buildMyChildrenSection(textTheme, colorScheme)),
            SliverToBoxAdapter(child: const SizedBox(height: 24)),
            SliverToBoxAdapter(child: _buildFeaturedStories(textTheme, colorScheme)),
            SliverToBoxAdapter(child: const SizedBox(height: 24)),
            SliverToBoxAdapter(child: _buildDailyTip(textTheme, colorScheme)),
            SliverToBoxAdapter(
              child: const SizedBox(height: kBottomNavigationBarHeight + 20),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeHeader(TextTheme textTheme, ColorScheme colorScheme) {
    final firstName = CacheService.getData(key: CacheKeys.userFirstName) ?? 'عزيزي الوالد';
    final userPhoto = CacheService.getData(key: CacheKeys.userPhoto);

    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primary.withOpacity(0.1),
            colorScheme.secondary.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: colorScheme.primary.withOpacity(0.3),
                width: 3,
              ),
            ),
            child: CircleAvatar(
              radius: 35,
              backgroundImage: userPhoto != null ? NetworkImage(userPhoto) : null,
              backgroundColor: colorScheme.primary.withOpacity(0.1),
              child: userPhoto == null
                  ? Icon(Icons.person, size: 35, color: colorScheme.primary)
                  : null,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'مرحباً، $firstName! 👋',
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'دعنا نبدأ رحلة تعلم ممتعة اليوم',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '✨ نشاط اليوم',
                    style: textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'الإجراءات السريعة',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildQuickActionCard(
                  icon: Icons.auto_stories,
                  title: 'ابدأ قصة',
                  subtitle: 'قصة جديدة',
                  color: Colors.blue,
                  onTap: () {
                    // Navigate to stories
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickActionCard(
                  icon: Icons.upload_file,
                  title: 'ارفع قصة',
                  subtitle: 'قصة مخصصة',
                  color: Colors.green,
                  onTap: () {
                    // Upload custom story
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickActionCard(
                  icon: Icons.assessment,
                  title: 'التقييم',
                  subtitle: 'تقدم الطفل',
                  color: Colors.orange,
                  onTap: () {
                    // View progress
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressSection(TextTheme textTheme, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'إحصائيات التقدم',
                style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {
                  // View detailed progress
                },
                child: Text('عرض التفاصيل'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildProgressCard(
                  textTheme,
                  colorScheme,
                  'القصص المكتملة',
                  '15',
                  Icons.menu_book,
                  Colors.blue,
                  '+3 هذا الأسبوع',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildProgressCard(
                  textTheme,
                  colorScheme,
                  'أيام النشاط',
                  '22',
                  Icons.calendar_today,
                  Colors.green,
                  'متتالية',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildProgressCard(
                  textTheme,
                  colorScheme,
                  'المهارات المكتسبة',
                  '8',
                  Icons.star,
                  Colors.amber,
                  'مهارة جديدة',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildProgressCard(
                  textTheme,
                  colorScheme,
                  'وقت القراءة',
                  '45د',
                  Icons.access_time,
                  Colors.purple,
                  'اليوم',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard(
      TextTheme textTheme,
      ColorScheme colorScheme,
      String title,
      String value,
      IconData icon,
      Color color,
      String subtitle,
      ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: color.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const Spacer(),
              Text(
                value,
                style: textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: textTheme.bodySmall?.copyWith(
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMyChildrenSection(TextTheme textTheme, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.myChildren,
                style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: () {
                  // Add new child
                },
                icon: Icon(Icons.add_circle, color: colorScheme.primary),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 120,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildChildCard('أحمد', '7 سنوات', 'assets/images/child1.png', true),
                const SizedBox(width: 12),
                _buildChildCard('فاطمة', '5 سنوات', 'assets/images/child2.png', false),
                const SizedBox(width: 12),
                _buildAddChildCard(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChildCard(String name, String age, String imagePath, bool isActive) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isActive ? Theme.of(context).colorScheme.primary.withOpacity(0.1) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isActive
              ? Theme.of(context).colorScheme.primary
              : Colors.grey.withOpacity(0.2),
          width: isActive ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundImage: CacheService.getData(key: CacheKeys.userPhoto) != null
                    ? NetworkImage(CacheService.getData(key: CacheKeys.userPhoto))
                    : null,
                backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                child: CacheService.getData(key: CacheKeys.userPhoto) == null
                    ? Icon(Icons.child_care, color: Theme.of(context).colorScheme.primary)
                    : null,
              ),
              if (isActive)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            age,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAddChildCard() {
    return Container(
      width: 100,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.add,
            size: 30,
            color: Colors.grey[600],
          ),
          const SizedBox(height: 8),
          Text(
            'إضافة طفل',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedStories(TextTheme textTheme, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'القصص المميزة',
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 160,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildStoryCard('الأسد الشجاع', 'قصة عن الشجاعة', Colors.orange),
                const SizedBox(width: 12),
                _buildStoryCard('النملة المجتهدة', 'قصة عن العمل الجاد', Colors.green),
                const SizedBox(width: 12),
                _buildStoryCard('الصديق الوفي', 'قصة عن الصداقة', Colors.blue),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoryCard(String title, String description, Color color) {
    return Container(
      width: 140,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 80,
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: const Center(
              child: Icon(
                Icons.menu_book,
                color: Colors.white,
                size: 40,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyTip(TextTheme textTheme, ColorScheme colorScheme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.tertiary.withOpacity(0.1),
            colorScheme.secondary.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.tertiary,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.lightbulb,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'نصيحة اليوم 💡',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'اقرأ مع طفلك لمدة 15 دقيقة يومياً لتحسين مهاراته اللغوية',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}