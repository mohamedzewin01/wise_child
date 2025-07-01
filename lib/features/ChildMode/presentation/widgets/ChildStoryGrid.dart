// // lib/features/ChildMode/presentation/widgets/child_story_grid.dart
//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:wise_child/core/api/api_constants.dart';
// import 'package:wise_child/core/resources/cashed_image.dart';
// import 'package:wise_child/features/Stories/data/models/response/children_stories_model_dto.dart';
// import 'package:wise_child/features/Stories/presentation/bloc/ChildrenStoriesCubit/children_stories_cubit.dart';
// import 'package:wise_child/features/StoriesPlay/presentation/pages/StoriesPlay_page.dart';
// import 'dart:math' as math;
//
// class ChildStoryGrid extends StatefulWidget {
//   const ChildStoryGrid({super.key});
//
//   @override
//   State<ChildStoryGrid> createState() => _ChildStoryGridState();
// }
//
// class _ChildStoryGridState extends State<ChildStoryGrid>
//     with TickerProviderStateMixin {
//   late AnimationController _staggerController;
//   late AnimationController _pulseController;
//
//   @override
//   void initState() {
//     super.initState();
//
//     _staggerController = AnimationController(
//       duration: const Duration(milliseconds: 1500),
//       vsync: this,
//     );
//
//     _pulseController = AnimationController(
//       duration: const Duration(seconds: 2),
//       vsync: this,
//     );
//
//     _staggerController.forward();
//     _pulseController.repeat(reverse: true);
//   }
//
//   @override
//   void dispose() {
//     _staggerController.dispose();
//     _pulseController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<ChildrenStoriesCubit, ChildrenStoriesState>(
//       builder: (context, state) {
//         if (state is ChildrenStoriesLoading) {
//           return _buildLoadingGrid();
//         }
//
//         if (state is ChildrenStoriesSuccess) {
//           final stories = state.getChildrenEntity?.data ?? [];
//
//           if (stories.isEmpty) {
//             return _buildEmptyState();
//           }
//
//           return _buildStoriesGrid(stories);
//         }
//
//         if (state is ChildrenStoriesFailure) {
//           return _buildErrorState();
//         }
//
//         return _buildLoadingGrid();
//       },
//     );
//   }
//
//   Widget _buildStoriesGrid(List<StoriesModeData> stories) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 15),
//       child: GridView.builder(
//         physics: const BouncingScrollPhysics(),
//         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2,
//           childAspectRatio: 0.75,
//           crossAxisSpacing: 15,
//           mainAxisSpacing: 15,
//         ),
//         itemCount: stories.length,
//         itemBuilder: (context, index) {
//           return AnimatedBuilder(
//             animation: _staggerController,
//             builder: (context, child) {
//               final delay = (index * 0.1).clamp(0.0, 1.0);
//               final slideAnimation = Tween<Offset>(
//                 begin: const Offset(0, 0.5),
//                 end: Offset.zero,
//               ).animate(CurvedAnimation(
//                 parent: _staggerController,
//                 curve: Interval(delay, (delay + 0.5).clamp(0.0, 1.0),
//                     curve: Curves.elasticOut),
//               ));
//
//               final fadeAnimation = Tween<double>(
//                 begin: 0.0,
//                 end: 1.0,
//               ).animate(CurvedAnimation(
//                 parent: _staggerController,
//                 curve: Interval(delay, (delay + 0.3).clamp(0.0, 1.0),
//                     curve: Curves.easeOut),
//               ));
//
//               return FadeTransition(
//                 opacity: fadeAnimation,
//                 child: SlideTransition(
//                   position: slideAnimation,
//                   child: ChildStoryCard(
//                     story: stories[index],
//                     index: index,
//                     pulseAnimation: _pulseController,
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildEmptyState() {
//     return Center(
//         child: Container(
//         margin: const EdgeInsets.all(20)
//     ,
//     padding
//     :
//     const
//     EdgeInsets
//     .
//     all
//     (
//     30
//     )
//     ,
//     decoration
//     :
//     BoxDecoration
//     (
//     gradient
//     :
//     LinearGradient
//     (
//     colors
//     :
//     [
//     Colors
//     .
//     blue
//     .
//     shade100
//     ,
//     Colors
//     .
//     purple
//     .
//     shade100
//     ,
//     ]
//     ,
//     )
//     ,
//     borderRadius
//     :
//     BorderRadius
//     .
//     circular
//     (
//     30
//     )
//     ,
//     boxShadow
//     :
//     [
//     BoxShadow
//     (
//     color
//     :
//     Colors
//     .
//     blue
//     .
//     withOpacity
//     (
//     0.2
//     )
//     ,
//     blurRadius
//     :
//     20
//     ,
//     offset
//     :
//     const
//     Offset
//     (
//     0
//     ,
//     10
//     )
//     ,
//     )
//     ,
//     ]
//     ,
//     )
//     ,
//     child
//     :
//     Column
//     (
//     mainAxisSize
//     :
//     MainAxisSize
//     .
//     min
//     ,
//     children
//     :
//     [
//     AnimatedBuilder
//     (
//     animation
//     :
//     _pulseController
//     ,
//     builder
//     :
//     (
//     context
//     ,
//     child
//     ) {
//     return Transform.scale(
//     scale: 1.0 + (_pulseController.value * 0.1),
//     child: Container(
//     padding: const EdgeInsets.all(20),
//     decoration: BoxDecoration(
//     gradient: LinearGradient(
//     colors: [
//     Colors.orange.shade200,
//     Colors.pink.shade200,
//     ],
//     ),
//     ),
//     ),
//     ),
//     );
//     },
//     )
//     ,
//     );
//   }
//
//   Widget _buildPlaceholderImage(List<Color> colors) {
//     return Container(
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: colors,
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//       ),
//       child: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               Icons.auto_stories_rounded,
//               size: 50,
//               color: Colors.white.withOpacity(0.8),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'قصة مثيرة!',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 16,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildBadge(String text, IconData icon, Color color) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.9),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(
//           color: color.withOpacity(0.3),
//           width: 1,
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: color.withOpacity(0.2),
//             blurRadius: 4,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(icon, size: 12, color: color),
//           const SizedBox(width: 4),
//           Text(
//             text,
//             style: TextStyle(
//               fontSize: 10,
//               fontWeight: FontWeight.bold,
//               color: color,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildFloatingStar(int index) {
//     return AnimatedBuilder(
//       animation: widget.pulseAnimation,
//       builder: (context, child) {
//         final offset = (widget.pulseAnimation.value + index * 0.2) % 1.0;
//         final xPos = 20.0 + (index * 25.0) +
//             math.sin(offset * 2 * math.pi) * 10;
//         final yPos = 30.0 +
//             math.cos(offset * 2 * math.pi) * 15;
//
//         return Positioned(
//           left: xPos,
//           top: yPos,
//           child: Transform.rotate(
//             angle: offset * 2 * math.pi,
//             child: Icon(
//               Icons.star_rounded,
//               size: 8 + (index % 3) * 3,
//               color: Colors.yellow.shade300.withOpacity(0.6),
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   List<Color> _getCardColors(int index) {
//     final colorSets = [
//       [Colors.pink.shade300, Colors.purple.shade300],
//       [Colors.blue.shade300, Colors.cyan.shade300],
//       [Colors.green.shade300, Colors.teal.shade300],
//       [Colors.orange.shade300, Colors.red.shade300],
//       [Colors.yellow.shade300, Colors.amber.shade300],
//       [Colors.indigo.shade300, Colors.blue.shade400],
//       [Colors.lime.shade300, Colors.green.shade400],
//       [Colors.deepPurple.shade300, Colors.purple.shade400],
//     ];
//     return colorSets[index % colorSets.length];
//   }
//
//   void _navigateToStory() {
//     Navigator.push(
//       context,
//       PageRouteBuilder(
//         pageBuilder: (context, animation, secondaryAnimation) =>
//             StoriesPlayPage(
//               childId: widget.story.childrenId ?? 0,
//               storyId: widget.story.storyId ?? 0,
//             ),
//         transitionsBuilder: (context, animation, secondaryAnimation, child) {
//           return SlideTransition(
//             position: Tween<Offset>(
//               begin: const Offset(1.0, 0.0),
//               end: Offset.zero,
//             ).animate(CurvedAnimation(
//               parent: animation,
//               curve: Curves.easeInOutCubic,
//             )),
//             child: FadeTransition(
//               opacity: animation,
//               child: child,
//             ),
//           );
//         },
//         transitionDuration: const Duration(milliseconds: 600),
//       ),
//     );
//   }
// }),
// shape: BoxShape.circle,)
// ,
// child: Icon
// (
// Icons.menu_book_rounded,
// size: 60,
// color: Colors.white,
// ),
// ),
// );
// },
// ),
//
// const SizedBox(height: 25),
//
// Text(
// 'لا توجد قصص متاحة! 😔',
// style: TextStyle(
// fontSize: 22,
// fontWeight: FontWeight.bold,
// color: Colors.blue.shade700,
// ),
// ),
//
// const SizedBox(height: 10),
//
// Text(
// 'اطلب من والديك إضافة قصص ممتعة لك! 📚✨',
// style: TextStyle(
// fontSize: 16,
// color: Colors.grey.shade600,
// ),
// textAlign: TextAlign.center,
// ),
//
// const SizedBox(height: 25),
//
// // زر إعادة التحميل مع تصميم مرح
// GestureDetector(
// onTap: () {
// HapticFeedback.lightImpact();
// context.read<ChildrenStoriesCubit>().getStoriesChildren();
// },
// child: Container(
// padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
// decoration: BoxDecoration(
// gradient: LinearGradient(
// colors: [
// Colors.green.shade300,
// Colors.blue.shade300,
// ],
// ),
// borderRadius: BorderRadius.circular(20),
// boxShadow: [
// BoxShadow(
// color: Colors.green.withOpacity(0.3),
// blurRadius: 10,
// offset: const Offset(0, 5),
// ),
// ],
// ),
// child: Row(
// mainAxisSize: MainAxisSize.min,
// children: [
// Icon(
// Icons.refresh_rounded,
// color: Colors.white,
// size: 20,
// ),
// const SizedBox(width: 8),
// Text(
// 'حاول مرة أخرى!',
// style: TextStyle(
// color: Colors.white,
// fontWeight: FontWeight.bold,
// fontSize: 16,
// ),
// ),
// ],
// ),
// ),
// ),
// ],
// ),
// ),
// );
// }
//
// Widget _buildErrorState() {
// return Center(
// child: Container(
// margin: const EdgeInsets.all(20),
// padding: const EdgeInsets.all(30),
// decoration: BoxDecoration(
// gradient: LinearGradient(
// colors: [
// Colors.red.shade100,
// Colors.orange.shade100,
// ],
// ),
// borderRadius: BorderRadius.circular(30),
// ),
// child: Column(
// mainAxisSize: MainAxisSize.min,
// children: [
// Icon(
// Icons.error_outline_rounded,
// size: 60,
// color: Colors.red.shade400,
// ),
// const SizedBox(height: 20),
// Text(
// 'عذراً! حدث خطأ 😅',
// style: TextStyle(
// fontSize: 20,
// fontWeight: FontWeight.bold,
// color: Colors.red.shade600,
// ),
// ),
// const SizedBox(height: 10),
// Text(
// 'تأكد من الاتصال بالإنترنت وحاول مرة أخرى',
// style: TextStyle(
// fontSize: 14,
// color: Colors.grey.shade600,
// ),
// textAlign: TextAlign.center,
// ),
// ],
// ),
// ),
// );
// }
//
// Widget _buildLoadingGrid() {
// return Padding(
// padding: const EdgeInsets.all(15),
// child: GridView.builder(
// gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
// crossAxisCount: 2,
// childAspectRatio: 0.75,
// crossAxisSpacing: 15,
// mainAxisSpacing: 15,
// ),
// itemCount: 6,
// itemBuilder: (context, index) {
// return _buildLoadingCard(index);
// },
// ),
// );
// }
//
// Widget _buildLoadingCard(int index) {
// return AnimatedBuilder(
// animation: _pulseController,
// builder: (context, child) {
// final opacity = 0.3 + (_pulseController.value * 0.3);
// return Container(
// decoration: BoxDecoration(
// color: Colors.grey.shade200.withOpacity(opacity),
// borderRadius: BorderRadius.circular(25),
// ),
// child: Column(
// children: [
// Expanded(
// flex: 3,
// child: Container(
// decoration: BoxDecoration(
// color: Colors.grey.shade300.withOpacity(opacity),
// borderRadius: const BorderRadius.vertical(
// top: Radius.circular(25),
// ),
// ),
// ),
// ),
// Expanded(
// flex: 1,
// child: Padding(
// padding: const EdgeInsets.all(10),
// child: Column(
// children: [
// Container(
// height: 15,
// decoration: BoxDecoration(
// color: Colors.grey.shade300.withOpacity(opacity),
// borderRadius: BorderRadius.circular(8),
// ),
// ),
// const SizedBox(height: 8),
// Container(
// height: 25,
// decoration: BoxDecoration(
// color: Colors.grey.shade400.withOpacity(opacity),
// borderRadius: BorderRadius.circular(15),
// ),
// ),
// ],
// ),
// ),
// ),
// ],
// ),
// );
// },
// );
// }
// }
//
// class ChildStoryCard extends StatefulWidget {
// final StoriesModeData story;
// final int index;
// final AnimationController pulseAnimation;
//
// const ChildStoryCard({
// super.key,
// required this.story,
// required this.index,
// required this.pulseAnimation,
// });
//
// @override
// State<ChildStoryCard> createState() => _ChildStoryCardState();
// }
//
// class _ChildStoryCardState extends State<ChildStoryCard>
// with SingleTickerProviderStateMixin {
// late AnimationController _hoverController;
// bool _isPressed = false;
//
// @override
// void initState() {
// super.initState();
// _hoverController = AnimationController(
// duration: const Duration(milliseconds: 200),
// vsync: this,
// );
// }
//
// @override
// void dispose() {
// _hoverController.dispose();
// super.dispose();
// }
//
// @override
// Widget build(BuildContext context) {
// final cardColors = _getCardColors(widget.index);
//
// return GestureDetector(
// onTapDown: (_) {
// setState(() => _isPressed = true);
// _hoverController.forward();
// HapticFeedback.lightImpact();
// },
// onTapUp: (_) {
// setState(() => _isPressed = false);
// _hoverController.reverse();
// _navigateToStory();
// },
// onTapCancel: () {
// setState(() => _isPressed = false);
// _hoverController.reverse();
// },
// child: AnimatedBuilder(
// animation: Listenable.merge([_hoverController, widget.pulseAnimation]),
// builder: (context, child) {
// final scale = _isPressed ? 0.95 : 1.0;
// final glowIntensity = widget.pulseAnimation.value;
//
// return Transform.scale(
// scale: scale,
// child: Container(
// decoration: BoxDecoration(
// borderRadius: BorderRadius.circular(25),
// boxShadow: [
// BoxShadow(
// color: cardColors[0].withOpacity(0.3 + glowIntensity * 0.2),
// blurRadius: 15 + glowIntensity * 10,
// offset: const Offset(0, 8),
// spreadRadius: 2 + glowIntensity * 3,
// ),
// BoxShadow(
// color: Colors.white.withOpacity(0.8),
// blurRadius: 5,
// offset: const Offset(0, -2),
// spreadRadius: -2,
// ),
// ],
// ),
// child: ClipRRect(
// borderRadius: BorderRadius.circular(25),
// child: Container(
// decoration: BoxDecoration(
// gradient: LinearGradient(
// begin: Alignment.topLeft,
// end: Alignment.bottomRight,
// colors: [
// Colors.white,
// cardColors[0].withOpacity(0.1),
// cardColors[1].withOpacity(0.1),
// ],
// ),
// ),
// child: Stack(
// children: [
// // صورة القصة
// Positioned.fill(
// child: Column(
// children: [
// // منطقة الصورة
// Expanded(
// flex: 3,
// child: Container(
// width: double.infinity,
// decoration: BoxDecoration(
// gradient: LinearGradient(
// colors: cardColors,
// begin: Alignment.topLeft,
// end: Alignment.bottomRight,
// ),
// ),
// child: widget.story.imageCover != null &&
// widget.story.imageCover!.isNotEmpty
// ? ClipRRect(
// child: CustomImage(
// url: '${ApiConstants.urlImage}${widget.story.imageCover}',
// height: double.infinity,
// width: double.infinity,
// ),
// )
//     : _buildPlaceholderImage(cardColors),
// ),
// ),
//
// // منطقة النص والزر
// Expanded(
// flex: 1,
// child: Container(
// width: double.infinity,
// padding: const EdgeInsets.all(12),
// decoration: BoxDecoration(
// gradient: LinearGradient(
// colors: [
// Colors.white,
// cardColors[0].withOpacity(0.05),
// ],
// begin: Alignment.topCenter,
// end: Alignment.bottomCenter,
// ),
// ),
// child: Column(
// mainAxisAlignment: MainAxisAlignment.center,
// children: [
// // عنوان القصة
// Text(
// widget.story.storyTitle ?? 'قصة ممتعة',
// style: TextStyle(
// fontSize: 14,
// fontWeight: FontWeight.bold,
// color: cardColors[1],
// ),
// maxLines: 1,
// overflow: TextOverflow.ellipsis,
// textAlign: TextAlign.center,
// ),
//
// const SizedBox(height: 8),
//
// // زر التشغيل المرح
// Container(
// width: double.infinity,
// height: 35,
// decoration: BoxDecoration(
// gradient: LinearGradient(
// colors: cardColors,
// ),
// borderRadius: BorderRadius.circular(20),
// boxShadow: [
// BoxShadow(
// color: cardColors[0].withOpacity(0.4),
// blurRadius: 8,
// offset: const Offset(0, 4),
// ),
// ],
// ),
// child: Row(
// mainAxisAlignment: MainAxisAlignment.center,
// children: [
// Icon(
// Icons.play_arrow_rounded,
// color: Colors.white,
// size: 20,
// ),
// const SizedBox(width: 5),
// Text(
// 'شغّل الآن!',
// style: TextStyle(
// color: Colors.white,
// fontWeight: FontWeight.bold,
// fontSize: 12,
// ),
// ),
// ],
// ),
// ),
// ],
// ),
// ),
// ),
// ],
// ),
// ),
//
// // أيقونة التشغيل العائمة
// Positioned(
// top: 8,
// right: 8,
// child: AnimatedBuilder(
// animation: widget.pulseAnimation,
// builder: (context, child) {
// return Transform.scale(
// scale: 1.0 + (widget.pulseAnimation.value * 0.1),
// child: Container(
// padding: const EdgeInsets.all(8),
// decoration: BoxDecoration(
// gradient: LinearGradient(
// colors: [
// Colors.white,
// Colors.white.withOpacity(0.9),
// ],
// ),
// shape: BoxShape.circle,
// boxShadow: [
// BoxShadow(
// color: Colors.black.withOpacity(0.2),
// blurRadius: 10,
// offset: const Offset(0, 4),
// ),
// ],
// ),
// child: Icon(
// Icons.play_circle_filled,
// color: cardColors[0],
// size: 25,
// ),
// ),
// );
// },
// ),
// ),
//
// // شارة العمر والفئة
// Positioned(
// top: 8,
// left: 8,
// child: Column(
// children: [
// if (widget.story.ageGroup != null)
// _buildBadge(
// '${widget.story.ageGroup} سنة',
// Icons.child_care_rounded,
// cardColors[0],
// ),
// if (widget.story.categoryName != null)
// Padding(
// padding: const EdgeInsets.only(top: 4),
// child: _buildBadge(
// widget.story.categoryName!,
// Icons.category_rounded,
// cardColors[1],
// ),
// ),
// ],
// ),
// ),
//
// // تأثير النجوم المتحركة
// // تأثير النجوم المتحركة
// ...List.generate(5, (index) => _buildFloatingStar(index)),
// ],
// ),
// ),
// ),
// );
// },
// ),
// );
// }
//
// List<Color> _getCardColors(int index) {
// final colorSets = [
// [Colors.pink.shade300, Colors.purple.shade300],
// [Colors.blue.shade300, Colors.cyan.shade300],
// [Colors.green.shade300, Colors.teal.shade300],
// [Colors.orange.shade300, Colors.red.shade300],
// [Colors.yellow.shade300, Colors.amber.shade300],
// [Colors.indigo.shade300, Colors.blue.shade400],
// [Colors.lime.shade300, Colors.green.shade400],
// [Colors.deepPurple.shade300, Colors.purple.shade400],
// ];
// return colorSets[index % colorSets.length];
// }
//
// void _navigateToStory() {
// Navigator.push(
// context,
// PageRouteBuilder(
// pageBuilder: (context, animation, secondaryAnimation) => StoriesPlayPage(
// childId: widget.story.childrenId ?? 0,
// storyId: widget.story.storyId ?? 0,
// ),
// transitionsBuilder: (context, animation, secondaryAnimation, child) {
// return SlideTransition(
// position: Tween<Offset>(
// begin: const Offset(1.0, 0.0),
// end: Offset.zero,
// ).animate(CurvedAnimation(
// parent: animation,
// curve: Curves.easeInOutCubic,
// )),
// child: FadeTransition(
// opacity: animation,
// child: child,
// ),
// );
// },
// transitionDuration: const Duration(milliseconds: 600),
// ),
// );
// }
// }
