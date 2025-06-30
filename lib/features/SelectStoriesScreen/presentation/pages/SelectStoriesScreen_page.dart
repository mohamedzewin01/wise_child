// // import 'package:flutter/material.dart';
// // import 'package:flutter_bloc/flutter_bloc.dart';
// // import 'package:wise_child/features/Children/data/models/response/get_children_dto.dart';
// // import 'package:wise_child/features/SelectStoriesScreen/data/models/response/get_categories_stories_dto.dart';
// // import 'package:wise_child/features/SelectStoriesScreen/data/models/response/stories_by_category_dto.dart';
// //
// // import '../../../../core/di/di.dart';
// // import '../bloc/SelectStoriesScreen_cubit.dart';
// // import '../bloc/stories_category_cubit.dart';
// //
// // class SelectStoriesScreenPage extends StatefulWidget {
// //   const SelectStoriesScreenPage({super.key, required this.child});
// //   final Children child;
// //
// //   @override
// //   State<SelectStoriesScreenPage> createState() => _SelectStoriesScreenPageState();
// // }
// //
// // class _SelectStoriesScreenPageState extends State<SelectStoriesScreenPage> {
// //   late SelectStoriesScreenCubit categoriesViewModel;
// //   late StoriesCategoryCubit storiesViewModel;
// //   int? selectedCategoryId;
// //   String selectedCategoryName = '';
// //
// //   @override
// //   void initState() {
// //     categoriesViewModel = getIt.get<SelectStoriesScreenCubit>();
// //     storiesViewModel = getIt.get<StoriesCategoryCubit>();
// //     categoriesViewModel.getCategoriesStories();
// //     super.initState();
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return MultiBlocProvider(
// //       providers: [
// //         BlocProvider.value(value: categoriesViewModel),
// //         BlocProvider.value(value: storiesViewModel),
// //       ],
// //       child: Scaffold(
// //         backgroundColor: const Color(0xFFF8F9FA),
// //         appBar: _buildAppBar(),
// //         body: Column(
// //           children: [
// //             _buildChildInfoCard(),
// //             _buildCategoriesSection(),
// //             if (selectedCategoryId != null) _buildStoriesSection(),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //
// //   PreferredSizeWidget _buildAppBar() {
// //     return AppBar(
// //       elevation: 0,
// //       backgroundColor: const Color(0xFF6B73FF),
// //       foregroundColor: Colors.white,
// //       title: const Text(
// //         'اختيار القصة',
// //         style: TextStyle(
// //           fontWeight: FontWeight.bold,
// //           fontSize: 20,
// //         ),
// //       ),
// //       centerTitle: true,
// //       shape: const RoundedRectangleBorder(
// //         borderRadius: BorderRadius.vertical(
// //           bottom: Radius.circular(20),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildChildInfoCard() {
// //     return Container(
// //       margin: const EdgeInsets.all(16),
// //       padding: const EdgeInsets.all(16),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(16),
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.grey.withOpacity(0.1),
// //             spreadRadius: 2,
// //             blurRadius: 8,
// //             offset: const Offset(0, 2),
// //           ),
// //         ],
// //       ),
// //       child: Row(
// //         children: [
// //           Container(
// //             width: 60,
// //             height: 60,
// //             decoration: BoxDecoration(
// //               color: const Color(0xFF6B73FF).withOpacity(0.1),
// //               borderRadius: BorderRadius.circular(30),
// //             ),
// //             child: const Icon(
// //               Icons.child_care,
// //               color: Color(0xFF6B73FF),
// //               size: 30,
// //             ),
// //           ),
// //           const SizedBox(width: 16),
// //           Expanded(
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Text(
// //                   widget.child.lastName ?? 'اسم الطفل',
// //                   style: const TextStyle(
// //                     fontSize: 18,
// //                     fontWeight: FontWeight.bold,
// //                     color: Color(0xFF2D3748),
// //                   ),
// //                 ),
// //                 const SizedBox(height: 4),
// //                 Text(
// //                   'العمر: ${widget.child.dateOfBirth ?? 'غير محدد'} سنة',
// //                   style: TextStyle(
// //                     fontSize: 14,
// //                     color: Colors.grey[600],
// //                   ),
// //                 ),
// //                 Text(
// //                   'الجنس: ${widget.child.gender ?? 'غير محدد'}',
// //                   style: TextStyle(
// //                     fontSize: 14,
// //                     color: Colors.grey[600],
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _buildCategoriesSection() {
// //     return Expanded(
// //       flex: selectedCategoryId == null ? 1 : 0,
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Padding(
// //             padding: const EdgeInsets.symmetric(horizontal: 16),
// //             child: Text(
// //               'اختر فئة القصة',
// //               style: TextStyle(
// //                 fontSize: 18,
// //                 fontWeight: FontWeight.bold,
// //                 color: Colors.grey[800],
// //               ),
// //             ),
// //           ),
// //           const SizedBox(height: 12),
// //           Expanded(
// //             child: BlocBuilder<SelectStoriesScreenCubit, SelectStoriesScreenState>(
// //               builder: (context, state) {
// //                 if (state is SelectStoriesScreenLoading) {
// //                   return const Center(
// //                     child: CircularProgressIndicator(
// //                       color: Color(0xFF6B73FF),
// //                     ),
// //                   );
// //                 }
// //
// //                 if (state is SelectStoriesScreenSuccess) {
// //                   final categories = state.getCategoriesStoriesEntity?.categories ?? [];
// //
// //                   if (categories.isEmpty) {
// //                     return const Center(
// //                       child: Text(
// //                         'لا توجد فئات متاحة',
// //                         style: TextStyle(
// //                           fontSize: 16,
// //                           color: Colors.grey,
// //                         ),
// //                       ),
// //                     );
// //                   }
// //
// //                   return ListView.builder(
// //                     padding: const EdgeInsets.symmetric(horizontal: 16),
// //                     itemCount: categories.length,
// //                     itemBuilder: (context, index) {
// //                       final category = categories[index];
// //                       return _buildCategoryCard(category);
// //                     },
// //                   );
// //                 }
// //
// //                 if (state is SelectStoriesScreenFailure) {
// //                   return Center(
// //                     child: Column(
// //                       mainAxisAlignment: MainAxisAlignment.center,
// //                       children: [
// //                         const Icon(
// //                           Icons.error_outline,
// //                           size: 64,
// //                           color: Colors.red,
// //                         ),
// //                         const SizedBox(height: 16),
// //                         const Text(
// //                           'حدث خطأ في تحميل الفئات',
// //                           style: TextStyle(
// //                             fontSize: 16,
// //                             color: Colors.red,
// //                           ),
// //                         ),
// //                         const SizedBox(height: 16),
// //                         ElevatedButton(
// //                           onPressed: () => categoriesViewModel.getCategoriesStories(),
// //                           style: ElevatedButton.styleFrom(
// //                             backgroundColor: const Color(0xFF6B73FF),
// //                           ),
// //                           child: const Text(
// //                             'إعادة المحاولة',
// //                             style: TextStyle(color: Colors.white),
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   );
// //                 }
// //
// //                 return const SizedBox.shrink();
// //               },
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _buildCategoryCard(Categories category) {
// //     final isSelected = selectedCategoryId == category.categoryId;
// //
// //     return Container(
// //       margin: const EdgeInsets.only(bottom: 12),
// //       child: Material(
// //         color: Colors.transparent,
// //         child: InkWell(
// //           onTap: () {
// //             setState(() {
// //               selectedCategoryId = category.categoryId;
// //               selectedCategoryName = category.categoryName ?? '';
// //             });
// //
// //             storiesViewModel.getCategoriesStories(
// //               categoryId: category.categoryId,
// //               idChildren: widget.child.idChildren,
// //               page: 1,
// //             );
// //           },
// //           borderRadius: BorderRadius.circular(16),
// //           child: Container(
// //             padding: const EdgeInsets.all(16),
// //             decoration: BoxDecoration(
// //               color: isSelected ? const Color(0xFF6B73FF).withOpacity(0.1) : Colors.white,
// //               borderRadius: BorderRadius.circular(16),
// //               border: Border.all(
// //                 color: isSelected ? const Color(0xFF6B73FF) : Colors.grey.withOpacity(0.2),
// //                 width: isSelected ? 2 : 1,
// //               ),
// //               boxShadow: [
// //                 BoxShadow(
// //                   color: Colors.grey.withOpacity(0.1),
// //                   spreadRadius: 1,
// //                   blurRadius: 4,
// //                   offset: const Offset(0, 2),
// //                 ),
// //               ],
// //             ),
// //             child: Row(
// //               children: [
// //                 Container(
// //                   width: 50,
// //                   height: 50,
// //                   decoration: BoxDecoration(
// //                     color: isSelected ? const Color(0xFF6B73FF) : const Color(0xFF6B73FF).withOpacity(0.1),
// //                     borderRadius: BorderRadius.circular(25),
// //                   ),
// //                   child: Icon(
// //                     Icons.menu_book,
// //                     color: isSelected ? Colors.white : const Color(0xFF6B73FF),
// //                     size: 24,
// //                   ),
// //                 ),
// //                 const SizedBox(width: 16),
// //                 Expanded(
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       Text(
// //                         category.categoryName ?? 'فئة غير معروفة',
// //                         style: TextStyle(
// //                           fontSize: 16,
// //                           fontWeight: FontWeight.bold,
// //                           color: isSelected ? const Color(0xFF6B73FF) : const Color(0xFF2D3748),
// //                         ),
// //                       ),
// //                       if (category.categoryDescription != null) ...[
// //                         const SizedBox(height: 4),
// //                         Text(
// //                           category.categoryDescription!,
// //                           style: TextStyle(
// //                             fontSize: 14,
// //                             color: Colors.grey[600],
// //                           ),
// //                           maxLines: 2,
// //                           overflow: TextOverflow.ellipsis,
// //                         ),
// //                       ],
// //                     ],
// //                   ),
// //                 ),
// //                 if (isSelected)
// //                   const Icon(
// //                     Icons.check_circle,
// //                     color: Color(0xFF6B73FF),
// //                     size: 24,
// //                   ),
// //               ],
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildStoriesSection() {
// //     return Expanded(
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Padding(
// //             padding: const EdgeInsets.all(16),
// //             child: Row(
// //               children: [
// //                 IconButton(
// //                   onPressed: () {
// //                     setState(() {
// //                       selectedCategoryId = null;
// //                       selectedCategoryName = '';
// //                     });
// //                   },
// //                   icon: const Icon(Icons.arrow_back),
// //                   color: const Color(0xFF6B73FF),
// //                 ),
// //                 Expanded(
// //                   child: Text(
// //                     'قصص $selectedCategoryName',
// //                     style: const TextStyle(
// //                       fontSize: 18,
// //                       fontWeight: FontWeight.bold,
// //                       color: Color(0xFF2D3748),
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //           Expanded(
// //             child: BlocBuilder<StoriesCategoryCubit, StoriesCategoryState>(
// //               builder: (context, state) {
// //                 if (state is StoriesCategoryLoading) {
// //                   return const Center(
// //                     child: CircularProgressIndicator(
// //                       color: Color(0xFF6B73FF),
// //                     ),
// //                   );
// //                 }
// //
// //                 if (state is StoriesCategorySuccess) {
// //                   final stories = state.storiesByCategoryEntity?.stories ?? [];
// //
// //                   if (stories.isEmpty) {
// //                     return const Center(
// //                       child: Column(
// //                         mainAxisAlignment: MainAxisAlignment.center,
// //                         children: [
// //                           Icon(
// //                             Icons.book_outlined,
// //                             size: 64,
// //                             color: Colors.grey,
// //                           ),
// //                           SizedBox(height: 16),
// //                           Text(
// //                             'لا توجد قصص متاحة في هذه الفئة',
// //                             style: TextStyle(
// //                               fontSize: 16,
// //                               color: Colors.grey,
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                     );
// //                   }
// //
// //                   return GridView.builder(
// //                     padding: const EdgeInsets.symmetric(horizontal: 16),
// //                     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
// //                       crossAxisCount: 2,
// //                       childAspectRatio: 0.75,
// //                       crossAxisSpacing: 12,
// //                       mainAxisSpacing: 12,
// //                     ),
// //                     itemCount: stories.length,
// //                     itemBuilder: (context, index) {
// //                       final story = stories[index];
// //                       return _buildStoryCard(story);
// //                     },
// //                   );
// //                 }
// //
// //                 if (state is StoriesCategoryFailure) {
// //                   return Center(
// //                     child: Column(
// //                       mainAxisAlignment: MainAxisAlignment.center,
// //                       children: [
// //                         const Icon(
// //                           Icons.error_outline,
// //                           size: 64,
// //                           color: Colors.red,
// //                         ),
// //                         const SizedBox(height: 16),
// //                         const Text(
// //                           'حدث خطأ في تحميل القصص',
// //                           style: TextStyle(
// //                             fontSize: 16,
// //                             color: Colors.red,
// //                           ),
// //                         ),
// //                         const SizedBox(height: 16),
// //                         ElevatedButton(
// //                           onPressed: () => storiesViewModel.getCategoriesStories(
// //                             categoryId: selectedCategoryId,
// //                             idChildren: widget.child.idChildren,
// //                             page: 1,
// //                           ),
// //                           style: ElevatedButton.styleFrom(
// //                             backgroundColor: const Color(0xFF6B73FF),
// //                           ),
// //                           child: const Text(
// //                             'إعادة المحاولة',
// //                             style: TextStyle(color: Colors.white),
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   );
// //                 }
// //
// //                 return const SizedBox.shrink();
// //               },
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _buildStoryCard(StoriesCategory story) {
// //     return Material(
// //       color: Colors.transparent,
// //       child: InkWell(
// //         onTap: () {
// //           // Navigate to story details or story reading screen
// //           // Navigator.push(context, MaterialPageRoute(builder: (context) => StoryDetailsPage(story: story)));
// //         },
// //         borderRadius: BorderRadius.circular(16),
// //         child: Container(
// //           decoration: BoxDecoration(
// //             color: Colors.white,
// //             borderRadius: BorderRadius.circular(16),
// //             boxShadow: [
// //               BoxShadow(
// //                 color: Colors.grey.withOpacity(0.1),
// //                 spreadRadius: 2,
// //                 blurRadius: 8,
// //                 offset: const Offset(0, 2),
// //               ),
// //             ],
// //           ),
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               // Story Image
// //               Expanded(
// //                 flex: 3,
// //                 child: Container(
// //                   width: double.infinity,
// //                   decoration: BoxDecoration(
// //                     color: const Color(0xFF6B73FF).withOpacity(0.1),
// //                     borderRadius: const BorderRadius.vertical(
// //                       top: Radius.circular(16),
// //                     ),
// //                   ),
// //                   child: story.imageCover != null && story.imageCover!.isNotEmpty
// //                       ? ClipRRect(
// //                     borderRadius: const BorderRadius.vertical(
// //                       top: Radius.circular(16),
// //                     ),
// //                     child: Image.network(
// //                       story.imageCover!,
// //                       fit: BoxFit.cover,
// //                       errorBuilder: (context, error, stackTrace) {
// //                         return const Icon(
// //                           Icons.book,
// //                           size: 40,
// //                           color: Color(0xFF6B73FF),
// //                         );
// //                       },
// //                     ),
// //                   )
// //                       : const Icon(
// //                     Icons.book,
// //                     size: 40,
// //                     color: Color(0xFF6B73FF),
// //                   ),
// //                 ),
// //               ),
// //               // Story Info
// //               Expanded(
// //                 flex: 2,
// //                 child: Padding(
// //                   padding: const EdgeInsets.all(12),
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       Text(
// //                         story.storyTitle ?? 'قصة بدون عنوان',
// //                         style: const TextStyle(
// //                           fontSize: 14,
// //                           fontWeight: FontWeight.bold,
// //                           color: Color(0xFF2D3748),
// //                         ),
// //                         maxLines: 2,
// //                         overflow: TextOverflow.ellipsis,
// //                       ),
// //                       const SizedBox(height: 4),
// //                       if (story.storyDescription != null)
// //                         Expanded(
// //                           child: Text(
// //                             story.storyDescription!,
// //                             style: TextStyle(
// //                               fontSize: 12,
// //                               color: Colors.grey[600],
// //                             ),
// //                             maxLines: 3,
// //                             overflow: TextOverflow.ellipsis,
// //                           ),
// //                         ),
// //                       const SizedBox(height: 8),
// //                       Row(
// //                         children: [
// //                           if (story.ageGroup != null) ...[
// //                             Container(
// //                               padding: const EdgeInsets.symmetric(
// //                                 horizontal: 6,
// //                                 vertical: 2,
// //                               ),
// //                               decoration: BoxDecoration(
// //                                 color: const Color(0xFF6B73FF).withOpacity(0.1),
// //                                 borderRadius: BorderRadius.circular(8),
// //                               ),
// //                               child: Text(
// //                                 story.ageGroup!,
// //                                 style: const TextStyle(
// //                                   fontSize: 10,
// //                                   color: Color(0xFF6B73FF),
// //                                   fontWeight: FontWeight.w500,
// //                                 ),
// //                               ),
// //                             ),
// //                           ],
// //                         ],
// //                       ),
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
// //   @override
// //   void dispose() {
// //     // Don't dispose ViewModels here as they are managed by GetIt
// //     super.dispose();
// //   }
// // }
//
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:wise_child/features/Children/data/models/response/get_children_dto.dart';
// import 'package:wise_child/features/SelectStoriesScreen/data/models/response/get_categories_stories_dto.dart';
// import 'package:wise_child/features/SelectStoriesScreen/data/models/response/stories_by_category_dto.dart';
//
// import '../../../../core/di/di.dart';
// import '../bloc/SelectStoriesScreen_cubit.dart';
// import '../bloc/stories_category_cubit.dart';
// import '../widgets/category_card_widget.dart';
// import '../widgets/story_card_widget.dart';
//
//
// class SelectStoriesScreenPage extends StatefulWidget {
//   const SelectStoriesScreenPage({super.key, required this.child});
//   final Children child;
//
//   @override
//   State<SelectStoriesScreenPage> createState() => _SelectStoriesScreenPageState();
// }
//
// class _SelectStoriesScreenPageState extends State<SelectStoriesScreenPage>
//     with TickerProviderStateMixin {
//   late SelectStoriesScreenCubit categoriesViewModel;
//   late StoriesCategoryCubit storiesViewModel;
//   late TabController _tabController;
//
//   int? selectedCategoryId;
//   String selectedCategoryName = '';
//   List<Categories> allCategories = [];
//   List<Categories> filteredCategories = [];
//   List<StoriesCategory> allStories = [];
//   List<StoriesCategory> filteredStories = [];
//
//   final TextEditingController _searchController = TextEditingController();
//   bool isSearching = false;
//
//   @override
//   void initState() {
//     super.initState();
//     categoriesViewModel = getIt.get<SelectStoriesScreenCubit>();
//     storiesViewModel = getIt.get<StoriesCategoryCubit>();
//     _tabController = TabController(length: 2, vsync: this);
//     categoriesViewModel.getCategoriesStories();
//
//     _searchController.addListener(_onSearchChanged);
//   }
//
//   @override
//   void dispose() {
//     _tabController.dispose();
//     _searchController.dispose();
//     super.dispose();
//   }
//
//   void _onSearchChanged() {
//     final query = _searchController.text.toLowerCase();
//     setState(() {
//       if (query.isEmpty) {
//         filteredCategories = allCategories;
//         filteredStories = allStories;
//       } else {
//         filteredCategories = allCategories.where((category) =>
//         (category.categoryName?.toLowerCase().contains(query) ?? false) ||
//             (category.categoryDescription?.toLowerCase().contains(query) ?? false)
//         ).toList();
//
//         filteredStories = allStories.where((story) =>
//         (story.storyTitle?.toLowerCase().contains(query) ?? false) ||
//             (story.storyDescription?.toLowerCase().contains(query) ?? false)
//         ).toList();
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider.value(value: categoriesViewModel),
//         BlocProvider.value(value: storiesViewModel),
//       ],
//       child: Scaffold(
//         backgroundColor: const Color(0xFFF8F9FA),
//         body: NestedScrollView(
//           headerSliverBuilder: (context, innerBoxIsScrolled) => [
//             _buildSliverAppBar(),
//           ],
//           body: Column(
//             children: [
//               _buildChildInfoCard(),
//               _buildSearchBar(),
//               _buildTabBar(),
//               Expanded(child: _buildTabBarView()),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildSliverAppBar() {
//     return SliverAppBar(
//       expandedHeight: 120,
//       floating: false,
//       pinned: true,
//       elevation: 0,
//       backgroundColor: const Color(0xFF6B73FF),
//       foregroundColor: Colors.white,
//       flexibleSpace: FlexibleSpaceBar(
//         title: const Text(
//           'اختيار القصة',
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 18,
//           ),
//         ),
//         background: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//               colors: [
//                 Color(0xFF6B73FF),
//                 Color(0xFF9333EA),
//               ],
//             ),
//           ),
//           child: SafeArea(
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: Row(
//                 children: [
//                   const Spacer(),
//                   Icon(
//                     Icons.auto_stories,
//                     size: 40,
//                     color: Colors.white.withOpacity(0.3),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(
//           bottom: Radius.circular(20),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildChildInfoCard() {
//     return Container(
//       margin: const EdgeInsets.all(16),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             spreadRadius: 2,
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Hero(
//             tag: 'child_avatar_${widget.child.idChildren}',
//             child: Container(
//               width: 60,
//               height: 60,
//               decoration: BoxDecoration(
//                 gradient: const LinearGradient(
//                   colors: [Color(0xFF6B73FF), Color(0xFF9333EA)],
//                 ),
//                 borderRadius: BorderRadius.circular(30),
//               ),
//               child: const Icon(
//                 Icons.child_care,
//                 color: Colors.white,
//                 size: 30,
//               ),
//             ),
//           ),
//           const SizedBox(width: 16),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   widget.child.firstName ?? 'اسم الطفل',
//                   style: const TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: Color(0xFF2D3748),
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Row(
//                   children: [
//                     _buildInfoChip(
//                       icon: Icons.cake,
//                       label: '9 ',
//                       color: const Color(0xFF10B981),
//                     ),
//                     const SizedBox(width: 8),
//                     _buildInfoChip(
//                       icon: Icons.person,
//                       label: widget.child.gender ?? 'غير محدد',
//                       color: const Color(0xFF8B5CF6),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildInfoChip({
//     required IconData icon,
//     required String label,
//     required Color color,
//   }) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(icon, size: 12, color: color),
//           const SizedBox(width: 4),
//           Text(
//             label,
//             style: TextStyle(
//               fontSize: 11,
//               color: color,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildSearchBar() {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             spreadRadius: 1,
//             blurRadius: 4,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: TextField(
//         controller: _searchController,
//         decoration: InputDecoration(
//           hintText: 'البحث في القصص والفئات...',
//           prefixIcon: const Icon(
//             Icons.search,
//             color: Color(0xFF6B73FF),
//           ),
//           suffixIcon: _searchController.text.isNotEmpty
//               ? IconButton(
//             onPressed: () {
//               _searchController.clear();
//             },
//             icon: const Icon(
//               Icons.clear,
//               color: Colors.grey,
//             ),
//           )
//               : null,
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: BorderSide.none,
//           ),
//           filled: true,
//           fillColor: Colors.white,
//           contentPadding: const EdgeInsets.symmetric(
//             horizontal: 16,
//             vertical: 12,
//           ),
//         ),
//         onChanged: (value) => setState(() {}),
//       ),
//     );
//   }
//
//   Widget _buildTabBar() {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16),
//       decoration: BoxDecoration(
//         color: Colors.grey[100],
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: TabBar(
//         controller: _tabController,
//         labelColor: Colors.white,
//         unselectedLabelColor: const Color(0xFF6B73FF),
//         indicator: BoxDecoration(
//           color: const Color(0xFF6B73FF),
//           borderRadius: BorderRadius.circular(12),
//         ),
//         tabs: const [
//           Tab(
//             icon: Icon(Icons.category),
//             text: 'الفئات',
//           ),
//           Tab(
//             icon: Icon(Icons.book),
//             text: 'جميع القصص',
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildTabBarView() {
//     return TabBarView(
//       controller: _tabController,
//       children: [
//         _buildCategoriesTab(),
//         _buildAllStoriesTab(),
//       ],
//     );
//   }
//
//   Widget _buildCategoriesTab() {
//     return RefreshIndicator(
//       onRefresh: () async {
//         categoriesViewModel.getCategoriesStories();
//       },
//       color: const Color(0xFF6B73FF),
//       child: BlocListener<SelectStoriesScreenCubit, SelectStoriesScreenState>(
//         listener: (context, state) {
//           if (state is SelectStoriesScreenSuccess) {
//             setState(() {
//               allCategories = state.getCategoriesStoriesEntity?.categories ?? [];
//               filteredCategories = allCategories;
//             });
//           }
//         },
//         child: BlocBuilder<SelectStoriesScreenCubit, SelectStoriesScreenState>(
//           builder: (context, state) {
//             if (state is SelectStoriesScreenLoading) {
//               return Text('data');
//               // return const LoadingWidget(
//               //   message: 'جاري تحميل فئات القصص...',
//               // );
//             }
//
//             if (state is SelectStoriesScreenSuccess) {
//               if (filteredCategories.isEmpty) {
//                 return Text('data');
//                 // return EmptyStateWidget(
//                 //   icon: Icons.category_outlined,
//                 //   title: _searchController.text.isNotEmpty
//                 //       ? 'لا توجد نتائج للبحث'
//                 //       : 'لا توجد فئات متاحة',
//                 //   subtitle: _searchController.text.isNotEmpty
//                 //       ? 'جرب كلمات بحث أخرى'
//                 //       : 'لم يتم العثور على أي فئات قصص متاحة حالياً',
//                 // );
//               }
//
//               return ListView.builder(
//                 padding: const EdgeInsets.all(16),
//                 itemCount: filteredCategories.length,
//                 itemBuilder: (context, index) {
//                   final category = filteredCategories[index];
//                   return CategoryCardWidget(
//                     category: category,
//                     isSelected: selectedCategoryId == category.categoryId,
//                     onTap: () => _selectCategory(category),
//                   );
//                 },
//               );
//             }
//
//             if (state is SelectStoriesScreenFailure) {
//               return Text('data');
//               //   ErrorStateWidget(
//               //   title: 'حدث خطأ في تحميل الفئات',
//               //   subtitle: 'تعذر تحميل فئات القصص. يرجى المحاولة مرة أخرى.',
//               //   onRetry: () => categoriesViewModel.getCategoriesStories(),
//               // );
//             }
//
//             return const SizedBox.shrink();
//           },
//         ),
//       ),
//     );
//   }
//
//   Widget _buildAllStoriesTab() {
//     return BlocListener<StoriesCategoryCubit, StoriesCategoryState>(
//       listener: (context, state) {
//         if (state is StoriesCategorySuccess) {
//           setState(() {
//             allStories = state.storiesByCategoryEntity?.stories ?? [];
//             filteredStories = allStories;
//           });
//         }
//       },
//       child: BlocBuilder<StoriesCategoryCubit, StoriesCategoryState>(
//         builder: (context, state) {
//           if (selectedCategoryId == null) {
//             return Text('data');
//             //   const EmptyStateWidget(
//             //   icon: Icons.touch_app,
//             //   title: 'اختر فئة أولاً',
//             //   subtitle: 'انتقل إلى تبويب الفئات واختر فئة لعرض القصص',
//             // );
//           }
//
//           if (state is StoriesCategoryLoading) {
//             return Text('data');
//             // return const LoadingWidget(
//             //   message: 'جاري تحميل القصص...',
//             // );
//           }
//
//           if (state is StoriesCategorySuccess) {
//             if (filteredStories.isEmpty) {
//               return Text('data');
//               // return EmptyStateWidget(
//               //   icon: Icons.book_outlined,
//               //   title: _searchController.text.isNotEmpty
//               //       ? 'لا توجد نتائج للبحث'
//               //       : 'لا توجد قصص متاحة',
//               //   subtitle: _searchController.text.isNotEmpty
//               //       ? 'جرب كلمات بحث أخرى'
//               //       : 'لم يتم العثور على قصص في هذه الفئة حالياً',
//               // );
//             }
//
//             return GridView.builder(
//               padding: const EdgeInsets.all(16),
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//                 childAspectRatio: 0.75,
//                 crossAxisSpacing: 12,
//                 mainAxisSpacing: 12,
//               ),
//               itemCount: filteredStories.length,
//               itemBuilder: (context, index) {
//                 final story = filteredStories[index];
//                 return StoryCardWidget(
//                   story: story,
//                   onTap: () => _onStorySelected(story),
//                 );
//               },
//             );
//           }
//
//           if (state is StoriesCategoryFailure) {
//             return Text('data');
//             // return ErrorStateWidget(
//             //   title: 'حدث خطأ في تحميل القصص',
//             //   subtitle: 'تعذر تحميل قصص هذه الفئة. يرجى المحاولة مرة أخرى.',
//             //   onRetry: () => _loadCategoryStories(),
//             // );
//           }
//
//           return const SizedBox.shrink();
//         },
//       ),
//     );
//   }
//
//   void _selectCategory(Categories category) {
//     setState(() {
//       selectedCategoryId = category.categoryId;
//       selectedCategoryName = category.categoryName ?? '';
//     });
//
//     _loadCategoryStories();
//     _tabController.animateTo(1);
//   }
//
//   void _loadCategoryStories() {
//     storiesViewModel.getCategoriesStories(
//       categoryId: selectedCategoryId,
//       idChildren: widget.child.idChildren,
//       page: 1,
//     );
//   }
//
//   void _onStorySelected(StoriesCategory story) {
//     showDialog(
//       context: context,
//       builder: (context) => _buildStoryDetailsDialog(story),
//     );
//   }
//
//   Widget _buildStoryDetailsDialog(StoriesCategory story) {
//     return Dialog(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Container(
//         padding: const EdgeInsets.all(20),
//         constraints: const BoxConstraints(maxWidth: 400, maxHeight: 600),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Dialog Header
//             Row(
//               children: [
//                 Expanded(
//                   child: Text(
//                     story.storyTitle ?? 'تفاصيل القصة',
//                     style: const TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: Color(0xFF2D3748),
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                   onPressed: () => Navigator.of(context).pop(),
//                   icon: const Icon(Icons.close),
//                   color: Colors.grey[600],
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//
//             // Story Image
//             if (story.imageCover != null && story.imageCover!.isNotEmpty)
//               Container(
//                 height: 150,
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(12),
//                   color: const Color(0xFF6B73FF).withOpacity(0.1),
//                 ),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(12),
//                   child: Image.network(
//                     story.imageCover!,
//                     fit: BoxFit.cover,
//                     errorBuilder: (context, error, stackTrace) {
//                       return const Center(
//                         child: Icon(
//                           Icons.book,
//                           size: 50,
//                           color: Color(0xFF6B73FF),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ),
//
//             const SizedBox(height: 16),
//
//             // Story Description
//             if (story.storyDescription != null) ...[
//               Text(
//                 'وصف القصة:',
//                 style: TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.grey[800],
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Expanded(
//                 child: SingleChildScrollView(
//                   child: Text(
//                     story.storyDescription!,
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: Colors.grey[600],
//                       height: 1.5,
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 16),
//             ],
//
//             // Story Info
//             Wrap(
//               spacing: 8,
//               runSpacing: 8,
//               children: [
//                 if (story.ageGroup != null)
//                   _buildDetailChip(
//                     icon: Icons.child_care,
//                     label: story.ageGroup!,
//                     color: const Color(0xFF6B73FF),
//                   ),
//                 if (story.gender != null)
//                   _buildDetailChip(
//                     icon: Icons.person,
//                     label: story.gender!,
//                     color: const Color(0xFF10B981),
//                   ),
//                 if (story.isActive == true)
//                   _buildDetailChip(
//                     icon: Icons.check_circle,
//                     label: 'نشطة',
//                     color: const Color(0xFF059669),
//                   ),
//               ],
//             ),
//
//             // Problem Info
//             if (story.problem != null) ...[
//               const SizedBox(height: 12),
//               Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: Colors.orange.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [
//                         const Icon(
//                           Icons.psychology,
//                           size: 16,
//                           color: Colors.orange,
//                         ),
//                         const SizedBox(width: 4),
//                         Text(
//                           'تساعد في حل:',
//                           style: TextStyle(
//                             fontSize: 12,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.orange[800],
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       story.problem!.problemTitle ?? 'مشكلة غير محددة',
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: Colors.orange[700],
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                     if (story.problem!.problemDescription != null) ...[
//                       const SizedBox(height: 4),
//                       Text(
//                         story.problem!.problemDescription!,
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: Colors.orange[600],
//                         ),
//                       ),
//                     ],
//                   ],
//                 ),
//               ),
//             ],
//
//             const SizedBox(height: 20),
//
//             // Action Buttons
//             Row(
//               children: [
//                 Expanded(
//                   child: OutlinedButton(
//                     onPressed: () => Navigator.of(context).pop(),
//                     style: OutlinedButton.styleFrom(
//                       side: const BorderSide(color: Color(0xFF6B73FF)),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       padding: const EdgeInsets.symmetric(vertical: 12),
//                     ),
//                     child: const Text(
//                       'إلغاء',
//                       style: TextStyle(color: Color(0xFF6B73FF)),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: () {
//                       Navigator.of(context).pop();
//                       _startReadingStory(story);
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFF6B73FF),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       padding: const EdgeInsets.symmetric(vertical: 12),
//                     ),
//                     child: const Text(
//                       'قراءة القصة',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildDetailChip({
//     required IconData icon,
//     required String label,
//     required Color color,
//   }) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(
//             icon,
//             size: 14,
//             color: color,
//           ),
//           const SizedBox(width: 4),
//           Text(
//             label,
//             style: TextStyle(
//               fontSize: 12,
//               color: color,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _startReadingStory(StoriesCategory story) {
//     // TODO: Implement navigation to story reading screen
//     // Example:
//     // Navigator.push(
//     //   context,
//     //   MaterialPageRoute(
//     //     builder: (context) => StoryReadingPage(
//     //       story: story,
//     //       child: widget.child,
//     //     ),
//     //   ),
//     // );
//
//     // For now, show a snackbar with story info
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'بدء قراءة: ${story.storyTitle}',
//               style: const TextStyle(
//                 fontWeight: FontWeight.w600,
//                 color: Colors.white,
//               ),
//             ),
//             if (story.problem?.problemTitle != null)
//               Text(
//                 'المشكلة: ${story.problem!.problemTitle}',
//                 style: const TextStyle(
//                   fontSize: 12,
//                   color: Colors.white70,
//                 ),
//               ),
//           ],
//         ),
//         backgroundColor: const Color(0xFF6B73FF),
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(8),
//         ),
//         duration: const Duration(seconds: 3),
//         action: SnackBarAction(
//           label: 'موافق',
//           textColor: Colors.white,
//           onPressed: () {},
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wise_child/core/widgets/custom_app_bar_app.dart';
import 'package:wise_child/features/Children/data/models/response/get_children_dto.dart';
import 'package:wise_child/features/SelectStoriesScreen/presentation/bloc/save_story_cubit.dart';

import '../../../../core/di/di.dart';
import '../../../../localization/locale_cubit.dart';
import '../bloc/SelectStoriesScreen_cubit.dart';
import '../bloc/stories_category_cubit.dart';
import '../widgets/child_info_section.dart';
import '../widgets/categories_section.dart';
import '../widgets/stories_section.dart';

class SelectStoriesScreenPage extends StatefulWidget {
  const SelectStoriesScreenPage({super.key, required this.child});
  final Children child;

  @override
  State<SelectStoriesScreenPage> createState() => _SelectStoriesScreenPageState();
}

class _SelectStoriesScreenPageState extends State<SelectStoriesScreenPage>
    with TickerProviderStateMixin {
  late SelectStoriesScreenCubit categoriesViewModel;
  late StoriesCategoryCubit storiesViewModel;
  late SaveStoryCubit saveStoryViewModel;
  late AnimationController _fadeController;
  late AnimationController _slideController;

  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  int? selectedCategoryId;
  String selectedCategoryName = '';
  bool showStories = false;

  @override
  void initState() {
    super.initState();
    _initializeViewModels();
    _initializeAnimations();
    _startAnimations();
    categoriesViewModel.getCategoriesStories();
  }

  void _initializeViewModels() {
    categoriesViewModel = getIt.get<SelectStoriesScreenCubit>();
    storiesViewModel = getIt.get<StoriesCategoryCubit>();
    saveStoryViewModel=getIt.get<SaveStoryCubit>();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
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
  }

  void _startAnimations() {
    _fadeController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      _slideController.forward();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    HapticFeedback.mediumImpact();
    if (showStories && selectedCategoryId != null) {
      return storiesViewModel.getCategoriesStories(
        categoryId: selectedCategoryId,
        idChildren: widget.child.idChildren,
        page: 1,
      );
    } else {
      return categoriesViewModel.getCategoriesStories();
    }
  }

  void _onCategorySelected(int? categoryId, String categoryName) {
    setState(() {
      selectedCategoryId = categoryId;
      selectedCategoryName = categoryName;
      showStories = true;
    });

    storiesViewModel.getCategoriesStories(
      categoryId: categoryId,
      idChildren: widget.child.idChildren,
      page: 1,
    );
  }

  void _onBackPressed() {
    setState(() {
      showStories = false;
      selectedCategoryId = null;
      selectedCategoryName = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final languageCode = LocaleCubit.get(context).state.languageCode;
    final isRTL = languageCode == 'ar';

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: categoriesViewModel),
        BlocProvider.value(value: storiesViewModel),
        BlocProvider.value(value: saveStoryViewModel),
      ],
      child: Scaffold(
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
          child: RefreshIndicator(
            onRefresh: _onRefresh,
            color: Theme.of(context).primaryColor,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                // App Bar
                SliverToBoxAdapter(
                  child: CustomAppBarApp(
                    subtitle: '',
                    title: showStories ? 'قصص $selectedCategoryName' : 'اختيار القصة',
                    backFunction:  () => Navigator.pop(context) ,
                    // showBackButton: showStories,
                    // onBackPressed: showStories ? _onBackPressed : null,
                  ),
                ),

                // Child Info Section
                ChildInfoSection(
                  child: widget.child,
                  fadeAnimation: _fadeAnimation,
                  slideAnimation: _slideAnimation,
                  isRTL: isRTL,
                ),

                // Main Content
                if (!showStories)
                  CategoriesSection(
                    isRTL: isRTL,
                    onCategorySelected: _onCategorySelected,
                  )
                else
                  StoriesSection(
                    isRTL: isRTL,
                    selectedCategoryId: selectedCategoryId,
                    child: widget.child,
                    childId: widget.child.idChildren??0 ,
                  ),

                // Bottom Spacing
                const SliverToBoxAdapter(
                  child: SizedBox(height: 100),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}