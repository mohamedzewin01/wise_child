import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'package:wise_child/core/resources/style_manager.dart';
import 'package:wise_child/features/Stories/data/models/response/children_stories_model_dto.dart';
import 'package:wise_child/features/Stories/presentation/bloc/ChildrenStoriesCubit/children_stories_cubit.dart';
import 'package:wise_child/l10n/app_localizations.dart';

import 'enhanced_story_card.dart';

class EnhancedStoryChildrenScreen extends StatefulWidget {
  const EnhancedStoryChildrenScreen({super.key});

  @override
  State<EnhancedStoryChildrenScreen> createState() => _EnhancedStoryChildrenScreenState();
}

class _EnhancedStoryChildrenScreenState extends State<EnhancedStoryChildrenScreen>
    with TickerProviderStateMixin {
  late AnimationController _listController;
  late AnimationController _emptyStateController;
  late AnimationController _errorStateController;
  late AnimationController _refreshController;

  @override
  void initState() {
    super.initState();
    _listController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _emptyStateController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _errorStateController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _refreshController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _listController.dispose();
    _emptyStateController.dispose();
    _errorStateController.dispose();
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
      sliver: BlocBuilder<ChildrenStoriesCubit, ChildrenStoriesState>(
        builder: (context, state) {
          if (state is ChildrenStoriesLoading) {
            return _buildLoadingState();
          }

          if (state is ChildrenStoriesSuccess) {
            final List<StoriesModeData> stories = state.getChildrenEntity?.data ?? [];

            if (stories.isEmpty) {
              _emptyStateController.forward();
              return _buildEmptyState();
            }

            _listController.forward();
            return _buildStoriesList(stories);
          }

          if (state is ChildrenStoriesFailure) {
            _errorStateController.forward();
            return _buildErrorState();
          }

          return _buildLoadingState();
        },
      ),
    );
  }

  Widget _buildStoriesList(List<StoriesModeData> stories) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
            (context, index) {
          final story = stories[index];
          return AnimatedBuilder(
            animation: _listController,
            builder: (context, child) {
              final animationDelay = index * 0.1;
              final adjustedAnimation = Tween<double>(
                begin: 0.0,
                end: 1.0,
              ).animate(
                CurvedAnimation(
                  parent: _listController,
                  curve: Interval(
                    animationDelay.clamp(0.0, 1.0),
                    (animationDelay + 0.5).clamp(0.0, 1.0),
                    curve: Curves.easeOutCubic,
                  ),
                ),
              );

              return Transform.translate(
                offset: Offset(0, 50 * (1 - adjustedAnimation.value)),
                child: Opacity(
                  opacity: adjustedAnimation.value,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 24.0),
                    child: EnhancedStoryCard(
                      storyId: story.storyId ?? 0,
                      childId: story.childrenId ?? 0,
                      title: story.storyTitle ?? '',
                      description: story.storyDescription ?? '',
                      ageRange: '${story.ageGroup ?? ''} ${AppLocalizations.of(context)?.yearsOld ?? 'سنة'}',
                      category: story.categoryName ?? '',
                      imageUrl: story.imageCover ?? '',
                      index: index,
                    ),
                  ),
                ),
              );
            },
          );
        },
        childCount: stories.length,
      ),
    );
  }

  Widget _buildEmptyState() {
    return SliverToBoxAdapter(
      child: AnimatedBuilder(
        animation: _emptyStateController,
        builder: (context, child) {
          final scaleAnimation = Tween<double>(
            begin: 0.8,
            end: 1.0,
          ).animate(CurvedAnimation(
            parent: _emptyStateController,
            curve: Curves.elasticOut,
          ));

          final fadeAnimation = Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(CurvedAnimation(
            parent: _emptyStateController,
            curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
          ));

          return Transform.scale(
            scale: scaleAnimation.value,
            child: Opacity(
              opacity: fadeAnimation.value,
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 60, horizontal: 8),
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white,
                      const Color(0xFFF8FAFF),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 30,
                      offset: const Offset(0, 15),
                      spreadRadius: 0,
                    ),
                    BoxShadow(
                      color: ColorManager.primaryColor.withOpacity(0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 5),
                      spreadRadius: 5,
                    ),
                  ],
                  border: Border.all(
                    color: ColorManager.primaryColor.withOpacity(0.1),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    // الأيقونة المتحركة
                    TweenAnimationBuilder<double>(
                      duration: const Duration(seconds: 2),
                      tween: Tween(begin: 0.0, end: 1.0),
                      builder: (context, value, child) {
                        return Transform.rotate(
                          angle: value * 0.1,
                          child: Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  ColorManager.primaryColor.withOpacity(0.15),
                                  Colors.purple.withOpacity(0.15),
                                  Colors.blue.withOpacity(0.15),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: ColorManager.primaryColor.withOpacity(0.2),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.auto_stories_rounded,
                              size: 64,
                              color: ColorManager.primaryColor,
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 32),

                    // العنوان الرئيسي
                    ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        colors: [
                          ColorManager.primaryColor,
                          Colors.purple.shade400,
                        ],
                      ).createShader(bounds),
                      child: Text(
                        'لا توجد قصص متاحة',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // النص التوضيحي
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: ColorManager.primaryColor.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: ColorManager.primaryColor.withOpacity(0.1),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        'لم يتم تفعيل أي قصص لهذا الطفل حاليًا\nسيتم إضافة قصص جديدة ومثيرة قريباً',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                          height: 1.6,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    const SizedBox(height: 32),

                    // زر إعادة التحميل
                    AnimatedBuilder(
                      animation: _refreshController,
                      builder: (context, child) {
                        return Transform.rotate(
                          angle: _refreshController.value * 2 * 3.14159,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  ColorManager.primaryColor,
                                  ColorManager.primaryColor.withOpacity(0.8),
                                  Colors.purple.shade400,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: ColorManager.primaryColor.withOpacity(0.4),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                  spreadRadius: 0,
                                ),
                                BoxShadow(
                                  color: Colors.purple.withOpacity(0.2),
                                  blurRadius: 15,
                                  offset: const Offset(0, 4),
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(20),
                                onTap: () async {
                                  _refreshController.forward().then((_) {
                                    _refreshController.reset();
                                  });
                                  await context.read<ChildrenStoriesCubit>().getStoriesChildren();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 32,
                                    vertical: 16,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.refresh_rounded,
                                        color: Colors.white,
                                        size: 22,
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        'إعادة التحميل',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
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

  Widget _buildErrorState() {
    return SliverToBoxAdapter(
      child: AnimatedBuilder(
        animation: _errorStateController,
        builder: (context, child) {
          final bounceAnimation = Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(CurvedAnimation(
            parent: _errorStateController,
            curve: Curves.bounceOut,
          ));

          return Transform.scale(
            scale: bounceAnimation.value,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 60, horizontal: 8),
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white,
                    Colors.red.shade50.withOpacity(0.3),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: Colors.red.withOpacity(0.1),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.1),
                    blurRadius: 30,
                    offset: const Offset(0, 15),
                    spreadRadius: 0,
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 5),
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Column(
                children: [
                  // أيقونة الخطأ المتحركة
                  TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 1500),
                    tween: Tween(begin: 0.0, end: 1.0),
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: 0.8 + (0.2 * value),
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.red.withOpacity(0.15),
                                Colors.orange.withOpacity(0.15),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.red.withOpacity(0.2),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.error_outline_rounded,
                            size: 64,
                            color: Colors.red[400],
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 32),

                  // عنوان الخطأ
                  Text(
                    'حدث خطأ في التحميل',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.red[400],
                      letterSpacing: 0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 16),

                  // وصف الخطأ
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.red.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      'تعذر تحميل القصص في الوقت الحالي\nيرجى التحقق من الاتصال والمحاولة مرة أخرى',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                        height: 1.6,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // زر إعادة المحاولة
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.red[400]!,
                          Colors.red[300]!,
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.withOpacity(0.4),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () {
                          context.read<ChildrenStoriesCubit>().getStoriesChildren();
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.refresh_rounded,
                                color: Colors.white,
                                size: 22,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'إعادة المحاولة',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
            (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: Skeletonizer(
              child: _buildSkeletonCard(),
            ),
          );
        },
        childCount: 3,
      ),
    );
  }

  Widget _buildSkeletonCard() {
    return Container(
      height: 220,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // صورة الهيكل
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.grey[300]!,
                    Colors.grey[200]!,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),
              child: Stack(
                children: [
                  // شارات علوية وهمية
                  Positioned(
                    top: 16,
                    left: 16,
                    child: Row(
                      children: [
                        Container(
                          width: 60,
                          height: 24,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 50,
                          height: 24,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // زر تشغيل وهمي
                  Positioned(
                    top: 20,
                    right: 20,
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // محتوى الهيكل
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // عنوان وهمي
                  Container(
                    height: 18,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(9),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // وصف وهمي
                  Container(
                    height: 14,
                    width: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey[250],
                      borderRadius: BorderRadius.circular(7),
                    ),
                  ),
                  const Spacer(),
                  // زر وهمي
                  Container(
                    height: 48,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}