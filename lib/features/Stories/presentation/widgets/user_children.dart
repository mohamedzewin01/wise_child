import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'package:wise_child/core/resources/style_manager.dart';
import 'package:wise_child/features/Children/presentation/widgets/avatar_image.dart';
import 'package:wise_child/features/Stories/presentation/bloc/ChildrenStoriesCubit/children_stories_cubit.dart';
import 'package:wise_child/features/Stories/presentation/bloc/Stories_cubit.dart';


class UserChildren extends StatelessWidget {
  const UserChildren({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
        child: SizedBox(
          height: 135,
          child: BlocBuilder<StoriesCubit, StoriesState>(
            builder: (context, state) {
              if (state is StoriesSuccess) {
                var children = state.getChildrenEntity.children ?? [];
                if (children.isNotEmpty) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    context.read<ChildrenStoriesCubit>().setInitialChild(
                        children.first.idChildren ?? 0
                    );
                  });
                }

                return BlocBuilder<ChildrenStoriesCubit, ChildrenStoriesState>(
                  builder: (context, childrenStoriesState) {
                    final selectedChildId = context.read<ChildrenStoriesCubit>().getSelectedChildId();

                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: children.length,
                      itemBuilder: (context, index) {
                        final isSelected = selectedChildId == children[index].idChildren;
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: GestureDetector(
                            onTap: () async {
                              HapticFeedback.lightImpact();
                              await context
                                  .read<ChildrenStoriesCubit>()
                                  .changeIdChildren(children[index].idChildren ?? 0);
                            },
                            child: TweenAnimationBuilder<double>(
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.elasticOut,
                              tween: Tween<double>(
                                begin: 0.0,
                                end: isSelected ? 1.0 : 0.0,
                              ),
                              builder: (context, animation, child) {
                                final scale = 1.0 + (animation * 0.2);


                                return Transform.scale(
                                  scale: scale,
                                  alignment: Alignment.center,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      AnimatedContainer(
                                        duration: const Duration(milliseconds: 350),
                                        curve: Curves.easeInOutCubic,
                                        padding: EdgeInsets.all(isSelected ? 4 : 2),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: isSelected
                                              ? LinearGradient(
                                            colors: [
                                              Colors.blue.shade400,
                                              Colors.purple.shade400,
                                              Colors.pink.shade300,
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            stops: const [0.0, 0.5, 1.0],
                                          )
                                              : null,
                                          boxShadow: [
                                            if (isSelected) ...[
                                              BoxShadow(
                                                color: Colors.blue.withOpacity(0.4),
                                                blurRadius: 20,
                                                spreadRadius: 3,
                                                offset: const Offset(0, 8),
                                              ),
                                              BoxShadow(
                                                color: Colors.purple.withOpacity(0.3),
                                                blurRadius: 15,
                                                spreadRadius: 1,
                                                offset: const Offset(0, 4),
                                              ),
                                            ] else ...[
                                              BoxShadow(
                                                color: Colors.black.withOpacity(0.1),
                                                blurRadius: 8,
                                                spreadRadius: 1,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ],
                                        ),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white,
                                            border: isSelected
                                                ? Border.all(
                                              color: Colors.white,
                                              width: 2,
                                            )
                                                : null,
                                          ),
                                          padding: const EdgeInsets.all(2),
                                          child: Hero(
                                            tag: 'child_${children[index].idChildren}',
                                            child: AvatarWidget(
                                              firstName: children[index].firstName ?? '',
                                              lastName: children[index].lastName ?? '',
                                              backgroundColor: isSelected
                                                  ? ColorManager.primaryColor.withOpacity(.8)
                                                  : ColorManager.primaryColor.withOpacity(.3),
                                              textColor: Colors.white,
                                              imageUrl: children[index].imageUrl,
                                              radius: 25.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: isSelected ? 8 : 6),
                                      AnimatedContainer(
                                        duration: const Duration(milliseconds: 300),
                                        curve: Curves.easeInOutCubic,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: isSelected ? 8 : 4,
                                          vertical: isSelected ? 4 : 2,
                                        ),
                                        decoration: isSelected
                                            ? BoxDecoration(
                                          color: Colors.blue.shade50,
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(
                                            color: Colors.blue.shade200,
                                            width: 1,
                                          ),
                                        )
                                            : null,
                                        child: AnimatedDefaultTextStyle(
                                          duration: const Duration(milliseconds: 300),
                                          curve: Curves.easeInOutCubic,
                                          style:getSemiBoldStyle(
                                          fontSize: isSelected ? 14 : 12,
                                          color: isSelected
                                              ? Colors.blue.shade700
                                              : Colors.black87,


                                          ).copyWith(
                                            letterSpacing: isSelected ? 0.5 : 0.0,
                                            fontWeight: isSelected
                                                ? FontWeight.bold
                                                : FontWeight.w500,
                                          ),


                                          // TextStyle(
                                          //   fontSize: isSelected ? 14 : 12,
                                          //   fontWeight: isSelected
                                          //       ? FontWeight.bold
                                          //       : FontWeight.w500,
                                          //   color: isSelected
                                          //       ? Colors.blue.shade700
                                          //       : Colors.black87,
                                          //   letterSpacing: isSelected ? 0.5 : 0.0,
                                          // ),
                                          child: Text(
                                            children[index].firstName ?? '',
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      AnimatedOpacity(
                                        duration: const Duration(milliseconds: 400),
                                        curve: Curves.elasticOut,
                                        opacity: isSelected ? 1.0 : 0.0,
                                        child: Container(
                                          width: 35,
                                          height: 4,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                Colors.blue.shade400,
                                                Colors.purple.shade400,
                                              ],
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight,
                                            ),
                                            borderRadius: BorderRadius.circular(3),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.blue.withOpacity(0.4),
                                                blurRadius: 8,
                                                offset: const Offset(0, 2),
                                              ),
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
                      },
                    );
                  },
                );
              }
              return ListView(
                scrollDirection: Axis.horizontal,
                children: List.generate(
                  8,
                      (index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Skeletonizer(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 68,
                            height: 68,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey.shade300,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            width: 50,
                            height: 12,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            width: 30,
                            height: 3,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}