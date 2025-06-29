import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'package:wise_child/features/Stories/presentation/bloc/ChildrenStoriesCubit/children_stories_cubit.dart';

class StoriesEmptyState extends StatelessWidget {
  final AnimationController controller;
  final AnimationController refreshController;

  const StoriesEmptyState({
    super.key,
    required this.controller,
    required this.refreshController,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Transform.scale(
          scale: 0.8 + (0.2 * controller.value),
          child: Opacity(
            opacity: controller.value,
            child: Center(
              child: Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
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
                      blurRadius: 25,
                      offset: const Offset(0, 15),
                    ),
                    BoxShadow(
                      color: ColorManager.primaryColor.withOpacity(0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 5),
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // الأيقونة المتحركة
                    _buildAnimatedIcon(),

                    const SizedBox(height: 24),

                    // العنوان
                    _buildTitle(),

                    const SizedBox(height: 12),

                    // الوصف
                    _buildDescription(),

                    const SizedBox(height: 24),

                    // زر إعادة التحميل
                    _buildRefreshButton(context),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedIcon() {
    return TweenAnimationBuilder<double>(
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
              size: 60,
              color: ColorManager.primaryColor,
            ),
          ),
        );
      },
    );
  }

  Widget _buildTitle() {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        colors: [
          ColorManager.primaryColor,
          Colors.purple.shade400,
        ],
      ).createShader(bounds),
      child: Text(
        'لا توجد قصص',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          letterSpacing: 0.5,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildDescription() {
    return Container(
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
    );
  }

  Widget _buildRefreshButton(BuildContext context) {
    return AnimatedBuilder(
      animation: refreshController,
      builder: (context, child) {
        return Transform.rotate(
          angle: refreshController.value * 2 * 3.14159,
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
                  refreshController.forward().then((_) {
                    refreshController.reset();
                  });
                  await context.read<ChildrenStoriesCubit>().getStoriesChildren();
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'إعادة التحميل',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),

                ),
              ),
            ),
          ),
        );
      },
    );
  }
}