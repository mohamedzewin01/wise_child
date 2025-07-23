import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'package:wise_child/core/resources/routes_manager.dart';
import 'package:wise_child/features/Children/data/models/response/get_children_dto.dart';
import 'package:wise_child/features/Stories/presentation/bloc/ChildrenStoriesCubit/children_stories_cubit.dart';
import 'package:wise_child/features/Stories/presentation/bloc/Stories_cubit.dart';
import 'package:wise_child/features/Stories/presentation/widgets/children_horizontal_loading.dart';
import 'package:wise_child/features/Stories/presentation/widgets/horizontal_child_card.dart';
import 'package:wise_child/features/Stories/presentation/widgets/stories_list_view.dart';
import '../../../../core/di/di.dart';
import '../../../../core/widgets/custom_app_bar_app.dart';
import '../widgets/side_by_side_stories_grid.dart';
import '../../../../core/widgets/no_children_page.dart';
import '../widgets/story_layout_type.dart';
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
                      icon: _currentLayout != StoryLayoutType.grid
                          ? Icon(
                              Icons.view_list_rounded,
                              color: ColorManager.primaryColor,
                            )
                          : Icon(
                              Icons.grid_view_rounded,
                              color: ColorManager.primaryColor,
                            ),
                      iconFunction: () {
                        _onLayoutChanged(StoryLayoutType.grid);
                        _onLayoutChanged(StoryLayoutType.list);
                      },
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: RefreshIndicator(
                      onRefresh: _onRefresh,
                      color: ColorManager.primaryColor,
                      child: Column(
                        children: [
                          _buildChildrenSection(),

                          _buildStoriesSection(_fadeController),
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
          colors: [Colors.white, const Color(0xFFF8FAFF)],
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
          Expanded(
            child: BlocBuilder<StoriesCubit, StoriesState>(
              builder: (context, state) {
                if (state is StoriesSuccess) {
                  List<Children> children = state.getChildrenEntity.children ?? [];

                  if (children.isNotEmpty) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      context.read<ChildrenStoriesCubit>().setInitialChild(
                        children.first.idChildren ?? 0,
                      );
                    });
                  }

                  return BlocBuilder<
                    ChildrenStoriesCubit,
                    ChildrenStoriesState
                  >(
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
                          final isSelected =
                              selectedChildId == child.idChildren;

                          return Padding(
                            padding: const EdgeInsets.only(left: 16),
                            child: HorizontalChildCard(
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

                return ChildrenHorizontalLoading();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoriesSection(AnimationController controller) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, const Color(0xFFFAFCFF)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        children: [
          // محتوى القصص مع الرسوم المتحركة
          AnimatedBuilder(
            animation: _layoutSwitchController,
            builder: (context, child) {
              return Transform.scale(
                scale: 1.0 - (_layoutSwitchController.value * 0.05),
                child: Opacity(
                  opacity: 1.0 - (_layoutSwitchController.value * 0.3),
                  child: _buildCurrentLayoutView(controller),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // عرض التخطيط الحالي
  Widget _buildCurrentLayoutView(AnimationController controller) {
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

          return _buildLayoutView(stories, controller);
        }

        if (state is ChildrenStoriesFailure) {
          return StoriesErrorState(controller: _fadeController);
        }

        return const StoriesLoadingGrid();
      },
    );
  }

  Widget _buildLayoutView(
    List<StoriesModeData> stories,
    AnimationController controller,
  ) {
    switch (_currentLayout) {
      case StoryLayoutType.grid:
        // استخدام التخطيط الأصلي
        return const SideBySideStoriesGrid();

      case StoryLayoutType.list:
        return StoriesListView(stories: stories, controller: controller);

      // case StoryLayoutType.carousel:
      //   return _buildCarouselView(stories);
    }
  }
}
