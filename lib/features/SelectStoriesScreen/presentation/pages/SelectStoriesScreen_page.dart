//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:wise_child/core/widgets/custom_app_bar_app.dart';
// import 'package:wise_child/features/Children/data/models/response/get_children_dto.dart';
// import 'package:wise_child/features/SelectStoriesScreen/presentation/bloc/save_story_cubit.dart';
//
// import '../../../../core/di/di.dart';
// import '../../../../localization/locale_cubit.dart';
// import '../bloc/SelectStoriesScreen_cubit.dart';
// import '../bloc/stories_category_cubit.dart';
// import '../widgets/child_info_section.dart';
// import '../widgets/categories_section.dart';
// import '../widgets/stories_section.dart';
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
//   late SaveStoryCubit saveStoryViewModel;
//   late AnimationController _fadeController;
//   late AnimationController _slideController;
//
//   late Animation<double> _fadeAnimation;
//   late Animation<Offset> _slideAnimation;
//
//   int? selectedCategoryId;
//   String selectedCategoryName = '';
//   bool showStories = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeViewModels();
//     _initializeAnimations();
//     _startAnimations();
//     categoriesViewModel.getCategoriesStories();
//   }
//
//   void _initializeViewModels() {
//     categoriesViewModel = getIt.get<SelectStoriesScreenCubit>();
//     storiesViewModel = getIt.get<StoriesCategoryCubit>();
//     saveStoryViewModel=getIt.get<SaveStoryCubit>();
//   }
//
//   void _initializeAnimations() {
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
//     _fadeAnimation = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(CurvedAnimation(
//       parent: _fadeController,
//       curve: Curves.easeInOut,
//     ));
//
//     _slideAnimation = Tween<Offset>(
//       begin: const Offset(0, 0.3),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(
//       parent: _slideController,
//       curve: Curves.easeOutCubic,
//     ));
//   }
//
//   void _startAnimations() {
//     _fadeController.forward();
//     Future.delayed(const Duration(milliseconds: 200), () {
//       _slideController.forward();
//     });
//   }
//
//   @override
//   void dispose() {
//     _fadeController.dispose();
//     _slideController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _onRefresh() async {
//     HapticFeedback.mediumImpact();
//     if (showStories && selectedCategoryId != null) {
//       return storiesViewModel.getCategoriesStories(
//         categoryId: selectedCategoryId,
//         idChildren: widget.child.idChildren,
//         page: 1,
//       );
//     } else {
//       return categoriesViewModel.getCategoriesStories();
//     }
//   }
//
//   void _onCategorySelected(int? categoryId, String categoryName) {
//     setState(() {
//       selectedCategoryId = categoryId;
//       selectedCategoryName = categoryName;
//       showStories = true;
//     });
//
//     storiesViewModel.getCategoriesStories(
//       categoryId: categoryId,
//       idChildren: widget.child.idChildren,
//       page: 1,
//     );
//   }
//
//   void _onBackPressed() {
//     setState(() {
//       showStories = false;
//       selectedCategoryId = null;
//       selectedCategoryName = '';
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final languageCode = LocaleCubit.get(context).state.languageCode;
//     final isRTL = languageCode == 'ar';
//
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider.value(value: categoriesViewModel),
//         BlocProvider.value(value: storiesViewModel),
//         BlocProvider.value(value: saveStoryViewModel),
//       ],
//       child: Scaffold(
//         body: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//               colors: [
//                 const Color(0xFFF8FAFF),
//                 Colors.white,
//                 const Color(0xFFFAFCFF),
//                 Colors.blue.shade50.withOpacity(0.3),
//               ],
//               stops: const [0.0, 0.3, 0.7, 1.0],
//             ),
//           ),
//           child: RefreshIndicator(
//             onRefresh: _onRefresh,
//             color: Theme.of(context).primaryColor,
//             child: CustomScrollView(
//               physics: const AlwaysScrollableScrollPhysics(),
//               slivers: [
//                 // App Bar
//                 SliverToBoxAdapter(
//                   child: CustomAppBarApp(
//                     subtitle: '',
//                     title: showStories ? 'قصص $selectedCategoryName' : 'اختيار القصة',
//                     backFunction:  () => Navigator.pop(context) ,
//                     // showBackButton: showStories,
//                     // onBackPressed: showStories ? _onBackPressed : null,
//                   ),
//                 ),
//
//                 // Child Info Section
//                 ChildInfoSection(
//                   child: widget.child,
//                   fadeAnimation: _fadeAnimation,
//                   slideAnimation: _slideAnimation,
//                   isRTL: isRTL,
//                 ),
//
//                 // Main Content
//                 if (!showStories)
//                   CategoriesSection(
//                     isRTL: isRTL,
//                     onCategorySelected: _onCategorySelected,
//                   )
//                 else
//                   StoriesSection(
//                     isRTL: isRTL,
//                     selectedCategoryId: selectedCategoryId,
//                     child: widget.child,
//                     childId: widget.child.idChildren??0 ,
//                   ),
//
//                 // Bottom Spacing
//                 const SliverToBoxAdapter(
//                   child: SizedBox(height: 100),
//                 ),
//               ],
//             ),
//           ),
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
    saveStoryViewModel = getIt.get<SaveStoryCubit>();
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

  // Handle back button press
  Future<bool> _onWillPop() async {
    if (showStories) {
      // إذا كان في StoriesSection، ارجع إلى CategoriesSection
      _onBackPressed();
      return false; // لا تخرج من الصفحة
    } else {
      // إذا كان في CategoriesSection، اخرج من الصفحة
      return true; // اخرج من الصفحة
    }
  }

  // Handle app bar back button
  void _handleAppBarBack() {
    if (showStories) {
      // إذا كان في StoriesSection، ارجع إلى CategoriesSection
      _onBackPressed();
    } else {
      // إذا كان في CategoriesSection، اخرج من الصفحة
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final languageCode = LocaleCubit.get(context).state.languageCode;
    final isRTL = languageCode == 'ar';

    return WillPopScope(
      onWillPop: _onWillPop,
      child: MultiBlocProvider(
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
                      backFunction: _handleAppBarBack,
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
                      childId: widget.child.idChildren ?? 0,
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
      ),
    );
  }
}