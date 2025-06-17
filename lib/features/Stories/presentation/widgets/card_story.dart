import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'package:wise_child/features/Stories/data/models/response/get_children_stories_dto.dart';
import 'package:wise_child/features/Stories/presentation/bloc/ChildrenStoriesCubit/children_stories_cubit.dart';
import 'package:wise_child/features/Stories/presentation/widgets/ske_card_user.dart';
import 'package:wise_child/features/Stories/presentation/widgets/story_card.dart';

class StoryChildrenScreen extends StatelessWidget {
  const StoryChildrenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
      sliver: BlocBuilder<ChildrenStoriesCubit, ChildrenStoriesState>(
        builder: (context, state) {
          // حالة التحميل
          if (state is ChildrenStoriesLoading) {
            // return const SkeCardUser();
          }

          // حالة النجاح
          if (state is ChildrenStoriesSuccess) {
            final List<StoriesList> stories =
                state.getChildrenEntity?.data?.storiesList ?? [];

            if (stories.isEmpty) {
              return  SliverToBoxAdapter(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        SizedBox(height: MediaQuery.sizeOf(context).width * 0.25),

                        Icon(
                          Icons.menu_book_outlined,
                          size: 64,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'لا توجد قصص متاحة لهذا الطفل حاليًا',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.center,
                        ),

                      ],
                    ),
                  ),
                ),
              );
            }

            return SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  final story = stories[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: StoryCard(
                      title:  'عنوان القصة',
                      description:  'وصف قصير للقصة...',
                      ageRange: 'Ages ',
                      duration: '10 mins',
                      imageUrl: story.imageCover ?? '',
                      cardColor: const Color(0xFFFFF8E1), // لون كريمي
                      buttonColor: ColorManager.primaryColor,
                    ),
                  );
                },
                childCount: stories.length,
              ),
            );
          }

          // حالة وجود خطأ
          if (state is ChildrenStoriesFailure) {
            return SliverToBoxAdapter(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.red,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'حدث خطأ في تحميل القصص',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.red[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {
                          context.read<ChildrenStoriesCubit>().getStoriesChildren();
                        },
                        child: const Text('إعادة المحاولة'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          // الحالة الأولية - عرض رسالة للمستخدم
          return const SliverToBoxAdapter(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Icon(
                      Icons.child_care,
                      size: 64,
                      color: Colors.blue,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'اختر طفل لعرض قصصه',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}