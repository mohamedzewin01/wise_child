
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:skeletonizer/skeletonizer.dart';
// import 'package:wise_child/core/widgets/custom_app_bar.dart';
//
// import 'package:wise_child/features/Children/data/models/response/get_children_dto.dart';
// import 'package:wise_child/features/Children/presentation/widgets/child_card.dart';
// import 'package:wise_child/features/Children/presentation/widgets/skeletonizer_children.dart';
// import 'package:wise_child/features/NewChildren/presentation/pages/NewChildren_page.dart';
// import '../../../../core/di/di.dart';
// import '../bloc/Children_cubit.dart';
//
// class ChildrenPage extends StatefulWidget {
//   const ChildrenPage({super.key});
//
//   @override
//   State<ChildrenPage> createState() => _ChildrenPageState();
// }
//
// class _ChildrenPageState extends State<ChildrenPage> {
//   late ChildrenCubit viewModel;
//
//   @override
//   void initState() {
//     viewModel = getIt.get<ChildrenCubit>();
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider.value(
//       value: viewModel..getChildrenByUser(),
//       child: Scaffold(
//         backgroundColor: Colors.grey.shade50,
//         body: CustomScrollView(
//           slivers: [
//             SliverCustomAppBar(
//               iconActionOne: Icons.add,
//               onTapActionTow: () async {
//                 final result = await Navigator.push(
//                   context,
//                   CupertinoPageRoute(builder: (context) => NewChildrenPage()),
//                 );
//                 if (result == true && context.mounted) {
//                   context.read<ChildrenCubit>().getChildrenByUser();
//                 }
//               },
//             ),
//
//             // Children Counter Section
//             SliverToBoxAdapter(
//               child: BlocBuilder<ChildrenCubit, ChildrenState>(
//                 builder: (context, state) {
//                   if (state is ChildrenSuccess) {
//                     final childrenCount = state.getChildrenEntity.children?.length ?? 0;
//                     return _buildChildrenCounter(childrenCount);
//                   }
//                   if (state is ChildrenLoading) {
//                     return _buildCounterSkeleton();
//                   }
//                   return _buildChildrenCounter(0);
//                 },
//               ),
//             ),
//
//             // Children List
//             SliverToBoxAdapter(
//               child: BlocBuilder<ChildrenCubit, ChildrenState>(
//                 builder: (context, state) {
//                   if (state is ChildrenSuccess) {
//                     List<Children> children = state.getChildrenEntity.children ?? [];
//                     return children.isNotEmpty
//                         ? Padding(
//                       padding: const EdgeInsets.only(
//                         bottom: kBottomNavigationBarHeight,
//                         right: 16,
//                         left: 16,
//                       ),
//                       child: ListView.builder(
//                         shrinkWrap: true,
//                         physics: const NeverScrollableScrollPhysics(),
//                         padding: const EdgeInsets.only(
//                           top: 8.0,
//                           bottom: 8.0,
//                         ),
//                         itemCount: children.length,
//                         itemBuilder: (context, index) {
//                           return ChildCard(children: children[index]);
//                         },
//                       ),
//                     )
//                         : _buildEmptyState();
//                   }
//                   if (state is ChildrenFailure) {
//                     return _buildErrorState();
//                   }
//
//                   return SkeChildren();
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildChildrenCounter(int count) {
//     return Container(
//       margin: const EdgeInsets.all(16.0),
//       padding: const EdgeInsets.all(20.0),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [
//             Colors.purple.shade400,
//             Colors.purple.shade600,
//           ],
//         ),
//         borderRadius: BorderRadius.circular(20.0),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.purple.withOpacity(0.3),
//             offset: const Offset(0, 6),
//             blurRadius: 15,
//             spreadRadius: 0,
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(12.0),
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(0.2),
//               borderRadius: BorderRadius.circular(15.0),
//             ),
//             child: Icon(
//               Icons.child_care,
//               color: Colors.white,
//               size: 28,
//             ),
//           ),
//           const SizedBox(width: 16),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'إجمالي الأطفال',
//                   style: TextStyle(
//                     color: Colors.white.withOpacity(0.9),
//                     fontSize: 14,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Row(
//                   children: [
//                     Text(
//                       count.toString(),
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 32,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     Text(
//                       count == 1 ? 'طفل' : 'أطفال',
//                       style: TextStyle(
//                         color: Colors.white.withOpacity(0.9),
//                         fontSize: 16,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           if (count > 0)
//             Container(
//               padding: const EdgeInsets.symmetric(
//                 horizontal: 12,
//                 vertical: 6,
//               ),
//               decoration: BoxDecoration(
//                 color: Colors.white.withOpacity(0.2),
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Icon(
//                     Icons.trending_up,
//                     color: Colors.white,
//                     size: 16,
//                   ),
//                   const SizedBox(width: 4),
//                   Text(
//                     'نشط',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 12,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildCounterSkeleton() {
//     return Container(
//       margin: const EdgeInsets.all(16.0),
//       padding: const EdgeInsets.all(20.0),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20.0),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.08),
//             offset: const Offset(0, 4),
//             blurRadius: 12,
//             spreadRadius: 0,
//           ),
//         ],
//       ),
//       child: Skeletonizer(
//         effect: ShimmerEffect(
//           baseColor: Colors.grey.shade300,
//           highlightColor: Colors.grey.shade100,
//         ),
//         child: Row(
//           children: [
//             Container(
//               width: 52,
//               height: 52,
//               decoration: BoxDecoration(
//                 color: Colors.grey,
//                 borderRadius: BorderRadius.circular(15.0),
//               ),
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     height: 14,
//                     width: 120,
//                     decoration: BoxDecoration(
//                       color: Colors.grey,
//                       borderRadius: BorderRadius.circular(7),
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Container(
//                     height: 32,
//                     width: 80,
//                     decoration: BoxDecoration(
//                       color: Colors.grey,
//                       borderRadius: BorderRadius.circular(16),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Container(
//               height: 28,
//               width: 60,
//               decoration: BoxDecoration(
//                 color: Colors.grey,
//                 borderRadius: BorderRadius.circular(20),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildEmptyState() {
//     return Container(
//       margin: const EdgeInsets.all(16.0),
//       padding: const EdgeInsets.all(40.0),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20.0),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             offset: const Offset(0, 4),
//             blurRadius: 12,
//             spreadRadius: 0,
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(20.0),
//             decoration: BoxDecoration(
//               color: Colors.grey.shade100,
//               shape: BoxShape.circle,
//             ),
//             child: Icon(
//               Icons.child_care_outlined,
//               size: 48,
//               color: Colors.grey.shade400,
//             ),
//           ),
//           const SizedBox(height: 20),
//           Text(
//             'لا توجد أطفال مضافين',
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               color: Colors.grey.shade700,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             'ابدأ بإضافة طفلك الأول',
//             style: TextStyle(
//               fontSize: 14,
//               color: Colors.grey.shade500,
//             ),
//           ),
//           const SizedBox(height: 24),
//           ElevatedButton.icon(
//             onPressed: () async {
//               final result = await Navigator.push(
//                 context,
//                 CupertinoPageRoute(builder: (context) => NewChildrenPage()),
//               );
//               if (result == true && context.mounted) {
//                 context.read<ChildrenCubit>().getChildrenByUser();
//               }
//             },
//             icon: Icon(Icons.add),
//             label: Text('إضافة طفل'),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.purple.shade400,
//               foregroundColor: Colors.white,
//               padding: const EdgeInsets.symmetric(
//                 horizontal: 24,
//                 vertical: 12,
//               ),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildErrorState() {
//     return Container(
//       margin: const EdgeInsets.all(16.0),
//       padding: const EdgeInsets.all(40.0),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20.0),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             offset: const Offset(0, 4),
//             blurRadius: 12,
//             spreadRadius: 0,
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(20.0),
//             decoration: BoxDecoration(
//               color: Colors.red.shade50,
//               shape: BoxShape.circle,
//             ),
//             child: Icon(
//               Icons.error_outline,
//               size: 48,
//               color: Colors.red.shade400,
//             ),
//           ),
//           const SizedBox(height: 20),
//           Text(
//             'حدث خطأ في تحميل البيانات',
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               color: Colors.grey.shade700,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             'تأكد من اتصالك بالإنترنت وحاول مرة أخرى',
//             style: TextStyle(
//               fontSize: 14,
//               color: Colors.grey.shade500,
//
//             ),
//             textAlign: TextAlign.center,
//           ),
//           const SizedBox(height: 24),
//           ElevatedButton.icon(
//             onPressed: () {
//               context.read<ChildrenCubit>().getChildrenByUser();
//             },
//             icon: Icon(Icons.refresh),
//             label: Text('إعادة المحاولة'),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.red.shade400,
//               foregroundColor: Colors.white,
//               padding: const EdgeInsets.symmetric(
//                 horizontal: 24,
//                 vertical: 12,
//               ),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'package:wise_child/core/widgets/custom_app_bar.dart';
import 'package:wise_child/features/Children/data/models/response/get_children_dto.dart';
import 'package:wise_child/features/Children/presentation/widgets/enhanced_child_card.dart';
import 'package:wise_child/features/Children/presentation/widgets/skeletonizer_children.dart';
import 'package:wise_child/features/NewChildren/presentation/pages/NewChildren_page.dart';
import '../../../../core/di/di.dart';
import '../../../../core/widgets/custom_app_bar_app.dart';
import '../../../../core/widgets/no_children_page.dart';
import '../bloc/Children_cubit.dart';
import '../widgets/floating_action_button.dart';


class ChildrenPage extends StatefulWidget {
  const ChildrenPage({super.key});

  @override
  State<ChildrenPage> createState() => _ChildrenPageState();
}

class _ChildrenPageState extends State<ChildrenPage>
    with TickerProviderStateMixin {
  late ChildrenCubit viewModel;
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _listController;

  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    viewModel = getIt.get<ChildrenCubit>();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _listController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _startAnimations();
  }

  void _startAnimations() {
    _fadeController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      _slideController.forward();
    });
    Future.delayed(const Duration(milliseconds: 400), () {
      _listController.forward();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _listController.dispose();
    super.dispose();
  }

  Future<void> _navigateToAddChild() async {
    HapticFeedback.lightImpact();
    final result = await Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => const NewChildrenPage(),
      ),
    );
    if (result == true && mounted) {
      context.read<ChildrenCubit>().getChildrenByUser();
    }
  }

  Future<void> _onRefresh() async {
    HapticFeedback.mediumImpact();
    return viewModel.getChildrenByUser();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: viewModel..getChildrenByUser(),
      child: Scaffold(
        floatingActionButton: CustomfloatingActionButton(
          icon: Icons.add,

          onPressed: () {

            Future.delayed(const Duration(milliseconds: 1000), () {
              _navigateToAddChild();
            });

        },),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFFF8FAFF),
                Colors.white,
                const Color(0xFFFAFCFF),
                Colors.blue.shade50.withOpacity(0.3),
              ],
              stops: const [0.0, 0.3, 0.7, 1.0],
            ),
          ),
          child: BlocBuilder<ChildrenCubit, ChildrenState>(
            builder: (context, state) {
              // عرض صفحة عدم وجود أطفال
              if (state is ChildrenSuccess &&
                  (state.getChildrenEntity.children?.isEmpty ?? true)) {
                return NoChildrenPage(
                  onAddChildPressed: _navigateToAddChild,
                  onRefreshPressed: _onRefresh,
                );
              }
              if (state is ChildrenLoading) {
             return   ChildrenLoadingSkeleton();
              }

              return RefreshIndicator(
                onRefresh: _onRefresh,
                color: ColorManager.primaryColor,
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    // App Bar
                    // _buildSliverAppBar(),

                    SliverToBoxAdapter(
                      child: CustomAppBarApp(
                        subtitle: '',
                        title: 'الأطفال',


                      )
                    ),

                    // Header Section
                    _buildHeaderSection(state),

                    // Children List
                    _buildChildrenList(state),

                    // Bottom Spacing
                    const SliverToBoxAdapter(
                      child: SizedBox(height: kBottomNavigationBarHeight + 20),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }


  Widget _buildHeaderSection(ChildrenState state) {
    return SliverToBoxAdapter(
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [

                _buildStatsCard(state),

                const SizedBox(height: 20),

                // Quick Actions
                // _buildQuickActions(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatsCard(ChildrenState state) {
    int childrenCount = 0;
    if (state is ChildrenSuccess) {
      childrenCount = state.getChildrenEntity.children?.length ?? 0;
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            ColorManager.primaryColor,
            ColorManager.primaryColor,
            // Colors.blue.shade600,
            Colors.purple.shade200,
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: ColorManager.primaryColor.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.8),
            blurRadius: 10,
            offset: const Offset(0, -2),
            spreadRadius: -5,
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon Container
          TweenAnimationBuilder<double>(
            duration: const Duration(seconds: 2),
            tween: Tween(begin: 0.0, end: 1.0),
            builder: (context, value, child) {
              return Transform.rotate(
                angle: value * 0.1,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    Icons.family_restroom_rounded,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              );
            },
          ),

          const SizedBox(width: 20),

          // Stats Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'إجمالي الأطفال',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    TweenAnimationBuilder<int>(
                      duration: const Duration(milliseconds: 1500),
                      tween: IntTween(begin: 0, end: childrenCount),
                      builder: (context, value, child) {
                        return Text(
                          value.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 12),
                    Text(
                      childrenCount == 1 ? 'طفل' : 'أطفال',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Status Badge
          if (childrenCount > 0)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'نشط',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }





  Widget _buildChildrenList(ChildrenState state) {
    if (state is ChildrenLoading) {
      return _buildLoadingList();
    }

    if (state is ChildrenSuccess) {
      List<Children> children = state.getChildrenEntity.children ?? [];

      return SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        sliver: SliverAnimatedList(
          initialItemCount: children.length,
          itemBuilder: (context, index, animation) {
            return SlideTransition(
              position: animation.drive(
                Tween(begin: const Offset(1, 0), end: Offset.zero)
                    .chain(CurveTween(curve: Curves.easeOutCubic)),
              ),
              child: FadeTransition(
                opacity: animation,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 0),
                  child: EnhancedChildCard(
                    children: children[index],
                    index: index,
                  ),
                ),
              ),
            );
          },
        ),
      );
    }

    if (state is ChildrenFailure) {
      return _buildErrorState();
    }

    return _buildLoadingList();
  }

  Widget _buildLoadingList() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
              (context, index) => _buildSkeletonCard(),
          childCount: 4,
        ),
      ),
    );
  }

  Widget _buildSkeletonCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Skeletonizer(
        child: Row(
          children: [
            // Avatar skeleton
            Stack(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: Colors.grey[300],
                ),
                Positioned(
                  bottom: 2,
                  right: 2,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(width: 20),

            // Content skeleton
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 18,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(9),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 14,
                    width: 120,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(7),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Container(
                        height: 24,
                        width: 70,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        height: 20,
                        width: 40,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Actions skeleton
            Column(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline_rounded,
                size: 48,
                color: Colors.red.shade400,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'حدث خطأ في تحميل البيانات',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'تأكد من اتصالك بالإنترنت وحاول مرة أخرى',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _onRefresh,
              icon: Icon(Icons.refresh_rounded),
              label: Text('إعادة المحاولة'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade400,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}