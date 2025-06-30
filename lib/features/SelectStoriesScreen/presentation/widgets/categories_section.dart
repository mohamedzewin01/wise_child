import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/SelectStoriesScreen_cubit.dart';
import '../widgets/category_card_widget.dart';
import '../widgets/common_states_widgets.dart';

class CategoriesSection extends StatelessWidget {
  final bool isRTL;
  final Function(int?, String) onCategorySelected;

  const CategoriesSection({
    super.key,
    required this.isRTL,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelectStoriesScreenCubit, SelectStoriesScreenState>(
      builder: (context, state) {
        if (state is SelectStoriesScreenLoading) {
          return  LoadingWidget();
        }

        if (state is SelectStoriesScreenSuccess) {
          final categories = state.getCategoriesStoriesEntity?.categories ?? [];

          if (categories.isEmpty) {
            return  CommonStatesWidgets.empty(
              icon: Icons.category_outlined,
              title: 'لا توجد فئات متاحة',
              subtitle: 'لم يتم العثور على أي فئات قصص متاحة حالياً',
            );
          }

          return SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  return TweenAnimationBuilder<double>(
                    duration: Duration(milliseconds: 600 + (index * 100)),
                    tween: Tween(begin: 0.0, end: 1.0),
                    builder: (context, value, child) {
                      return Transform.translate(
                        offset: Offset(0, (1 - value) * 50),
                        child: Opacity(
                          opacity: value,
                          child: CategoryCardWidget(
                            category: categories[index],
                            index: index,
                            isRTL: isRTL,
                            onTap: () {
                              HapticFeedback.lightImpact();
                              onCategorySelected(
                                categories[index].categoryId,
                                categories[index].categoryName ?? '',
                              );
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
                childCount: categories.length,
              ),
            ),
          );
        }

        if (state is SelectStoriesScreenFailure) {
          return CommonStatesWidgets.error(
            title: 'حدث خطأ في تحميل الفئات',
            subtitle: 'تعذر تحميل فئات القصص. يرجى المحاولة مرة أخرى.',
            onRetry: () => context.read<SelectStoriesScreenCubit>().getCategoriesStories(),
          );
        }

        return  LoadingWidget();
      },
    );
  }
}