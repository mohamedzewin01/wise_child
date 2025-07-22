

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wise_child/core/resources/cashed_image.dart';
import 'package:wise_child/core/resources/color_manager.dart';


import 'dart:math' as math;

import 'package:wise_child/features/StoriesPlay/presentation/widgets/floating_particles.dart';

class StoryPageView extends StatefulWidget {
  final String imageUrl;
  final String text;
  final int pageIndex;
  final int totalPages;

  const StoryPageView({
    super.key,
    required this.imageUrl,
    required this.text,
    required this.pageIndex,
    required this.totalPages,
  });

  @override
  State<StoryPageView> createState() => _StoryPageViewState();
}

class _StoryPageViewState extends State<StoryPageView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // فحص إذا كان هناك نص
    bool hasText = widget.text.isNotEmpty;

    return Stack(
      fit: StackFit.expand,
      children: [
        // صورة الخلفية
        Hero(
          tag: 'story_image_${widget.pageIndex}',
          child: widget.imageUrl.isNotEmpty
              ? CustomImage(
            url: widget.imageUrl,
            width: double.infinity,
            height: double.infinity,
          )
              : Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  ColorManager.primaryColor,
                  Colors.purple.shade400,
                  Colors.indigo.shade500,
                ],
              ),
            ),
            child: Center(
              child: Icon(
                Icons.auto_stories_rounded,
                size: 120,
                color: Colors.white.withOpacity(0.3),
              ),
            ),
          ),
        ),

        // تأثير التدرج للنص - يظهر فقط إذا كان هناك نص
        if (hasText)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.4,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.7),
                    Colors.black.withOpacity(0.9),
                  ],
                  stops: const [0.0, 0.3, 0.7, 1.0],
                ),
              ),
            ),
          ),

        // نص القصة مع أنيميشن - يظهر فقط إذا كان هناك نص
        if (hasText)
          Positioned(
            bottom: 180,
            left: 20,
            right: 20,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    // color: Colors.black.withOpacity(0.3),
                    // borderRadius: BorderRadius.circular(20),
                    // border: Border.all(
                    //   color: Colors.white.withOpacity(0.2),
                    //   width: 1,
                    // ),
                  ),
                  child: Column(
                    children: [
                      // مؤشر الصفحة
                      Container(
                        margin: const EdgeInsets.only(bottom: 15),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          '${widget.pageIndex + 1} من ${widget.totalPages}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      // نص القصة
                      Text(
                        widget.text,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          height: 1.8,
                          letterSpacing: 0.5,
                          shadows: [
                            Shadow(
                              blurRadius: 10.0,
                              color: Colors.black87,
                              offset: Offset(2.0, 2.0),
                            ),
                            Shadow(
                              blurRadius: 6.0,
                              color: Colors.black54,
                              offset: Offset(1.0, 1.0),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

        // تأثيرات بصرية إضافية
        FloatingParticles(animationController: _animationController)

      ],
    );
  }


}