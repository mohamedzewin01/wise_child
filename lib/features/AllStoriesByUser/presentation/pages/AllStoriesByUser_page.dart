import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'package:wise_child/core/resources/routes_manager.dart';
import 'package:wise_child/core/resources/style_manager.dart';
import 'package:wise_child/core/widgets/custom_app_bar_app.dart';
import 'package:wise_child/core/widgets/no_children_page.dart';
import 'package:wise_child/features/AllStoriesByUser/presentation/widgets/child_stories_section.dart';
import 'package:wise_child/features/AllStoriesByUser/presentation/widgets/loading_shimmer.dart';
import 'package:wise_child/features/AllStoriesByUser/presentation/widgets/error_widget.dart';
import 'package:wise_child/features/AllStoriesByUser/presentation/widgets/empty_state_widget.dart';
import 'package:wise_child/features/AllStoriesByUser/presentation/widgets/custom_app_bar.dart';
import 'package:wise_child/localization/locale_cubit.dart';

import '../../../../core/di/di.dart';
import '../bloc/AllStoriesByUser_cubit.dart';

class AllStoriesByUserPage extends StatefulWidget {
  const AllStoriesByUserPage({super.key});

  @override
  State<AllStoriesByUserPage> createState() => _AllStoriesByUserPageState();
}

class _AllStoriesByUserPageState extends State<AllStoriesByUserPage> {
  late AllStoriesByUserCubit viewModel;

  @override
  void initState() {
    viewModel = getIt.get<AllStoriesByUserCubit>();
    viewModel.getUserStories();
    super.initState();
  }

  @override
  void dispose() {
    viewModel.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final languageCode = LocaleCubit.get(context).state.languageCode;
    final isRTL = languageCode == 'ar';
    return BlocProvider.value(
      value: viewModel,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        // appBar: const CustomAppBar(),
        body: BlocBuilder<AllStoriesByUserCubit, AllStoriesByUserState>(
          builder: (context, state) {
            switch (state) {
              case AllStoriesByUserLoading():
                return const LoadingShimmer();

              case AllStoriesByUserSuccess():
                if (state.userStoriesEntity.childrenStories?.isEmpty ?? true) {
                  return NoChildrenPage(
                    onAddChildPressed: () {
                      Navigator.pushReplacementNamed(
                        context,
                        RoutesManager.newChildrenPage,
                      );
                    },
                    onRefreshPressed: () {
                      viewModel.getUserStories();
                    },
                  );
                }
                return RefreshIndicator(
                  onRefresh: () async {
                    viewModel.getUserStories();
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomAppBarApp(
                          title: 'اضافة قصص',
                          subtitle: 'يمكنك اختيار من القصص المتاحة لابنائك',
                          backFunction: () => Navigator.pop(context),
                        ),
                        const SizedBox(height: 8),
                        _buildWelcomeSection(),

                        _buildChildrenStoriesSection(
                          state.userStoriesEntity.childrenStories!,
                          isRTL
                        ),
                      ],
                    ),
                  ),
                );

              case AllStoriesByUserFailure():
                return CustomErrorWidget(
                  error: state.exception,
                  onRetry: () => viewModel.getUserStories(),
                );

              default:
                return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [ColorManager.primaryColor, ColorManager.primaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF667EEA).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'مرحباً بك في مكتبة القصص',
                  style: getSemiBoldStyle(fontSize: 18, color: Colors.white),
                ),
                const SizedBox(height: 8),
                Text(
                  'اكتشف عالم من القصص المثيرة لأطفالك',
                  style: getMediumStyle(
                    fontSize: 11,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.auto_stories_rounded,
              color: Colors.white,
              size: 32,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChildrenStoriesSection(List childrenStories,bool isRTL) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Text('قصص الأطفال', style: getSemiBoldStyle(fontSize: 16)),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: ListView.separated(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: childrenStories.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              return ChildStoriesSection(
                childData: childrenStories[index],
                childIndex: index,
                isRTL: isRTL,
              );
            },
          ),
        ),
      ],
    );
  }
}
