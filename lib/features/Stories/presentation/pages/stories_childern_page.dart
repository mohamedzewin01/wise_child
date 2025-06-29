// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:wise_child/core/resources/color_manager.dart';
// import 'package:wise_child/core/widgets/custom_app_bar.dart';
// import 'package:wise_child/features/Stories/presentation/bloc/ChildrenStoriesCubit/children_stories_cubit.dart';
// import 'package:wise_child/features/Stories/presentation/widgets/user_children.dart';
// import 'package:wise_child/features/layout/presentation/cubit/layout_cubit.dart';
// import '../../../../core/di/di.dart';
// import '../bloc/Stories_cubit.dart';
// import '../widgets/card_story.dart';
//
// class StoriesChildrenPage extends StatefulWidget {
//   const StoriesChildrenPage({super.key});
//
//   @override
//   State<StoriesChildrenPage> createState() => _StoriesChildrenPageState();
// }
//
// class _StoriesChildrenPageState extends State<StoriesChildrenPage> {
//   late StoriesCubit viewModel;
//   late ChildrenStoriesCubit childrenStoriesCubit;
//
//   @override
//   void initState() {
//     viewModel = getIt.get<StoriesCubit>();
//     childrenStoriesCubit = getIt.get<ChildrenStoriesCubit>();
//     viewModel.getChildrenByUser();
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     viewModel.getChildrenByUser();
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider.value(
//           value: viewModel,
//         ),
//         BlocProvider.value(
//           value: childrenStoriesCubit,
//         ),
//       ],
//         child: RefreshIndicator(
//           displacement: 50,
//           color: ColorManager.primaryColor,
//           onRefresh: () async{
//
//             return viewModel.getChildrenByUser();
//           },
//           child: Scaffold(
//             backgroundColor: Colors.white,
//             body: Column(
//               children: [
//                 Expanded(
//                   child: CustomScrollView(
//                     physics:  const AlwaysScrollableScrollPhysics(),
//                     slivers: [
//                       SliverCustomAppBar(
//                         iconActionOne: Icons.arrow_forward_ios_rounded,
//                         onTapActionTow: () => LayoutCubit.get(context).changeIndex(0),
//                       ),
//                       UserChildren(),
//                       StoryChildrenScreen(),
//
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//
//     );
//   }
// }
//
//
//


import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'package:wise_child/core/widgets/custom_app_bar.dart';
import 'package:wise_child/features/Stories/presentation/bloc/ChildrenStoriesCubit/children_stories_cubit.dart';
import 'package:wise_child/features/Stories/presentation/widgets/user_children.dart';
import 'package:wise_child/features/layout/presentation/cubit/layout_cubit.dart';
import '../../../../core/di/di.dart';
import '../bloc/Stories_cubit.dart';
import '../widgets/card_story.dart';
import '../../../../core/widgets/no_children_page.dart'; // استيراد الصفحة الجديدة

class StoriesChildrenPage extends StatefulWidget {
  const StoriesChildrenPage({super.key});

  @override
  State<StoriesChildrenPage> createState() => _StoriesChildrenPageState();
}

class _StoriesChildrenPageState extends State<StoriesChildrenPage> {
  late StoriesCubit viewModel;
  late ChildrenStoriesCubit childrenStoriesCubit;

  @override
  void initState() {
    viewModel = getIt.get<StoriesCubit>();
    childrenStoriesCubit = getIt.get<ChildrenStoriesCubit>();
    viewModel.getChildrenByUser();
    super.initState();
  }

  void _navigateToAddChild() {
    // هنا يمكنك إضافة التنقل لصفحة إضافة طفل
    // Navigator.pushNamed(context, '/add-child');
    print('Navigate to add child page');
  }

  Future<void> _onRefresh() async {
    return viewModel.getChildrenByUser();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: viewModel),
        BlocProvider.value(value: childrenStoriesCubit),
      ],
      child: BlocBuilder<StoriesCubit, StoriesState>(
        builder: (context, state) {
          // التحقق من حالة عدم وجود أطفال
          if (state is StoriesSuccess) {
            var children = state.getChildrenEntity.children ?? [];

            if (children.isEmpty) {
              // عرض صفحة عدم وجود أطفال
              return Scaffold(
                body: NoChildrenPage(
                  onAddChildPressed: _navigateToAddChild,
                  onRefreshPressed: _onRefresh,
                ),
              );
            }
          }

          // عرض الواجهة العادية عند وجود أطفال
          return RefreshIndicator(
            displacement: 50,
            color: ColorManager.primaryColor,
            onRefresh: _onRefresh,
            child: Scaffold(
              backgroundColor: Colors.white,
              body: Column(
                children: [
                  Expanded(
                    child: CustomScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      slivers: [
                        SliverCustomAppBar(
                          iconActionOne: Icons.arrow_forward_ios_rounded,
                          onTapActionTow: () => LayoutCubit.get(context).changeIndex(0),
                        ),

                        // عرض قائمة الأطفال فقط عند وجودهم
                        if (state is StoriesSuccess &&
                            (state.getChildrenEntity.children?.isNotEmpty ?? false))
                          const UserChildren(),

                        // عرض القصص فقط عند وجود أطفال
                        if (state is StoriesSuccess &&
                            (state.getChildrenEntity.children?.isNotEmpty ?? false))
                          const StoryChildrenScreen(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}