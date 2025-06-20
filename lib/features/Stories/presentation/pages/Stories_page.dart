import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:wise_child/core/api/api_constants.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'package:wise_child/core/widgets/custom_app_bar.dart';
import 'package:wise_child/features/Children/presentation/widgets/avatar_image.dart';
import 'package:wise_child/features/Home/presentation/pages/Home_page.dart';
import 'package:wise_child/features/Stories/presentation/bloc/ChildrenStoriesCubit/children_stories_cubit.dart';
import 'package:wise_child/features/Stories/presentation/widgets/user_children.dart';
import 'package:wise_child/features/StoriesPlay/presentation/pages/StoriesPlay_page.dart';

import '../../../../core/di/di.dart';
import '../bloc/Stories_cubit.dart';
import '../widgets/card_story.dart';

class StoriesPage extends StatefulWidget {
  const StoriesPage({super.key});

  @override
  State<StoriesPage> createState() => _StoriesPageState();
}

class _StoriesPageState extends State<StoriesPage> {
  late StoriesCubit viewModel;
  late ChildrenStoriesCubit childrenStoriesCubit;

  @override
  void initState() {
    viewModel = getIt.get<StoriesCubit>();
    childrenStoriesCubit = getIt.get<ChildrenStoriesCubit>();
    viewModel.getChildrenByUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    viewModel.getChildrenByUser();
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: viewModel,
        ),
        BlocProvider.value(
          value: childrenStoriesCubit,
        ),
      ],
        child: RefreshIndicator(
          displacement: 50,
          color: ColorManager.primaryColor,
          onRefresh: () async{

            return viewModel.getChildrenByUser();
          },
          child: Scaffold(
            backgroundColor: Colors.white,
            body: Column(
              children: [
                Expanded(
                  child: CustomScrollView(
                    physics:  const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      SliverCustomAppBar(),
                      UserChildren(),
                      StoryChildrenScreen(),

                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

    );
  }
}






