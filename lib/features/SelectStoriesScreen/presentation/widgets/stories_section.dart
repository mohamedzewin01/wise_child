import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wise_child/features/Children/data/models/response/get_children_dto.dart';

import '../bloc/stories_category_cubit.dart';
import '../widgets/story_card_widget.dart';
import '../widgets/common_states_widgets.dart';
import '../widgets/story_details_dialog.dart';

class StoriesSection extends StatelessWidget {
  final bool isRTL;
  final int? selectedCategoryId;
  final Children child;

  const StoriesSection({
    super.key,
    required this.isRTL,
    required this.selectedCategoryId,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoriesCategoryCubit, StoriesCategoryState>(
      builder: (context, state) {
        if (state is StoriesCategoryLoading) {
          return  LoadingWidget();
        }

        if (state is StoriesCategorySuccess) {
          final stories = state.storiesByCategoryEntity?.stories ?? [];

          if (stories.isEmpty) {
            return  CommonStatesWidgets.empty(
              icon: Icons.book_outlined,
              title: 'لا توجد قصص متاحة',
              subtitle: 'لم يتم العثور على قصص في هذه الفئة حالياً',
            );
          }

          return SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  return TweenAnimationBuilder<double>(
                    duration: Duration(milliseconds: 600 + (index * 100)),
                    tween: Tween(begin: 0.0, end: 1.0),
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: value,
                        child: Opacity(
                          opacity: value,
                          child: StoryCardWidget(
                            story: stories[index],
                            isRTL: isRTL,
                            onTap: () => _showStoryDetails(
                                context,
                                stories[index],
                                isRTL
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
                childCount: stories.length,
              ),
            ),
          );
        }

        if (state is StoriesCategoryFailure) {
          return CommonStatesWidgets.error(
            title: 'حدث خطأ في تحميل القصص',
            subtitle: 'تعذر تحميل قصص هذه الفئة. يرجى المحاولة مرة أخرى.',
            onRetry: () => context.read<StoriesCategoryCubit>().getCategoriesStories(
              categoryId: selectedCategoryId,
              idChildren: child.idChildren,
              page: 1,
            ),
          );
        }

        return  LoadingWidget();
      },
    );
  }

  void _showStoryDetails(BuildContext context, story, bool isRTL) {
    StoryDetailsDialog.show(
      context: context,
      story: story,
      isRTL: isRTL,
    );
  }
}