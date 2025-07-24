import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'package:wise_child/core/resources/cashed_image.dart';
import 'package:wise_child/features/Stories/data/models/response/children_stories_model_dto.dart';
import 'package:wise_child/features/Stories/presentation/bloc/ChildrenStoriesCubit/children_stories_cubit.dart';
import 'package:wise_child/features/Stories/presentation/widgets/side_story_card.dart';
import 'package:wise_child/features/StoriesPlay/presentation/pages/StoriesPlay_page.dart';
import 'package:wise_child/features/StoriesPlay/presentation/widgets/story_screen.dart';
import 'package:wise_child/features/StoryDetails/presentation/pages/StoryDetails_page.dart';

class StoriesListView extends StatelessWidget {
  final List<StoriesModeData> stories;
  final AnimationController controller;

  const StoriesListView({
    super.key,
    required this.stories,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final childId=context.read<ChildrenStoriesCubit>().idChildren;
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Opacity(
          opacity: controller.value,
          child: ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            itemCount: stories.length,
            itemBuilder: (context, index) {
              final story = stories[index];

              return TweenAnimationBuilder<double>(
                duration: Duration(milliseconds: 600 + (index * 100)),
                tween: Tween(begin: 0.0, end: 1.0),
                curve: Curves.easeOutCubic,
                builder: (context, value, child) {
                  return Transform.translate(
                    offset: Offset(50 * (1 - value), 0),
                    child: Opacity(
                      opacity: value,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 0),
                        child: GestureDetector(
                          onTap: () => navigateToStory(context, childId: childId, storyId: story.storyId??0),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            height: 120,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                children: [
                                  // صورة القصة
                                  Container(
                                    clipBehavior: Clip.antiAlias,
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.blue.shade200,
                                          Colors.purple.shade200,
                                        ],
                                      ),
                                    ),
                                    child: Center(
                                        child:CustomImage(url: story.imageCover??'')

                                    ),
                                  ),

                                  const SizedBox(width: 12),

                                  // معلومات القصة
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          story.storyTitle ?? 'قصة بدون عنوان',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),

                                        const SizedBox(height: 4),

                                        if (story.storyDescription != null)
                                          Text(
                                            story.storyDescription!,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[600],
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                      ],
                                    ),
                                  ),

                                  // زر التشغيل
                                  IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        PageRouteBuilder(
                                          pageBuilder: (context, animation, secondaryAnimation) =>
                                              StoriesPlayPage(
                                                childId: story.childrenId ?? 0,
                                                storyId: story.storyId ?? 0,
                                              ),
                                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                            return SlideTransition(
                                              position: Tween<Offset>(
                                                begin: const Offset(1.0, 0.0),
                                                end: Offset.zero,
                                              ).animate(CurvedAnimation(
                                                parent: animation,
                                                curve: Curves.easeInOutCubic,
                                              )),
                                              child: FadeTransition(
                                                opacity: animation,
                                                child: child,
                                              ),
                                            );
                                          },
                                          transitionDuration: const Duration(milliseconds: 400),
                                        ),
                                      );
                                    },
                                    icon: Icon(
                                      Icons.play_circle_fill_rounded,
                                      color: ColorManager.primaryColor,
                                      size: 32,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}

