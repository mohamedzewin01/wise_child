// //
// // import 'package:flutter/material.dart';
// // import 'package:flutter/services.dart';
// // import 'package:flutter_bloc/flutter_bloc.dart';
// // import 'package:wise_child/core/resources/color_manager.dart';
// // import 'package:wise_child/features/Stories/presentation/bloc/ChildrenStoriesCubit/children_stories_cubit.dart';
// // import 'package:wise_child/features/Stories/presentation/bloc/Stories_cubit.dart';
// // import 'package:wise_child/features/layout/presentation/cubit/layout_cubit.dart';
// // import '../../../../core/di/di.dart';
// // import '../../../../core/widgets/custom_app_bar_app.dart';
// // import '../widgets/side_by_side_stories_grid.dart';
// //
// // class StoriesPage extends StatefulWidget {
// //   const StoriesPage({super.key});
// //
// //   @override
// //   State<StoriesPage> createState() => _StoriesPageState();
// // }
// //
// // class _StoriesPageState extends State<StoriesPage>
// //     with TickerProviderStateMixin {
// //   late StoriesCubit viewModel;
// //   late ChildrenStoriesCubit childrenStoriesCubit;
// //   late AnimationController _fadeController;
// //   late AnimationController _slideController;
// //
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     viewModel = getIt.get<StoriesCubit>();
// //     childrenStoriesCubit = getIt.get<ChildrenStoriesCubit>();
// //
// //     _fadeController = AnimationController(
// //       duration: const Duration(milliseconds: 800),
// //       vsync: this,
// //     );
// //
// //     _slideController = AnimationController(
// //       duration: const Duration(milliseconds: 600),
// //       vsync: this,
// //     );
// //
// //     _loadData();
// //   }
// //
// //   @override
// //   void dispose() {
// //     _fadeController.dispose();
// //     _slideController.dispose();
// //     super.dispose();
// //   }
// //
// //   Future<void> _loadData() async {
// //     _fadeController.forward();
// //     await viewModel.getChildrenByUser();
// //   }
// //
// //   Future<void> _onRefresh() async {
// //     HapticFeedback.mediumImpact();
// //     await viewModel.getChildrenByUser();
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return MultiBlocProvider(
// //       providers: [
// //         BlocProvider.value(value: viewModel),
// //         BlocProvider.value(value: childrenStoriesCubit),
// //       ],
// //       child: Scaffold(
// //         backgroundColor: const Color(0xFFF8FAFF),
// //         body: Container(
// //           decoration: BoxDecoration(
// //             gradient: LinearGradient(
// //               begin: Alignment.topLeft,
// //               end: Alignment.bottomRight,
// //               colors: [
// //                 const Color(0xFFF8FAFF),
// //                 Colors.white,
// //                 const Color(0xFFFAFCFF),
// //               ],
// //             ),
// //           ),
// //           child: Column(
// //             children: [
// //               CustomAppBarApp(
// //                 title: 'مكتبة القصص',
// //                 subtitle: 'اختر طفلك واستمتع بالقصص المثيرة' ,
// //               ),
// //               Expanded(
// //                 child: RefreshIndicator(
// //                   onRefresh: _onRefresh,
// //                   color: ColorManager.primaryColor,
// //                   child: Row(
// //                     children: [
// //                       _buildChildrenSidebar(),
// //                       _buildDivider(),
// //                       _buildStoriesSection(),
// //                     ],
// //                   ),
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //
// //   Widget _buildChildrenSidebar() {
// //     return Container(
// //       width: 80,
// //       decoration: BoxDecoration(
// //         gradient: LinearGradient(
// //           colors: [
// //             Colors.white,
// //             const Color(0xFFF8FAFF),
// //           ],
// //           begin: Alignment.topCenter,
// //           end: Alignment.bottomCenter,
// //         ),
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.black.withOpacity(0.05),
// //             blurRadius: 10,
// //             offset: const Offset(2, 0),
// //           ),
// //         ],
// //       ),
// //       child: Column(
// //         children: [
// //           // عنوان القسم
// //           Container(
// //             padding: const EdgeInsets.all(16),
// //             child: Column(
// //               children: [
// //                 Container(
// //                   padding: const EdgeInsets.all(10),
// //                   decoration: BoxDecoration(
// //                     color: ColorManager.primaryColor.withOpacity(0.1),
// //                     borderRadius: BorderRadius.circular(12),
// //                   ),
// //                   child: Icon(
// //                     Icons.family_restroom_rounded,
// //                     color: ColorManager.primaryColor,
// //                     size: 24,
// //                   ),
// //                 ),
// //                 const SizedBox(height: 8),
// //                 Text(
// //                   'الأطفال',
// //                   style: TextStyle(
// //                     fontSize: 16,
// //                     fontWeight: FontWeight.bold,
// //                     color: ColorManager.primaryColor,
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //
// //           // قائمة الأطفال
// //           Expanded(
// //             child: BlocBuilder<StoriesCubit, StoriesState>(
// //               builder: (context, state) {
// //                 if (state is StoriesSuccess) {
// //                   var children = state.getChildrenEntity.children ?? [];
// //
// //                   if (children.isNotEmpty) {
// //                     WidgetsBinding.instance.addPostFrameCallback((_) {
// //                       context.read<ChildrenStoriesCubit>().setInitialChild(
// //                           children.first.idChildren ?? 0);
// //
// //                     });
// //                   }
// //
// //                   return BlocBuilder<ChildrenStoriesCubit, ChildrenStoriesState>(
// //                     builder: (context, childrenStoriesState) {
// //                       final selectedChildId = context
// //                           .read<ChildrenStoriesCubit>()
// //                           .getSelectedChildId();
// //
// //                       return ListView.builder(
// //                         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
// //                         itemCount: children.length,
// //                         itemBuilder: (context, index) {
// //                           final child = children[index];
// //                           final isSelected = selectedChildId == child.idChildren;
// //
// //                           return Padding(
// //                             padding: const EdgeInsets.only(bottom: 16),
// //                             child: _buildChildCard(
// //                               child: child,
// //                               isSelected: isSelected,
// //                               onTap: () async {
// //                                 HapticFeedback.lightImpact();
// //                                 _slideController.forward().then((_) {
// //                                   _slideController.reset();
// //                                 });
// //
// //                                 await context
// //                                     .read<ChildrenStoriesCubit>()
// //                                     .changeIdChildren(child.idChildren ?? 0);
// //                               },
// //                             ),
// //                           );
// //                         },
// //                       );
// //                     },
// //                   );
// //                 }
// //
// //                 return _buildChildrenLoading();
// //               },
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _buildChildCard({
// //     required dynamic child,
// //     required bool isSelected,
// //     required VoidCallback onTap,
// //   }) {
// //     return GestureDetector(
// //       onTap: onTap,
// //       child: AnimatedContainer(
// //         duration: const Duration(milliseconds: 400),
// //         curve: Curves.easeInOutCubic,
// //         padding: const EdgeInsets.all(12),
// //         decoration: BoxDecoration(
// //           gradient: isSelected
// //               ? LinearGradient(
// //             colors: [
// //               ColorManager.primaryColor.withOpacity(0.15),
// //               ColorManager.primaryColor.withOpacity(0.05),
// //             ],
// //             begin: Alignment.topLeft,
// //             end: Alignment.bottomRight,
// //           )
// //               : null,
// //           borderRadius: BorderRadius.circular(16),
// //           border: Border.all(
// //             color: isSelected
// //                 ? ColorManager.primaryColor.withOpacity(0.3)
// //                 : Colors.transparent,
// //             width: 2,
// //           ),
// //           boxShadow: isSelected
// //               ? [
// //             BoxShadow(
// //               color: ColorManager.primaryColor.withOpacity(0.2),
// //               blurRadius: 15,
// //               offset: const Offset(0, 5),
// //             ),
// //           ]
// //               : [
// //             BoxShadow(
// //               color: Colors.black.withOpacity(0.05),
// //               blurRadius: 8,
// //               offset: const Offset(0, 2),
// //             ),
// //           ],
// //         ),
// //         child: Column(
// //           children: [
// //             // الصورة الرمزية
// //             Hero(
// //               tag: 'sidebar_child_${child.idChildren}',
// //               child: Container(
// //                 width: 60,
// //                 height: 60,
// //                 decoration: BoxDecoration(
// //                   gradient: LinearGradient(
// //                     colors: isSelected
// //                         ? [
// //                       ColorManager.primaryColor,
// //                       ColorManager.primaryColor.withOpacity(0.8),
// //                     ]
// //                         : [
// //                       ColorManager.primaryColor.withOpacity(0.7),
// //                       ColorManager.primaryColor.withOpacity(0.5),
// //                     ],
// //                     begin: Alignment.topLeft,
// //                     end: Alignment.bottomRight,
// //                   ),
// //                   shape: BoxShape.circle,
// //                   boxShadow: [
// //                     BoxShadow(
// //                       color: ColorManager.primaryColor.withOpacity(0.3),
// //                       blurRadius: isSelected ? 15 : 8,
// //                       offset: const Offset(0, 4),
// //                     ),
// //                   ],
// //                 ),
// //                 child: Center(
// //                   child: Text(
// //                     (child.firstName ?? '').isNotEmpty
// //                         ? child.firstName![0].toUpperCase()
// //                         : '؟',
// //                     style: TextStyle(
// //                       fontSize: 24,
// //                       fontWeight: FontWeight.bold,
// //                       color: Colors.white,
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //             ),
// //
// //             const SizedBox(height: 12),
// //
// //             // اسم الطفل
// //             Text(
// //               child.firstName ?? '',
// //               style: TextStyle(
// //                 fontSize: 12,
// //                 fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
// //                 color: isSelected
// //                     ? ColorManager.primaryColor
// //                     : Colors.grey[700],
// //               ),
// //               textAlign: TextAlign.center,
// //               maxLines: 2,
// //               overflow: TextOverflow.ellipsis,
// //             ),
// //
// //             // مؤشر التحديد
// //             if (isSelected) ...[
// //               const SizedBox(height: 8),
// //               Container(
// //                 width: 30,
// //                 height: 3,
// //                 decoration: BoxDecoration(
// //                   gradient: LinearGradient(
// //                     colors: [
// //                       ColorManager.primaryColor,
// //                       Colors.purple.shade300,
// //                     ],
// //                   ),
// //                   borderRadius: BorderRadius.circular(2),
// //                 ),
// //               ),
// //             ],
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildChildrenLoading() {
// //     return ListView.builder(
// //       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
// //       itemCount: 4,
// //       itemBuilder: (context, index) => Padding(
// //         padding: const EdgeInsets.only(bottom: 16),
// //         child: Container(
// //           padding: const EdgeInsets.all(12),
// //           decoration: BoxDecoration(
// //             color: Colors.grey[100],
// //             borderRadius: BorderRadius.circular(16),
// //           ),
// //           child: Column(
// //             children: [
// //               Container(
// //                 width: 60,
// //                 height: 60,
// //                 decoration: BoxDecoration(
// //                   color: Colors.grey[300],
// //                   shape: BoxShape.circle,
// //                 ),
// //               ),
// //               const SizedBox(height: 12),
// //               Container(
// //                 width: 50,
// //                 height: 12,
// //                 decoration: BoxDecoration(
// //                   color: Colors.grey[300],
// //                   borderRadius: BorderRadius.circular(6),
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildDivider() {
// //     return Container(
// //       width: 1,
// //       decoration: BoxDecoration(
// //         gradient: LinearGradient(
// //           colors: [
// //             Colors.transparent,
// //             Colors.grey.withOpacity(0.3),
// //             Colors.transparent,
// //           ],
// //           begin: Alignment.topCenter,
// //           end: Alignment.bottomCenter,
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildStoriesSection() {
// //     return Expanded(
// //       child: Container(
// //         decoration: BoxDecoration(
// //           gradient: LinearGradient(
// //             colors: [
// //               Colors.white,
// //               const Color(0xFFFAFCFF),
// //             ],
// //             begin: Alignment.topCenter,
// //             end: Alignment.bottomCenter,
// //           ),
// //         ),
// //         child: Column(
// //           children: [
// //             // عنوان قسم القصص
// //             Container(
// //               padding: const EdgeInsets.all(10),
// //               child: Row(
// //                 children: [
// //                   Container(
// //                     padding: const EdgeInsets.all(10),
// //                     decoration: BoxDecoration(
// //                       color: ColorManager.primaryColor.withOpacity(0.1),
// //                       borderRadius: BorderRadius.circular(12),
// //                     ),
// //                     child: Icon(
// //                       Icons.auto_stories_rounded,
// //                       color: ColorManager.primaryColor,
// //                       size: 24,
// //                     ),
// //                   ),
// //                   const SizedBox(width: 12),
// //                   Expanded(
// //                     child: Column(
// //                       crossAxisAlignment: CrossAxisAlignment.start,
// //                       children: [
// //                         Text(
// //                           'القصص المتاحة',
// //                           style: TextStyle(
// //                             fontSize: 20,
// //                             fontWeight: FontWeight.bold,
// //                             color: ColorManager.primaryColor,
// //                           ),
// //                         ),
// //                         const SizedBox(height: 4),
// //                         BlocBuilder<ChildrenStoriesCubit, ChildrenStoriesState>(
// //                           builder: (context, state) {
// //                             if (state is ChildrenStoriesSuccess) {
// //                               final storiesCount = state.getChildrenEntity?.data?.length ?? 0;
// //                               return Text(
// //                                 '$storiesCount ${storiesCount == 1 ? 'قصة متاحة' : 'قصص متاحة'}',
// //                                 style: TextStyle(
// //                                   fontSize: 14,
// //                                   color: Colors.grey[600],
// //                                 ),
// //                               );
// //                             }
// //                             return Text(
// //                               'جاري التحميل...',
// //                               style: TextStyle(
// //                                 fontSize: 14,
// //                                 color: Colors.grey[600],
// //                               ),
// //                             );
// //                           },
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //
// //
// //             Expanded(
// //               child: AnimatedBuilder(
// //                 animation: _slideController,
// //                 builder: (context, child) {
// //                   return const SideBySideStoriesGrid();
// //
// //                 },
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:wise_child/core/resources/color_manager.dart';
// import 'package:wise_child/core/resources/routes_manager.dart';
// import 'package:wise_child/features/Stories/presentation/bloc/ChildrenStoriesCubit/children_stories_cubit.dart';
// import 'package:wise_child/features/Stories/presentation/bloc/Stories_cubit.dart';
// import 'package:wise_child/features/layout/presentation/cubit/layout_cubit.dart';
// import '../../../../core/di/di.dart';
// import '../../../../core/widgets/custom_app_bar_app.dart';
// import '../widgets/side_by_side_stories_grid.dart';
// import '../../../../core/widgets/no_children_page.dart'; // استيراد الصفحة الجديدة
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
//   void _navigateToAddChild() {
//     Navigator.pushNamed(context, RoutesManager.newChildrenPage);
//     print('Navigate to add child page');
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
//         body: BlocBuilder<StoriesCubit, StoriesState>(
//           builder: (context, state) {
//             // التحقق من حالة عدم وجود أطفال
//             if (state is StoriesSuccess) {
//               var children = state.getChildrenEntity.children ?? [];
//
//               if (children.isEmpty) {
//
//                 return NoChildrenPage(
//                   onAddChildPressed: _navigateToAddChild,
//                   onRefreshPressed: _onRefresh,
//                 );
//               }
//             }
//
//             return Container(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                   colors: [
//                     const Color(0xFFF8FAFF),
//                     Colors.white,
//                     const Color(0xFFFAFCFF),
//                   ],
//                 ),
//               ),
//               child: Column(
//                 children: [
//                   CustomAppBarApp(
//                     title: 'مكتبة القصص',
//                     subtitle: 'اختر طفلك واستمتع بالقصص المثيرة',
//                   ),
//                   Expanded(
//                     child: RefreshIndicator(
//                       onRefresh: _onRefresh,
//                       color: ColorManager.primaryColor,
//                       child: Row(
//                         children: [
//                           _buildChildrenSidebar(),
//                           _buildDivider(),
//                           _buildStoriesSection(),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
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
//             Expanded(
//               child: AnimatedBuilder(
//                 animation: _slideController,
//                 builder: (context, child) {
//                   return const SideBySideStoriesGrid();
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
import '../../../../core/widgets/no_children_page.dart';

// إضافة الاستيرادات الجديدة للتبديل
import '../widgets/story_layout_type.dart';

import '../widgets/stories_grid_view.dart';
import '../widgets/stories_loading_grid.dart';
import '../widgets/stories_empty_state.dart';
import '../widgets/stories_error_state.dart';
import 'package:wise_child/features/Stories/data/models/response/children_stories_model_dto.dart';

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
  late AnimationController _layoutSwitchController;

  // متغير التخطيط الحالي
  StoryLayoutType _currentLayout = StoryLayoutType.grid;

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

    // إضافة controller للتبديل بين التخطيطات
    _layoutSwitchController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _loadData();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _layoutSwitchController.dispose();
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

  // دالة تغيير التخطيط
  void _onLayoutChanged(StoryLayoutType newLayout) {
    if (_currentLayout != newLayout) {
      _layoutSwitchController.forward().then((_) {
        setState(() {
          _currentLayout = newLayout;
        });
        _layoutSwitchController.reverse();
      });
    }
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
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: CustomAppBarApp(
                      title: 'مكتبة القصص',
                      subtitle: 'اختر طفلك واستمتع بالقصص المثيرة',
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: RefreshIndicator(
                      onRefresh: _onRefresh,
                      color: ColorManager.primaryColor,
                      child: Column(
                        children: [
                          // Expanded(child: _buildChildrenSidebar()),
                          _buildChildrenSection(),

                          // فاصل
                          // _buildHorizontalDivider(),

                          // قسم القصص في الأسفل
                          // Expanded(
                          //   child: _buildStoriesSection(),
                          // ),
                          // // _buildDivider(),
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
  Widget _buildChildrenSection() {
    return Container(
      height: 80, // ارتفاع ثابت لقسم الأطفال
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
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // عنوان قسم الأطفال
          // Container(
          //   padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          //   child: Row(
          //     children: [
          //       Container(
          //         padding: const EdgeInsets.all(8),
          //         decoration: BoxDecoration(
          //           color: ColorManager.primaryColor.withOpacity(0.1),
          //           borderRadius: BorderRadius.circular(10),
          //         ),
          //         child: Icon(
          //           Icons.family_restroom_rounded,
          //           color: ColorManager.primaryColor,
          //           size: 20,
          //         ),
          //       ),
          //       // const SizedBox(width: 12),
          //       // Text(
          //       //   'اختر طفلك',
          //       //   style: TextStyle(
          //       //     fontSize: 18,
          //       //     fontWeight: FontWeight.bold,
          //       //     color: ColorManager.primaryColor,
          //       //   ),
          //       // ),
          //
          //     ],
          //   ),
          // ),
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
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        scrollDirection: Axis.horizontal,
                        itemCount: children.length,
                        itemBuilder: (context, index) {
                          final child = children[index];
                          final isSelected = selectedChildId == child.idChildren;

                          return Padding(
                            padding: const EdgeInsets.only(left: 16),
                            child: _buildHorizontalChildCard(
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

                return _buildChildrenHorizontalLoading();
              },
            ),
          ),
          // قائمة الأطفال الأفقية

        ],
      ),
    );
  }

  // بطاقة الطفل الأفقية
  Widget _buildHorizontalChildCard({
    required dynamic child,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
        // width: 60,
        padding: const EdgeInsets.all(8),
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // الصورة الرمزية
            Hero(
              tag: 'horizontal_child_${child.idChildren}',
              child: Container(
                width: 70,
                // height: 50,
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
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),

            // اسم الطفل
            Text(
              child.firstName ?? '',
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                color: isSelected
                    ? ColorManager.primaryColor
                    : Colors.grey[700],
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            // مؤشر التحديد
            if (isSelected) ...[
              const SizedBox(height: 4),
              Container(
                width: 20,
                height: 2,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      ColorManager.primaryColor,
                      Colors.purple.shade300,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // تحميل الأطفال الأفقي
  Widget _buildChildrenHorizontalLoading() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      scrollDirection: Axis.horizontal,
      itemCount: 4,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.only(left: 16),
        child: Container(
          width: 70,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: 40,
                height: 10,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // الفاصل الأفقي
  Widget _buildHorizontalDivider() {
    return Container(
      height: 1,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            Colors.grey.withOpacity(0.3),
            Colors.transparent,
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
    );
  }


  Widget _buildChildrenSidebar() {
    return Container(
      // width: 80,
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
      child: Row(
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
                        scrollDirection: Axis.horizontal,
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

  // القسم المحدث للقصص مع نظام التبديل
  Widget _buildStoriesSection() {
    return Container(
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
          // Container(
          //   padding: const EdgeInsets.all(10),
          //   child: Row(
          //     children: [
          //       Container(
          //         padding: const EdgeInsets.all(10),
          //         decoration: BoxDecoration(
          //           color: ColorManager.primaryColor.withOpacity(0.1),
          //           borderRadius: BorderRadius.circular(12),
          //         ),
          //         child: Icon(
          //           Icons.auto_stories_rounded,
          //           color: ColorManager.primaryColor,
          //           size: 24,
          //         ),
          //       ),
          //       const SizedBox(width: 12),
          //       Column(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           Text(
          //             'القصص المتاحة',
          //             style: TextStyle(
          //               fontSize: 20,
          //               fontWeight: FontWeight.bold,
          //               color: ColorManager.primaryColor,
          //             ),
          //           ),
          //           const SizedBox(height: 4),
          //           BlocBuilder<ChildrenStoriesCubit, ChildrenStoriesState>(
          //             builder: (context, state) {
          //               if (state is ChildrenStoriesSuccess) {
          //                 final storiesCount = state.getChildrenEntity?.data?.length ?? 0;
          //                 return Text(
          //                   '$storiesCount ${storiesCount == 1 ? 'قصة متاحة' : 'قصص متاحة'}',
          //                   style: TextStyle(
          //                     fontSize: 14,
          //                     color: Colors.grey[600],
          //                   ),
          //                 );
          //               }
          //               return Text(
          //                 'جاري التحميل...',
          //                 style: TextStyle(
          //                   fontSize: 14,
          //                   color: Colors.grey[600],
          //                 ),
          //               );
          //             },
          //           ),
          //         ],
          //       ),
          //     ],
          //   ),
          // ),

          // إضافة مبدل التخطيط هنا
          StoryLayoutSwitcher(
            currentLayout: _currentLayout,
            onLayoutChanged: _onLayoutChanged,
          ),

          // محتوى القصص مع الرسوم المتحركة
          AnimatedBuilder(
            animation: _layoutSwitchController,
            builder: (context, child) {
              return Transform.scale(
                scale: 1.0 - (_layoutSwitchController.value * 0.05),
                child: Opacity(
                  opacity: 1.0 - (_layoutSwitchController.value * 0.3),
                  child: _buildCurrentLayoutView(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // عرض التخطيط الحالي
  Widget _buildCurrentLayoutView() {
    return BlocBuilder<ChildrenStoriesCubit, ChildrenStoriesState>(
      builder: (context, state) {
        if (state is ChildrenStoriesLoading) {
          return const StoriesLoadingGrid();
        }

        if (state is ChildrenStoriesSuccess) {
          final stories = state.getChildrenEntity?.data ?? [];

          if (stories.isEmpty) {
            return StoriesEmptyState(
              controller: _fadeController,
              refreshController: _slideController,
            );
          }

          return _buildLayoutView(stories);
        }

        if (state is ChildrenStoriesFailure) {
          return StoriesErrorState(controller: _fadeController);
        }

        return const StoriesLoadingGrid();
      },
    );
  }

  Widget _buildLayoutView(List<StoriesModeData> stories) {
    switch (_currentLayout) {
      case StoryLayoutType.grid:
      // استخدام التخطيط الأصلي
        return const SideBySideStoriesGrid();

      case StoryLayoutType.list:
        return _buildListView(stories);

      case StoryLayoutType.carousel:
        return _buildCarouselView(stories);
    }
  }

  // تنفيذ مبسط للقائمة
  Widget _buildListView(List<StoriesModeData> stories) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: stories.length,
      itemBuilder: (context, index) {
        final story = stories[index];

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          height: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // صورة القصة
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      colors: [
                        Colors.blue.shade200,
                        Colors.purple.shade200,
                      ],
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.auto_stories_rounded,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // معلومات القصة
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        story.storyTitle ?? 'قصة بدون عنوان',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 4),

                      if (story.storyDescription != null)
                        Text(
                          story.storyDescription!,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),

                // زر التشغيل
                IconButton(
                  onPressed: () {
                    // تشغيل القصة
                  },
                  icon: Icon(
                    Icons.play_circle_fill_rounded,
                    color: Colors.blue.shade400,
                    size: 32,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // تنفيذ مبسط للشريط
  Widget _buildCarouselView(List<StoriesModeData> stories) {
    return PageView.builder(
      controller: PageController(viewportFraction: 0.85),
      itemCount: stories.length,
      itemBuilder: (context, index) {
        final story = stories[index];

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              colors: [
                Colors.blue.shade300,
                Colors.purple.shade300,
                Colors.pink.shade200,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 20,
                offset: const Offset(0, 10),
                spreadRadius: 2,
              ),
            ],
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // تدرج علوي
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),

              // المحتوى
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      story.storyTitle ?? 'قصة بدون عنوان',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            blurRadius: 10.0,
                            color: Colors.black,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 16),

                    // زر التشغيل
                    Container(
                      width: double.infinity,
                      height: 40,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withOpacity(0.9),
                            Colors.white.withOpacity(0.7),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: () {
                            // تشغيل القصة
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.play_arrow_rounded,
                                color: Colors.blue.shade600,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'تشغيل القصة',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}