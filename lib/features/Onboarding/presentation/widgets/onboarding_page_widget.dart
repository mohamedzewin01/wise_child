// // lib/features/onboarding/presentation/widgets/onboarding_page_widget.dart
// import 'package:flutter/material.dart';
// import 'package:wise_child/core/resources/style_manager.dart';
//
// class OnboardingPageWidget extends StatefulWidget {
//   final String image;
//   final String title;
//   final String subtitle;
//   final int pageIndex;
//
//   const OnboardingPageWidget({
//     super.key,
//     required this.image,
//     required this.title,
//     required this.subtitle,
//     required this.pageIndex,
//   });
//
//   @override
//   State<OnboardingPageWidget> createState() => _OnboardingPageWidgetState();
// }
//
// class _OnboardingPageWidgetState extends State<OnboardingPageWidget>
//     with TickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _scaleAnimation;
//   late Animation<double> _fadeAnimation;
//   late Animation<Offset> _slideAnimation;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(milliseconds: 1200),
//       vsync: this,
//     );
//
//     _scaleAnimation = Tween<double>(
//       begin: 0.5,
//       end: 1.0,
//     ).animate(CurvedAnimation(
//       parent: _controller,
//       curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
//     ));
//
//     _fadeAnimation = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(CurvedAnimation(
//       parent: _controller,
//       curve: const Interval(0.3, 1.0, curve: Curves.easeInOut),
//     ));
//
//     _slideAnimation = Tween<Offset>(
//       begin: const Offset(0, 0.5),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(
//       parent: _controller,
//       curve: const Interval(0.4, 1.0, curve: Curves.easeOutBack),
//     ));
//
//     _controller.forward();
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 40),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           // Image with animations
//           ScaleTransition(
//             scale: _scaleAnimation,
//             child: Container(
//               width: 300,
//               height: 300,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(150),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.white.withOpacity(0.2),
//                     blurRadius: 30,
//                     spreadRadius: 10,
//                   ),
//                 ],
//               ),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(150),
//                 child: Image.asset(
//                   widget.image,
//                   fit: BoxFit.cover,
//                   errorBuilder: (context, error, stackTrace) {
//                     return Container(
//                       decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                           begin: Alignment.topLeft,
//                           end: Alignment.bottomRight,
//                           colors: [
//                             Colors.purple.withOpacity(0.3),
//                             Colors.blue.withOpacity(0.3),
//                           ],
//                         ),
//                         borderRadius: BorderRadius.circular(150),
//                       ),
//                       child: Icon(
//                         _getIconForPage(widget.pageIndex),
//                         size: 100,
//                         color: Colors.white,
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ),
//           ),
//
//           const SizedBox(height: 60),
//
//           // Title with slide animation
//           SlideTransition(
//             position: _slideAnimation,
//             child: FadeTransition(
//               opacity: _fadeAnimation,
//               child: Text(
//                 widget.title,
//                 textAlign: TextAlign.center,
//                 style: getBoldStyle(
//                   fontSize: 28,
//                   color: Colors.white,
//                 ).copyWith(
//                   shadows: [
//                     Shadow(
//                       offset: const Offset(0, 2),
//                       blurRadius: 4,
//                       color: Colors.black.withOpacity(0.3),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//
//           const SizedBox(height: 20),
//
//           // Subtitle with slide animation
//           SlideTransition(
//             position: _slideAnimation,
//             child: FadeTransition(
//               opacity: _fadeAnimation,
//               child: Text(
//                 widget.subtitle,
//                 textAlign: TextAlign.center,
//                 style: getRegularStyle(
//                   fontSize: 16,
//                   color: Colors.white.withOpacity(0.9),
//                 ).copyWith(
//                   height: 1.5,
//                   shadows: [
//                     Shadow(
//                       offset: const Offset(0, 1),
//                       blurRadius: 2,
//                       color: Colors.black.withOpacity(0.2),
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
//
//   IconData _getIconForPage(int pageIndex) {
//     switch (pageIndex) {
//       case 0:
//         return Icons.auto_stories;
//       case 1:
//         return Icons.psychology;
//       case 2:
//         return Icons.volume_up;
//       default:
//         return Icons.star;
//     }
//   }
// }
//
// // lib/features/onboarding/presentation/widgets/page_indicator.dart
// class PageIndicator extends StatelessWidget {
//   final int currentPage;
//   final int totalPages;
//
//   const PageIndicator({
//     super.key,
//     required this.currentPage,
//     required this.totalPages,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: List.generate(
//         totalPages,
//             (index) => AnimatedContainer(
//           duration: const Duration(milliseconds: 300),
//           margin: const EdgeInsets.symmetric(horizontal: 4),
//           width: currentPage == index ? 30 : 10,
//           height: 10,
//           decoration: BoxDecoration(
//             color: currentPage == index
//                 ? Colors.white
//                 : Colors.white.withOpacity(0.3),
//             borderRadius: BorderRadius.circular(5),
//             boxShadow: currentPage == index
//                 ? [
//               BoxShadow(
//                 color: Colors.white.withOpacity(0.5),
//                 blurRadius: 10,
//                 spreadRadius: 2,
//               ),
//             ]
//                 : null,
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// // lib/features/onboarding/presentation/widgets/animated_background.dart
// class AnimatedBackground extends StatefulWidget {
//   const AnimatedBackground({super.key});
//
//   @override
//   State<AnimatedBackground> createState() => _AnimatedBackgroundState();
// }
//
// class _AnimatedBackgroundState extends State<AnimatedBackground>
//     with TickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _animation1;
//   late Animation<double> _animation2;
//   late Animation<double> _animation3;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(seconds: 20),
//       vsync: this,
//     )..repeat();
//
//     _animation1 = Tween<double>(
//       begin: 0,
//       end: 1,
//     ).animate(CurvedAnimation(
//       parent: _controller,
//       curve: Curves.easeInOut,
//     ));
//
//     _animation2 = Tween<double>(
//       begin: 0,
//       end: 1,
//     ).animate(CurvedAnimation(
//       parent: _controller,
//       curve: const Interval(0.3, 1.0, curve: Curves.easeInOut),
//     ));
//
//     _animation3 = Tween<double>(
//       begin: 0,
//       end: 1,
//     ).animate(CurvedAnimation(
//       parent: _controller,
//       curve: const Interval(0.6, 1.0, curve: Curves.easeInOut),
//     ));
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: const BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [
//             Color(0xFF667eea),
//             Color(0xFF764ba2),
//             Color(0xFFf093fb),
//             Color(0xFFf5576c),
//           ],
//         ),
//       ),
//       child: AnimatedBuilder(
//         animation: _controller,
//         builder: (context, child) {
//           return Stack(
//             children: [
//               // Floating circles
//               Positioned(
//                 top: 100 + (_animation1.value * 50),
//                 left: 50 + (_animation1.value * 30),
//                 child: _buildFloatingCircle(
//                   size: 60,
//                   color: Colors.white.withOpacity(0.1),
//                 ),
//               ),
//               Positioned(
//                 top: 200 + (_animation2.value * 80),
//                 right: 80 + (_animation2.value * 40),
//                 child: _buildFloatingCircle(
//                   size: 40,
//                   color: Colors.white.withOpacity(0.15),
//                 ),
//               ),
//               Positioned(
//                 bottom: 150 + (_animation3.value * 60),
//                 left: 100 + (_animation3.value * 20),
//                 child: _buildFloatingCircle(
//                   size: 80,
//                   color: Colors.white.withOpacity(0.08),
//                 ),
//               ),
//               Positioned(
//                 bottom: 300 + (_animation1.value * 40),
//                 right: 50 + (_animation1.value * 25),
//                 child: _buildFloatingCircle(
//                   size: 50,
//                   color: Colors.white.withOpacity(0.12),
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildFloatingCircle({
//     required double size,
//     required Color color,
//   }) {
//     return Container(
//       width: size,
//       height: size,
//       decoration: BoxDecoration(
//         color: color,
//         shape: BoxShape.circle,
//       ),
//     );
//   }
// }
