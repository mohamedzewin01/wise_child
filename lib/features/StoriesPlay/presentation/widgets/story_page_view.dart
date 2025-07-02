//
//
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:wise_child/core/resources/cashed_image.dart';
// import '../../data/models/response/story_play_dto.dart';
// import '../pages/StoriesPlay_page.dart';
// import 'story_controls.dart';
//
// class StoryPageView extends StatelessWidget {
//   final String imageUrl;
//   final String text;
//
//   const StoryPageView({
//     super.key,
//     required this.imageUrl,
//     required this.text
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return ClipRRect(
//       child: Stack(
//         fit: StackFit.expand,
//         children: [
//           // Background image
//           CustomImage(
//               url: imageUrl
//           ),
//
//           // Gradient overlay for better text readability
//           Positioned(
//             bottom: 0,
//             left: 0,
//             right: 0,
//             child: Container(
//               height: 250,
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                   colors: [
//                     Colors.transparent,
//                     Colors.black.withOpacity(0.3),
//                     Colors.black.withOpacity(0.8)
//                   ],
//                   stops: const [0.0, 0.5, 1.0],
//                 ),
//               ),
//             ),
//           ),
//
//           // Story text
//           Positioned(
//             bottom: 120,
//             left: 20,
//             right: 20,
//             child: Container(
//               padding: const EdgeInsets.all(16),
//               child: Text(
//                 text,
//                 textAlign: TextAlign.center,
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 20,
//                   fontWeight: FontWeight.w600,
//                   height: 1.6,
//                   fontFamily: 'Cairo', // Use Arabic font if available
//                   shadows: [
//                     Shadow(
//                       blurRadius: 8.0,
//                       color: Colors.black87,
//                       offset: Offset(1.0, 1.0),
//                     ),
//                     Shadow(
//                       blurRadius: 4.0,
//                       color: Colors.black54,
//                       offset: Offset(0.5, 0.5),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // StoryScreen widget that handles the PageView and auto-play
// class StoryScreen extends StatefulWidget {
//   final List<Clips> storyPages;
//
//   const StoryScreen({
//     super.key,
//     required this.storyPages,
//   });
//
//   @override
//   State<StoryScreen> createState() => _StoryScreenState();
// }
//
// class _StoryScreenState extends State<StoryScreen> {
//   late PageController _pageController;
//   late StoryCubit _storyCubit;
//   int _lastCurrentPage = 0; // متغير لتتبع آخر صفحة
//
//   @override
//   void initState() {
//     super.initState();
//     _pageController = PageController();
//     // Initialize StoryCubit with auto-play enabled
//     _storyCubit = StoryCubit(widget.storyPages, autoPlay: true);
//   }
//
//   @override
//   void dispose() {
//     _pageController.dispose();
//     _storyCubit.close();
//     super.dispose();
//   }
//
//   void _scrollToPage(int pageIndex) {
//     if (_pageController.hasClients &&
//         pageIndex != _lastCurrentPage &&
//         pageIndex >= 0 &&
//         pageIndex < widget.storyPages.length) {
//
//       _lastCurrentPage = pageIndex;
//
//       // استخدام animateToPage لضمان التحديث السلس
//       _pageController.animateToPage(
//         pageIndex,
//         duration: const Duration(milliseconds: 500),
//         curve: Curves.easeInOut,
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider<StoryCubit>(
//       create: (context) => _storyCubit,
//       child: Scaffold(
//         backgroundColor: Colors.black,
//         body: BlocConsumer<StoryCubit, StoryState>(
//           listener: (context, state) {
//             // تحديث الصفحة عند تغير المقطع الصوتي
//             if (state.currentPage != _lastCurrentPage) {
//               print('Changing to page: ${state.currentPage}');
//               _scrollToPage(state.currentPage);
//             }
//           },
//           builder: (context, state) {
//             return Stack(
//               children: [
//                 // PageView for story pages
//                 PageView.builder(
//                   controller: _pageController,
//                   itemCount: widget.storyPages.length,
//                   onPageChanged: (index) {
//                     // عدم تحديث الـ cubit إذا كان التغيير تلقائي من الصوت
//                     if (index != state.currentPage) {
//                       print('Manual page change to: $index');
//                       context.read<StoryCubit>().pageChanged(index);
//                       _lastCurrentPage = index;
//                     }
//                   },
//                   itemBuilder: (context, index) {
//                     final clip = widget.storyPages[index];
//                     return StoryPageView(
//                       imageUrl: clip.imageUrl ?? '',
//                       text: clip.clipText ?? '',
//                     );
//                   },
//                 ),
//
//                 // Story controls overlay
//                 const Positioned(
//                   bottom: 0,
//                   left: 0,
//                   right: 0,
//                   child: StoryControls(),
//                 ),
//
//                 // Back button
//                 Positioned(
//                   top: MediaQuery.of(context).padding.top + 10,
//                   right: 16,
//                   child: Container(
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: Colors.black.withOpacity(0.5),
//                     ),
//                     child: IconButton(
//                        padding: EdgeInsets.only(right: 10),
//                       icon: const Icon(
//                         Icons.arrow_back_ios,
//                         color: Colors.white,
//                       ),
//                       onPressed: () => Navigator.of(context).pop(),
//                     ),
//                   ),
//                 ),
//
//                 // Story finished overlay
//                 if (state.status == PlaybackStatus.finished)
//                   Container(
//                     color: Colors.black.withOpacity(0.7),
//                     child: Center(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           const Icon(
//                             Icons.check_circle,
//                             color: Colors.green,
//                             size: 80,
//                           ),
//                           const SizedBox(height: 20),
//                           const Text(
//                             'انتهت القصة!',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 24,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           const SizedBox(height: 20),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               ElevatedButton(
//                                 onPressed: () async {
//                                   // Replay story من البداية
//                                   _lastCurrentPage = 0;
//
//                                   // إعادة تعيين PageController إلى الصفحة الأولى
//                                   if (_pageController.hasClients) {
//                                     await _pageController.animateToPage(
//                                       0,
//                                       duration: const Duration(milliseconds: 300),
//                                       curve: Curves.easeInOut,
//                                     );
//                                   }
//
//                                   // بدء إعادة التشغيل
//                                   if (context.mounted) {
//                                     context.read<StoryCubit>().restartStory();
//                                   }
//                                 },
//                                 child: const Text('إعادة تشغيل'),
//                               ),
//                               const SizedBox(width: 20),
//                               ElevatedButton(
//                                 onPressed: () => Navigator.of(context).pop(),
//                                 child: const Text('العودة'),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wise_child/core/resources/cashed_image.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import '../../data/models/response/story_play_dto.dart';
import '../pages/StoriesPlay_page.dart';
import 'story_controls.dart';
import 'dart:math' as math;

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

        // تأثير التدرج للنص
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

        // نص القصة مع أنيميشن
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
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1,
                  ),
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
        _buildFloatingParticles(),
      ],
    );
  }

  Widget _buildFloatingParticles() {
    return Positioned.fill(
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Stack(
            children: List.generate(6, (index) {
              final offset = (index * 0.3) % 1.0;
              final animationValue = (_animationController.value + offset) % 1.0;

              return Positioned(
                left: (index % 3) * (MediaQuery.of(context).size.width / 3) +
                    math.sin(animationValue * 2 * math.pi) * 20,
                top: MediaQuery.of(context).size.height * 0.2 +
                    math.cos(animationValue * 2 * math.pi) * 30,
                child: Opacity(
                  opacity: 0.6 * (1 - animationValue),
                  child: Transform.scale(
                    scale: 0.5 + (animationValue * 0.5),
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.7),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.5),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}

