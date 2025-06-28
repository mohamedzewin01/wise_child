import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'package:wise_child/core/resources/style_manager.dart';
import 'package:wise_child/features/Stories/data/models/response/children_stories_model_dto.dart';
import 'package:wise_child/features/Stories/presentation/bloc/ChildrenStoriesCubit/children_stories_cubit.dart';
import 'package:wise_child/features/Stories/presentation/widgets/ske_card_user.dart';
import 'package:wise_child/features/Stories/presentation/widgets/story_card.dart';
import 'package:wise_child/l10n/app_localizations.dart';

class StoryChildrenScreen extends StatelessWidget {
  const StoryChildrenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
      sliver: BlocBuilder<ChildrenStoriesCubit, ChildrenStoriesState>(
        builder: (context, state) {
          if (state is ChildrenStoriesLoading) {
            return const SkeCardUser();
          }
          if (state is ChildrenStoriesSuccess) {
            final List<StoriesModeData> stories =
                state.getChildrenEntity?.data ?? [];
            if (stories.isEmpty) {
              return SliverToBoxAdapter(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.sizeOf(context).width * 0.25,
                        ),
                        Icon(
                          Icons.menu_book_outlined,
                          size: 64,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'لا توجد قصص متاحة لهذا الطفل حاليًا',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
            return SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final story = stories[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: StoryCard(
                    storyId: story.storyId ?? 0,
                    childId: story.childrenId ?? 0,
                    title: story.storyTitle ?? '',
                    description: story.storyDescription ?? '',
                    ageRange:
                        '${story.ageGroup} ${AppLocalizations.of(context)!.yearsOld}',
                    duration: story.categoryName ?? '',
                    imageUrl: story.imageCover ?? '',
                    cardColor: const Color(0xFFFFF8E1),
                    // لون كريمي
                    buttonColor: ColorManager.primaryColor,
                  ),
                );
              }, childCount: stories.length),
            );
          }

          if (state is ChildrenStoriesFailure) {
            return SliverToBoxAdapter(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.sizeOf(context).width * 0.25,),
                      const Icon(
                        Icons.menu_book_outlined,
                        size: 64,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'لم يتم تفعيل اي قصص لهذا الطفل حاليًا',
                        style: getBoldStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 20),

                      ElevatedButton.icon(
                        onPressed: () {
                          context
                              .read<ChildrenStoriesCubit>()
                              .getStoriesChildren();
                        },
                        label: Text('إعادة التحميل',   style: getBoldStyle(color: ColorManager.white),),
                        icon: Icon(Icons.refresh),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorManager.primaryColor,
                          foregroundColor: ColorManager.white,

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          return const SkeCardUser();
        },
      ),
    );
  }
}
