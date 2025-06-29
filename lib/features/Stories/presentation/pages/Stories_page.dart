//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:wise_child/core/resources/color_manager.dart';
// import 'package:wise_child/features/Stories/presentation/bloc/ChildrenStoriesCubit/children_stories_cubit.dart';
// import 'package:wise_child/features/Stories/presentation/bloc/Stories_cubit.dart';
// import 'package:wise_child/features/layout/presentation/cubit/layout_cubit.dart';
// import '../../../../core/di/di.dart';
// import '../../../../core/widgets/custom_app_bar_app.dart';
// import '../widgets/side_by_side_stories_grid.dart';
//
// class StoriesPage extends StatefulWidget {
//   const StoriesPage({super.key});
//
//   @override
//   State<StoriesPage> createState() => _StoriesPageState();
// }
//
// class _StoriesPageState extends State<StoriesPage>
//     with TickerProviderStateMixin {
//   late StoriesCubit viewModel;
//   late ChildrenStoriesCubit childrenStoriesCubit;
//   late AnimationController _fadeController;
//   late AnimationController _slideController;
//
//
//   @override
//   void initState() {
//     super.initState();
//     viewModel = getIt.get<StoriesCubit>();
//     childrenStoriesCubit = getIt.get<ChildrenStoriesCubit>();
//
//     _fadeController = AnimationController(
//       duration: const Duration(milliseconds: 800),
//       vsync: this,
//     );
//
//     _slideController = AnimationController(
//       duration: const Duration(milliseconds: 600),
//       vsync: this,
//     );
//
//     _loadData();
//   }
//
//   @override
//   void dispose() {
//     _fadeController.dispose();
//     _slideController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _loadData() async {
//     _fadeController.forward();
//     await viewModel.getChildrenByUser();
//   }
//
//   Future<void> _onRefresh() async {
//     HapticFeedback.mediumImpact();
//     await viewModel.getChildrenByUser();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider.value(value: viewModel),
//         BlocProvider.value(value: childrenStoriesCubit),
//       ],
//       child: Scaffold(
//         backgroundColor: const Color(0xFFF8FAFF),
//         body: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//               colors: [
//                 const Color(0xFFF8FAFF),
//                 Colors.white,
//                 const Color(0xFFFAFCFF),
//               ],
//             ),
//           ),
//           child: Column(
//             children: [
//               CustomAppBarApp(
//                 title: 'مكتبة القصص',
//                 subtitle: 'اختر طفلك واستمتع بالقصص المثيرة' ,
//               ),
//               Expanded(
//                 child: RefreshIndicator(
//                   onRefresh: _onRefresh,
//                   color: ColorManager.primaryColor,
//                   child: Row(
//                     children: [
//                       _buildChildrenSidebar(),
//                       _buildDivider(),
//                       _buildStoriesSection(),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//
//   Widget _buildChildrenSidebar() {
//     return Container(
//       width: 80,
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [
//             Colors.white,
//             const Color(0xFFF8FAFF),
//           ],
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(2, 0),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           // عنوان القسم
//           Container(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(10),
//                   decoration: BoxDecoration(
//                     color: ColorManager.primaryColor.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Icon(
//                     Icons.family_restroom_rounded,
//                     color: ColorManager.primaryColor,
//                     size: 24,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   'الأطفال',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     color: ColorManager.primaryColor,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           // قائمة الأطفال
//           Expanded(
//             child: BlocBuilder<StoriesCubit, StoriesState>(
//               builder: (context, state) {
//                 if (state is StoriesSuccess) {
//                   var children = state.getChildrenEntity.children ?? [];
//
//                   if (children.isNotEmpty) {
//                     WidgetsBinding.instance.addPostFrameCallback((_) {
//                       context.read<ChildrenStoriesCubit>().setInitialChild(
//                           children.first.idChildren ?? 0);
//
//                     });
//                   }
//
//                   return BlocBuilder<ChildrenStoriesCubit, ChildrenStoriesState>(
//                     builder: (context, childrenStoriesState) {
//                       final selectedChildId = context
//                           .read<ChildrenStoriesCubit>()
//                           .getSelectedChildId();
//
//                       return ListView.builder(
//                         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                         itemCount: children.length,
//                         itemBuilder: (context, index) {
//                           final child = children[index];
//                           final isSelected = selectedChildId == child.idChildren;
//
//                           return Padding(
//                             padding: const EdgeInsets.only(bottom: 16),
//                             child: _buildChildCard(
//                               child: child,
//                               isSelected: isSelected,
//                               onTap: () async {
//                                 HapticFeedback.lightImpact();
//                                 _slideController.forward().then((_) {
//                                   _slideController.reset();
//                                 });
//
//                                 await context
//                                     .read<ChildrenStoriesCubit>()
//                                     .changeIdChildren(child.idChildren ?? 0);
//                               },
//                             ),
//                           );
//                         },
//                       );
//                     },
//                   );
//                 }
//
//                 return _buildChildrenLoading();
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildChildCard({
//     required dynamic child,
//     required bool isSelected,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 400),
//         curve: Curves.easeInOutCubic,
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           gradient: isSelected
//               ? LinearGradient(
//             colors: [
//               ColorManager.primaryColor.withOpacity(0.15),
//               ColorManager.primaryColor.withOpacity(0.05),
//             ],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           )
//               : null,
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(
//             color: isSelected
//                 ? ColorManager.primaryColor.withOpacity(0.3)
//                 : Colors.transparent,
//             width: 2,
//           ),
//           boxShadow: isSelected
//               ? [
//             BoxShadow(
//               color: ColorManager.primaryColor.withOpacity(0.2),
//               blurRadius: 15,
//               offset: const Offset(0, 5),
//             ),
//           ]
//               : [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.05),
//               blurRadius: 8,
//               offset: const Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Column(
//           children: [
//             // الصورة الرمزية
//             Hero(
//               tag: 'sidebar_child_${child.idChildren}',
//               child: Container(
//                 width: 60,
//                 height: 60,
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: isSelected
//                         ? [
//                       ColorManager.primaryColor,
//                       ColorManager.primaryColor.withOpacity(0.8),
//                     ]
//                         : [
//                       ColorManager.primaryColor.withOpacity(0.7),
//                       ColorManager.primaryColor.withOpacity(0.5),
//                     ],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ),
//                   shape: BoxShape.circle,
//                   boxShadow: [
//                     BoxShadow(
//                       color: ColorManager.primaryColor.withOpacity(0.3),
//                       blurRadius: isSelected ? 15 : 8,
//                       offset: const Offset(0, 4),
//                     ),
//                   ],
//                 ),
//                 child: Center(
//                   child: Text(
//                     (child.firstName ?? '').isNotEmpty
//                         ? child.firstName![0].toUpperCase()
//                         : '؟',
//                     style: TextStyle(
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//
//             const SizedBox(height: 12),
//
//             // اسم الطفل
//             Text(
//               child.firstName ?? '',
//               style: TextStyle(
//                 fontSize: 12,
//                 fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
//                 color: isSelected
//                     ? ColorManager.primaryColor
//                     : Colors.grey[700],
//               ),
//               textAlign: TextAlign.center,
//               maxLines: 2,
//               overflow: TextOverflow.ellipsis,
//             ),
//
//             // مؤشر التحديد
//             if (isSelected) ...[
//               const SizedBox(height: 8),
//               Container(
//                 width: 30,
//                 height: 3,
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [
//                       ColorManager.primaryColor,
//                       Colors.purple.shade300,
//                     ],
//                   ),
//                   borderRadius: BorderRadius.circular(2),
//                 ),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildChildrenLoading() {
//     return ListView.builder(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//       itemCount: 4,
//       itemBuilder: (context, index) => Padding(
//         padding: const EdgeInsets.only(bottom: 16),
//         child: Container(
//           padding: const EdgeInsets.all(12),
//           decoration: BoxDecoration(
//             color: Colors.grey[100],
//             borderRadius: BorderRadius.circular(16),
//           ),
//           child: Column(
//             children: [
//               Container(
//                 width: 60,
//                 height: 60,
//                 decoration: BoxDecoration(
//                   color: Colors.grey[300],
//                   shape: BoxShape.circle,
//                 ),
//               ),
//               const SizedBox(height: 12),
//               Container(
//                 width: 50,
//                 height: 12,
//                 decoration: BoxDecoration(
//                   color: Colors.grey[300],
//                   borderRadius: BorderRadius.circular(6),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildDivider() {
//     return Container(
//       width: 1,
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [
//             Colors.transparent,
//             Colors.grey.withOpacity(0.3),
//             Colors.transparent,
//           ],
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//         ),
//       ),
//     );
//   }
//
//   Widget _buildStoriesSection() {
//     return Expanded(
//       child: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [
//               Colors.white,
//               const Color(0xFFFAFCFF),
//             ],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//         ),
//         child: Column(
//           children: [
//             // عنوان قسم القصص
//             Container(
//               padding: const EdgeInsets.all(10),
//               child: Row(
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(10),
//                     decoration: BoxDecoration(
//                       color: ColorManager.primaryColor.withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Icon(
//                       Icons.auto_stories_rounded,
//                       color: ColorManager.primaryColor,
//                       size: 24,
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'القصص المتاحة',
//                           style: TextStyle(
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                             color: ColorManager.primaryColor,
//                           ),
//                         ),
//                         const SizedBox(height: 4),
//                         BlocBuilder<ChildrenStoriesCubit, ChildrenStoriesState>(
//                           builder: (context, state) {
//                             if (state is ChildrenStoriesSuccess) {
//                               final storiesCount = state.getChildrenEntity?.data?.length ?? 0;
//                               return Text(
//                                 '$storiesCount ${storiesCount == 1 ? 'قصة متاحة' : 'قصص متاحة'}',
//                                 style: TextStyle(
//                                   fontSize: 14,
//                                   color: Colors.grey[600],
//                                 ),
//                               );
//                             }
//                             return Text(
//                               'جاري التحميل...',
//                               style: TextStyle(
//                                 fontSize: 14,
//                                 color: Colors.grey[600],
//                               ),
//                             );
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//
//             Expanded(
//               child: AnimatedBuilder(
//                 animation: _slideController,
//                 builder: (context, child) {
//                   return const SideBySideStoriesGrid();
//
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'package:wise_child/core/resources/routes_manager.dart';
import 'package:wise_child/features/Stories/presentation/bloc/ChildrenStoriesCubit/children_stories_cubit.dart';
import 'package:wise_child/features/Stories/presentation/bloc/Stories_cubit.dart';
import 'package:wise_child/features/layout/presentation/cubit/layout_cubit.dart';
import '../../../../core/di/di.dart';
import '../../../../core/widgets/custom_app_bar_app.dart';
import '../widgets/side_by_side_stories_grid.dart';
import '../../../../core/widgets/no_children_page.dart'; // استيراد الصفحة الجديدة

class StoriesPage extends StatefulWidget {
  const StoriesPage({super.key});

  @override
  State<StoriesPage> createState() => _StoriesPageState();
}

class _StoriesPageState extends State<StoriesPage>
    with TickerProviderStateMixin {
  late StoriesCubit viewModel;
  late ChildrenStoriesCubit childrenStoriesCubit;
  late AnimationController _fadeController;
  late AnimationController _slideController;

  @override
  void initState() {
    super.initState();
    viewModel = getIt.get<StoriesCubit>();
    childrenStoriesCubit = getIt.get<ChildrenStoriesCubit>();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _loadData();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    _fadeController.forward();
    await viewModel.getChildrenByUser();
  }

  Future<void> _onRefresh() async {
    HapticFeedback.mediumImpact();
    await viewModel.getChildrenByUser();
  }

  void _navigateToAddChild() {
    Navigator.pushNamed(context, RoutesManager.newChildrenPage);
    print('Navigate to add child page');
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: viewModel),
        BlocProvider.value(value: childrenStoriesCubit),
      ],
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFF),
        body: BlocBuilder<StoriesCubit, StoriesState>(
          builder: (context, state) {
            // التحقق من حالة عدم وجود أطفال
            if (state is StoriesSuccess) {
              var children = state.getChildrenEntity.children ?? [];

              if (children.isEmpty) {

                return NoChildrenPage(
                  onAddChildPressed: _navigateToAddChild,
                  onRefreshPressed: _onRefresh,
                );
              }
            }

            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFFF8FAFF),
                    Colors.white,
                    const Color(0xFFFAFCFF),
                  ],
                ),
              ),
              child: Column(
                children: [
                  CustomAppBarApp(
                    title: 'مكتبة القصص',
                    subtitle: 'اختر طفلك واستمتع بالقصص المثيرة',
                  ),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: _onRefresh,
                      color: ColorManager.primaryColor,
                      child: Row(
                        children: [
                          _buildChildrenSidebar(),
                          _buildDivider(),
                          _buildStoriesSection(),
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
  }

  Widget _buildChildrenSidebar() {
    return Container(
      width: 80,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white,
            const Color(0xFFF8FAFF),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(2, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          // عنوان القسم
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: ColorManager.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.family_restroom_rounded,
                    color: ColorManager.primaryColor,
                    size: 24,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'الأطفال',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: ColorManager.primaryColor,
                  ),
                ),
              ],
            ),
          ),

          // قائمة الأطفال
          Expanded(
            child: BlocBuilder<StoriesCubit, StoriesState>(
              builder: (context, state) {
                if (state is StoriesSuccess) {
                  var children = state.getChildrenEntity.children ?? [];

                  if (children.isNotEmpty) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      context.read<ChildrenStoriesCubit>().setInitialChild(
                          children.first.idChildren ?? 0);
                    });
                  }

                  return BlocBuilder<ChildrenStoriesCubit, ChildrenStoriesState>(
                    builder: (context, childrenStoriesState) {
                      final selectedChildId = context
                          .read<ChildrenStoriesCubit>()
                          .getSelectedChildId();

                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        itemCount: children.length,
                        itemBuilder: (context, index) {
                          final child = children[index];
                          final isSelected = selectedChildId == child.idChildren;

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: _buildChildCard(
                              child: child,
                              isSelected: isSelected,
                              onTap: () async {
                                HapticFeedback.lightImpact();
                                _slideController.forward().then((_) {
                                  _slideController.reset();
                                });

                                await context
                                    .read<ChildrenStoriesCubit>()
                                    .changeIdChildren(child.idChildren ?? 0);
                              },
                            ),
                          );
                        },
                      );
                    },
                  );
                }

                return _buildChildrenLoading();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChildCard({
    required dynamic child,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
            colors: [
              ColorManager.primaryColor.withOpacity(0.15),
              ColorManager.primaryColor.withOpacity(0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
              : null,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? ColorManager.primaryColor.withOpacity(0.3)
                : Colors.transparent,
            width: 2,
          ),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: ColorManager.primaryColor.withOpacity(0.2),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ]
              : [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            // الصورة الرمزية
            Hero(
              tag: 'sidebar_child_${child.idChildren}',
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isSelected
                        ? [
                      ColorManager.primaryColor,
                      ColorManager.primaryColor.withOpacity(0.8),
                    ]
                        : [
                      ColorManager.primaryColor.withOpacity(0.7),
                      ColorManager.primaryColor.withOpacity(0.5),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: ColorManager.primaryColor.withOpacity(0.3),
                      blurRadius: isSelected ? 15 : 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    (child.firstName ?? '').isNotEmpty
                        ? child.firstName![0].toUpperCase()
                        : '؟',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // اسم الطفل
            Text(
              child.firstName ?? '',
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                color: isSelected
                    ? ColorManager.primaryColor
                    : Colors.grey[700],
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            // مؤشر التحديد
            if (isSelected) ...[
              const SizedBox(height: 8),
              Container(
                width: 30,
                height: 3,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      ColorManager.primaryColor,
                      Colors.purple.shade300,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildChildrenLoading() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      itemCount: 4,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                width: 50,
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            Colors.grey.withOpacity(0.3),
            Colors.transparent,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }

  Widget _buildStoriesSection() {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white,
              const Color(0xFFFAFCFF),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            // عنوان قسم القصص
            Container(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: ColorManager.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.auto_stories_rounded,
                      color: ColorManager.primaryColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'القصص المتاحة',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: ColorManager.primaryColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        BlocBuilder<ChildrenStoriesCubit, ChildrenStoriesState>(
                          builder: (context, state) {
                            if (state is ChildrenStoriesSuccess) {
                              final storiesCount = state.getChildrenEntity?.data?.length ?? 0;
                              return Text(
                                '$storiesCount ${storiesCount == 1 ? 'قصة متاحة' : 'قصص متاحة'}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              );
                            }
                            return Text(
                              'جاري التحميل...',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: AnimatedBuilder(
                animation: _slideController,
                builder: (context, child) {
                  return const SideBySideStoriesGrid();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}