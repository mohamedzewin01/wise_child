import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wise_child/core/di/di.dart';
import 'package:wise_child/features/StoriesUnderCategory/presentation/bloc/StoriesUnderCategory_cubit.dart';
import 'package:wise_child/features/StoriesUnderCategory/presentation/widgets/stories_under_category_content.dart';
import 'package:wise_child/features/StoriesUnderCategory/presentation/widgets/stories_under_category_loading_widget.dart';
import 'package:wise_child/features/StoriesUnderCategory/presentation/widgets/stories_under_category_error_widget.dart';
import 'package:wise_child/features/StoryInfo/presentation/widgets/story_info_loading_widget.dart';

class StoriesUnderCategoryPage extends StatefulWidget {
  final int categoryId;
  final String? categoryName;
  final bool isRTL;

  const StoriesUnderCategoryPage({
    super.key,
    required this.categoryId,
    this.categoryName,
    this.isRTL = true,
  });

  @override
  State<StoriesUnderCategoryPage> createState() => _StoriesUnderCategoryPageState();
}

class _StoriesUnderCategoryPageState extends State<StoriesUnderCategoryPage> {
  late StoriesUnderCategoryCubit viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = getIt.get<StoriesUnderCategoryCubit>();
    _loadStoriesUnderCategory();
  }

  void _loadStoriesUnderCategory() {
    viewModel.getStoriesUnderCategory(widget.categoryId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: viewModel,
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        body: BlocBuilder<StoriesUnderCategoryCubit, StoriesUnderCategoryState>(
          builder: (context, state) {
            // if (state is StoriesUnderCategoryLoading) {
            //   return StoriesUnderCategoryLoadingWidget(
            //     onRetry: _retryLoading,
            //     categoryName: widget.categoryName,
            //   );
            // } else
              if (state is StoriesUnderCategorySuccess) {
              // if (state.storiesUnderCategoryEntity.category?.stories?.isEmpty ?? true) {
              //   return StoriesUnderCategoryErrorWidget(
              //     onRetry: _retryLoading,
              //     categoryName: widget.categoryName,
              //     isEmptyState: true,
              //   );
              // }
              return StoriesUnderCategoryContent(
                storiesUnderCategory: state.storiesUnderCategoryEntity,
                isRTL: widget.isRTL,
                categoryName: widget.categoryName,
              );
            }
              else if (state is StoriesUnderCategoryFailure) {
              return StoryInfoLoadingWidget(
               onRetry: () {

               },
              );
            }
            return StoryInfoLoadingWidget(
              onRetry: _retryLoading,

            );
          },
        ),
      ),
    );
  }

  void _retryLoading() {
    HapticFeedback.lightImpact();
    _loadStoriesUnderCategory();
  }

  @override
  void dispose() {
    super.dispose();
  }
}