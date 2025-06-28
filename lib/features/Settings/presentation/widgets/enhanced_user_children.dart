import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'package:wise_child/core/resources/style_manager.dart';
import 'package:wise_child/features/Children/presentation/widgets/avatar_image.dart';
import 'package:wise_child/features/Stories/presentation/bloc/ChildrenStoriesCubit/children_stories_cubit.dart';
import 'package:wise_child/features/Stories/presentation/bloc/Stories_cubit.dart';

class EnhancedUserChildren extends StatefulWidget {
  const EnhancedUserChildren({super.key});

  @override
  State<EnhancedUserChildren> createState() => _EnhancedUserChildrenState();
}

class _EnhancedUserChildrenState extends State<EnhancedUserChildren>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _selectionController;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _selectionController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _selectionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, 50 * (1 - _controller.value)),
            child: Opacity(
              opacity: _controller.value,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // عنوان القسم
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: ColorManager.primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.family_restroom_rounded,
                              color: ColorManager.primaryColor,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'اختر طفلك',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: ColorManager.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // قائمة الأطفال
                    SizedBox(
                      height: 140,
                      child: BlocBuilder<StoriesCubit, StoriesState>(
                        builder: (context, state) {
                          if (state is StoriesSuccess) {
                            var children = state.getChildrenEntity.children ?? [];

                            // تعيين الطفل الأول كافتراضي
                            if (children.isNotEmpty) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                context.read<ChildrenStoriesCubit>().setInitialChild(
                                    children.first.idChildren ?? 0);
                              });
                            }

                            return BlocBuilder<ChildrenStoriesCubit, ChildrenStoriesState>(
                              builder: (context, childrenStoriesState) {
                                final selectedChildId = context
                                    .read<ChildrenStoriesCubit>()
                                    .getSelectedChildId();

                                return ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: children.length,
                                  itemBuilder: (context, index) {
                                    final child = children[index];
                                    final isSelected = selectedChildId == child.idChildren;

                                    return Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 6),
                                      child: _buildChildCard(
                                        child: child,
                                        isSelected: isSelected,
                                        onTap: () async {
                                          HapticFeedback.lightImpact();
                                          _selectionController.forward().then((_) {
                                            _selectionController.reset();
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

                          // حالة التحميل
                          return _buildLoadingChildren();
                        },
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

  Widget _buildChildCard({
    required dynamic child,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
        width: 90,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // الصورة الرمزية المحسنة
            Hero(
              tag: 'enhanced_child_${child.idChildren}',
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                curve: Curves.elasticOut,
                transform: Matrix4.identity()
                  ..scale(isSelected ? 1.1 : 1.0),
                child: Container(
                  padding: EdgeInsets.all(isSelected ? 4 : 2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: isSelected
                        ? LinearGradient(
                      colors: [
                        ColorManager.primaryColor,
                        ColorManager.primaryColor.withOpacity(0.7),
                        Colors.purple.shade300,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                        : null,
                    boxShadow: [
                      if (isSelected) ...[
                        BoxShadow(
                          color: ColorManager.primaryColor.withOpacity(0.4),
                          blurRadius: 20,
                          spreadRadius: 2,
                          offset: const Offset(0, 8),
                        ),
                        BoxShadow(
                          color: Colors.purple.withOpacity(0.2),
                          blurRadius: 15,
                          spreadRadius: 1,
                          offset: const Offset(0, 4),
                        ),
                      ] else ...[
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 12,
                          spreadRadius: 1,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ],
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: isSelected
                          ? Border.all(color: Colors.white, width: 3)
                          : Border.all(
                          color: Colors.grey.shade200, width: 2),
                    ),
                    padding: const EdgeInsets.all(3),
                    child: AvatarWidget(
                      firstName: child.firstName ?? '',
                      lastName: child.lastName ?? '',
                      backgroundColor: isSelected
                          ? ColorManager.primaryColor
                          : ColorManager.primaryColor.withOpacity(0.6),
                      textColor: Colors.white,
                      imageUrl: child.imageUrl,
                      radius: 28.0,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // اسم الطفل
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: EdgeInsets.symmetric(
                horizontal: isSelected ? 12 : 8,
                vertical: isSelected ? 6 : 4,
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? ColorManager.primaryColor.withOpacity(0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: isSelected
                    ? Border.all(
                  color: ColorManager.primaryColor.withOpacity(0.3),
                  width: 1,
                )
                    : null,
              ),
              child: Text(
                child.firstName ?? '',
                style: TextStyle(
                  fontSize: isSelected ? 14 : 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                  color: isSelected
                      ? ColorManager.primaryColor
                      : Colors.grey[700],
                  letterSpacing: 0.3,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            const SizedBox(height: 8),

            // مؤشر التحديد
            AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              curve: Curves.elasticOut,
              width: isSelected ? 40 : 0,
              height: 4,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    ColorManager.primaryColor,
                    Colors.purple.shade300,
                  ],
                ),
                borderRadius: BorderRadius.circular(3),
                boxShadow: isSelected
                    ? [
                  BoxShadow(
                    color: ColorManager.primaryColor.withOpacity(0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
                    : [],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingChildren() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      itemCount: 4,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Skeletonizer(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey.shade300,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                width: 60,
                height: 14,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(7),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: 30,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}