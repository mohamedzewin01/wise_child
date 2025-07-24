import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'package:wise_child/core/resources/style_manager.dart';
import 'package:wise_child/features/ChildStories/presentation/bloc/ChildStories_cubit.dart';
import 'package:wise_child/features/ChildStories/presentation/widgets/stories_header.dart';
import 'package:wise_child/features/ChildStories/presentation/widgets/stories_loading.dart';
import 'package:wise_child/features/ChildStories/presentation/widgets/stories_error.dart';
import 'package:wise_child/features/ChildStories/presentation/widgets/stories_content.dart';
import 'package:wise_child/features/ChildStories/presentation/widgets/stories_empty.dart';
import 'package:wise_child/features/Children/data/models/response/get_children_dto.dart';
import 'package:wise_child/localization/locale_cubit.dart';
import '../../../../core/di/di.dart';

class ChildStoriesPage extends StatefulWidget {
  final Children child;

  const ChildStoriesPage({
    super.key,
    required this.child,
  });

  @override
  State<ChildStoriesPage> createState() => _ChildStoriesPageState();
}

class _ChildStoriesPageState extends State<ChildStoriesPage>
    with SingleTickerProviderStateMixin {
  late ChildStoriesCubit viewModel;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    viewModel = getIt.get<ChildStoriesCubit>();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    // Load stories
    _loadStories();
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _loadStories() {
    if (widget.child.idChildren != null) {
      viewModel.getChildStories(widget.child.idChildren!);
    }
  }

  void _onRefresh() {
    _loadStories();
  }

  @override
  Widget build(BuildContext context) {
    final languageCode = LocaleCubit.get(context).state.languageCode;
    final isRTL = languageCode == 'ar';

    return BlocProvider.value(
      value: viewModel,
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        body: FadeTransition(
          opacity: _fadeAnimation,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Header Section
              StoriesHeader(
                child: widget.child,
                isRTL: isRTL,
              ),

              // Content Section
              BlocBuilder<ChildStoriesCubit, ChildStoriesState>(
                builder: (context, state) {
                  return SliverToBoxAdapter(
                    child: _buildContent(state, isRTL),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(ChildStoriesState state, bool isRTL) {
    switch (state) {
      case ChildStoriesLoading():
        return const StoriesLoading();

      case ChildStoriesFailure():
        return StoriesError(
          error: state.exception.toString(),
          onRetry: _onRefresh,
          isRTL: isRTL,
        );

      case ChildStoriesSuccess():
        final stories = state.getChildStoriesEntity?.child?.stories;

        if (stories == null || stories.isEmpty) {
          return StoriesEmpty(
            childName: widget.child.firstName ?? '',
            onRefresh: _onRefresh,
            isRTL: isRTL,
          );
        }

        return StoriesContent(
          stories: stories,
          child: widget.child,
          onRefresh: _onRefresh,
          isRTL: isRTL,
        );

      default:
        return const StoriesLoading();
    }
  }
}