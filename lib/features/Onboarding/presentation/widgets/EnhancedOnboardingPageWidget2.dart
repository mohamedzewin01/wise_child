// import 'package:flutter/material.dart';
// import 'package:wise_child/core/resources/style_manager.dart';
// import 'package:wise_child/features/Onboarding/presentation/pages/OnboardingScreen2.dart';
// import 'dart:math' as math;
//
// import 'package:wise_child/features/Onboarding/presentation/pages/Onboarding_page.dart';
//
// // Enhanced Page Widget with Full Screen Image and Advanced Animations
// class EnhancedOnboardingPageWidget extends StatefulWidget {
//   final OnboardingData data;
//   final int pageIndex;
//   final bool isActive;
//
//   const EnhancedOnboardingPageWidget({
//     super.key,
//     required this.data,
//     required this.pageIndex,
//     required this.isActive,
//   });
//
//   @override
//   State<EnhancedOnboardingPageWidget> createState() => _EnhancedOnboardingPageWidgetState();
// }
//
// class _EnhancedOnboardingPageWidgetState extends State<EnhancedOnboardingPageWidget>
//     with TickerProviderStateMixin {
//
//   // Animation Controllers
//   late AnimationController _imageController;
//   late AnimationController _textController;
//   late AnimationController _zoomController;
//   late AnimationController _parallaxController;
//   late AnimationController _pulseController;
//   late AnimationController _rotationController;
//
//   // Animations
//   late Animation<double> _imageZoomAnimation;
//   late Animation<double> _imageOpacityAnimation;
//   late Animation<double> _imageBreatheAnimation;
//   late Animation<Offset> _parallaxAnimation;
//   late Animation<double> _rotationAnimation;
//
//   late Animation<double> _titleFadeAnimation;
//   late Animation<Offset> _titleSlideAnimation;
//   late Animation<double> _titleScaleAnimation;
//
//   late Animation<double> _subtitleFadeAnimation;
//   late Animation<Offset> _subtitleSlideAnimation;
//   late Animation<double> _subtitleScaleAnimation;
//
//   late Animation<double> _pulseAnimation;
//   late Animation<double> _glowAnimation;
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeAnimations();
//     if (widget.isActive) {
//       _startAnimations();
//     }
//   }
//
//   @override
//   void didUpdateWidget(EnhancedOnboardingPageWidget oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (widget.isActive != oldWidget.isActive) {
//       if (widget.isActive) {
//         _startAnimations();
//       }
//     }
//   }
//
//   void _initializeAnimations() {
//     // Image Animation Controller - for initial entrance
//     _imageController = AnimationController(
//       duration: const Duration(milliseconds: 2000),
//       vsync: this,
//     );
//
//     // Text Animation Controller
//     _textController = AnimationController(
//       duration: const Duration(milliseconds: 1800),
//       vsync: this,
//     );
//
//     // Zoom Controller - for continuous zoom in/out effect
//     _zoomController = AnimationController(
//       duration: const Duration(seconds: 8),
//       vsync: this,
//     )..repeat(reverse: true);
//
//     // Parallax Controller - for subtle movement
//     _parallaxController = AnimationController(
//       duration: const Duration(seconds: 12),
//       vsync: this,
//     )..repeat();
//
//     // Pulse Controller - for pulsing effects
//     _pulseController = AnimationController(
//       duration: const Duration(seconds: 3),
//       vsync: this,
//     )..repeat(reverse: true);
//
//     // Rotation Controller - for subtle rotation
//     _rotationController = AnimationController(
//       duration: const Duration(seconds: 20),
//       vsync: this,
//     )..repeat();
//
//     // Image Animations
//     _imageZoomAnimation = Tween<double>(
//       begin: 1.0,
//       end: 1.15,
//     ).animate(CurvedAnimation(
//       parent: _zoomController,
//       curve: Curves.easeInOut,
//     ));
//
//     _imageOpacityAnimation = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(CurvedAnimation(
//       parent: _imageController,
//       curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
//     ));
//
//     _imageBreatheAnimation = Tween<double>(
//       begin: 0.98,
//       end: 1.02,
//     ).animate(CurvedAnimation(
//       parent: _pulseController,
//       curve: Curves.easeInOut,
//     ));
//
//     _parallaxAnimation = Tween<Offset>(
//       begin: const Offset(-0.02, -0.02),
//       end: const Offset(0.02, 0.02),
//     ).animate(CurvedAnimation(
//       parent: _parallaxController,
//       curve: Curves.easeInOut,
//     ));
//
//     _rotationAnimation = Tween<double>(
//       begin: 0.0,
//       end: 0.02,
//     ).animate(CurvedAnimation(
//       parent: _rotationController,
//       curve: Curves.easeInOut,
//     ));
//
//     // Text Animations
//     _titleFadeAnimation = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(CurvedAnimation(
//       parent: _textController,
//       curve: const Interval(0.3, 0.8, curve: Curves.easeOut),
//     ));
//
//     _titleSlideAnimation = Tween<Offset>(
//       begin: const Offset(0, 1.5),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(
//       parent: _textController,
//       curve: const Interval(0.3, 0.9, curve: Curves.elasticOut),
//     ));
//
//     _titleScaleAnimation = Tween<double>(
//       begin: 0.5,
//       end: 1.0,
//     ).animate(CurvedAnimation(
//       parent: _textController,
//       curve: const Interval(0.3, 0.8, curve: Curves.elasticOut),
//     ));
//
//     _subtitleFadeAnimation = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(CurvedAnimation(
//       parent: _textController,
//       curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
//     ));
//
//     _subtitleSlideAnimation = Tween<Offset>(
//       begin: const Offset(0, 2.0),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(
//       parent: _textController,
//       curve: const Interval(0.5, 1.0, curve: Curves.elasticOut),
//     ));
//
//     _subtitleScaleAnimation = Tween<double>(
//       begin: 0.3,
//       end: 1.0,
//     ).animate(CurvedAnimation(
//       parent: _textController,
//       curve: const Interval(0.5, 1.0, curve: Curves.elasticOut),
//     ));
//
//     // Pulse and Glow Animations
//     _pulseAnimation = Tween<double>(
//       begin: 1.0,
//       end: 1.08,
//     ).animate(CurvedAnimation(
//       parent: _pulseController,
//       curve: Curves.easeInOut,
//     ));
//
//     _glowAnimation = Tween<double>(
//       begin: 0.3,
//       end: 0.8,
//     ).animate(CurvedAnimation(
//       parent: _pulseController,
//       curve: Curves.easeInOut,
//     ));
//   }
//
//   void _startAnimations() {
//     _imageController.reset();
//     _textController.reset();
//
//     _imageController.forward();
//     Future.delayed(const Duration(milliseconds: 600), () {
//       if (mounted) {
//         _textController.forward();
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     _imageController.dispose();
//     _textController.dispose();
//     _zoomController.dispose();
//     _parallaxController.dispose();
//     _pulseController.dispose();
//     _rotationController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final screenHeight = MediaQuery.of(context).size.height;
//     final screenWidth = MediaQuery.of(context).size.width;
//
//     return Stack(
//       children: [
//         // Full Screen Animated Image Background
//         _buildFullScreenImageBackground(screenWidth, screenHeight),
//
//         // Gradient Overlay
//         _buildGradientOverlay(),
//
//         // Floating Particles
//         _buildFloatingParticles(screenWidth, screenHeight),
//
//         // Content Layer
//         _buildContentLayer(screenHeight),
//       ],
//     );
//   }
//
//   Widget _buildFullScreenImageBackground(double screenWidth, double screenHeight) {
//     return AnimatedBuilder(
//       animation: Listenable.merge([
//         _imageController,
//         _zoomController,
//         _parallaxController,
//         _pulseController,
//         _rotationController,
//       ]),
//       builder: (context, child) {
//         return FadeTransition(
//           opacity: _imageOpacityAnimation,
//           child: Transform.translate(
//             offset: Offset(
//               _parallaxAnimation.value.dx * screenWidth,
//               _parallaxAnimation.value.dy * screenHeight,
//             ),
//             child: Transform.rotate(
//               angle: math.sin(_rotationController.value * 2 * math.pi) * _rotationAnimation.value,
//               child: Transform.scale(
//                 scale: _imageZoomAnimation.value * _imageBreatheAnimation.value,
//                 child: Container(
//                   width: screenWidth,
//                   height: screenHeight,
//                   decoration: BoxDecoration(
//                     boxShadow: [
//                       BoxShadow(
//                         color: widget.data.primaryColor.withOpacity(0.4 * _glowAnimation.value),
//                         blurRadius: 100 * _glowAnimation.value,
//                         spreadRadius: 20 * _glowAnimation.value,
//                       ),
//                     ],
//                   ),
//                   child: Image.asset(
//                     widget.data.image,
//                     fit: BoxFit.contain,
//                     width: screenWidth,
//                     height: screenHeight,
//                     errorBuilder: (context, error, stackTrace) {
//                       return _buildFallbackBackground();
//                     },
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildFallbackBackground() {
//     return Container(
//       decoration: BoxDecoration(
//         gradient: RadialGradient(
//           center: Alignment.center,
//           radius: 1.0,
//           colors: [
//             widget.data.primaryColor.withOpacity(0.8),
//             widget.data.secondaryColor.withOpacity(0.9),
//             widget.data.primaryColor.withOpacity(0.6),
//           ],
//           stops: const [0.0, 0.6, 1.0],
//         ),
//       ),
//       child: Stack(
//         children: [
//           // Animated patterns
//           ...List.generate(20, (index) {
//             return AnimatedBuilder(
//               animation: _rotationController,
//               builder: (context, child) {
//                 final offset = (index * 0.1 + _rotationController.value) % 1.0;
//                 return Positioned(
//                   left: (math.sin(offset * 2 * math.pi) * 200) + 200,
//                   top: (math.cos(offset * 2 * math.pi) * 300) + 300,
//                   child: Container(
//                     width: 60 + (index % 3) * 20,
//                     height: 60 + (index % 3) * 20,
//                     decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(0.1 + (index % 3) * 0.05),
//                       shape: BoxShape.circle,
//                       boxShadow: [
//                         BoxShadow(
//                           color: widget.data.primaryColor.withOpacity(0.3),
//                           blurRadius: 20,
//                           spreadRadius: 5,
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             );
//           }),
//           // Central Icon
//           Center(
//             child: AnimatedBuilder(
//               animation: _pulseController,
//               builder: (context, child) {
//                 return Transform.scale(
//                   scale: _pulseAnimation.value,
//                   child: Icon(
//                     widget.data.icon,
//                     size: 120,
//                     color: Colors.white.withOpacity(0.2),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildGradientOverlay() {
//     return AnimatedBuilder(
//       animation: _pulseController,
//       builder: (context, child) {
//         return Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//               colors: [
//                 Colors.black.withOpacity(0.1),
//                 Colors.black.withOpacity(0.3 + 0.2 * _glowAnimation.value),
//                 widget.data.primaryColor.withOpacity(0.4 + 0.3 * _glowAnimation.value),
//                 widget.data.secondaryColor.withOpacity(0.6 + 0.2 * _glowAnimation.value),
//               ],
//               stops: const [0.0, 0.4, 0.7, 1.0],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildFloatingParticles(double screenWidth, double screenHeight) {
//     return AnimatedBuilder(
//       animation: _parallaxController,
//       builder: (context, child) {
//         return Stack(
//           children: List.generate(15, (index) {
//             final animationOffset = (index * 0.1) % 1.0;
//             final animatedValue = (_parallaxController.value + animationOffset) % 1.0;
//
//             return Positioned(
//               left: (math.sin(animatedValue * 2 * math.pi) * screenWidth * 0.3) + screenWidth * 0.5,
//               top: (math.cos(animatedValue * 2 * math.pi + index) * screenHeight * 0.2) + screenHeight * 0.5,
//               child: AnimatedBuilder(
//                 animation: _pulseController,
//                 builder: (context, child) {
//                   return Transform.scale(
//                     scale: _pulseAnimation.value * (0.5 + (index % 3) * 0.3),
//                     child: Container(
//                       width: 15 + (index % 4) * 10,
//                       height: 15 + (index % 4) * 10,
//                       decoration: BoxDecoration(
//                         color: Colors.white.withOpacity(0.2 + (index % 3) * 0.1),
//                         shape: BoxShape.circle,
//                         boxShadow: [
//                           BoxShadow(
//                             color: widget.data.primaryColor.withOpacity(0.4),
//                             blurRadius: 15 + (index % 3) * 5,
//                             spreadRadius: 2,
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             );
//           }),
//         );
//       },
//     );
//   }
//
//   Widget _buildContentLayer(double screenHeight) {
//     return Positioned(
//       bottom: screenHeight * 0.15,
//       left: 0,
//       right: 0,
//       child: Column(
//         children: [
//           // Enhanced Title
//           _buildEnhancedTitle(),
//
//           const SizedBox(height: 24),
//
//           // Enhanced Subtitle
//           _buildEnhancedSubtitle(),
//
//           const SizedBox(height: 30),
//
//           // Floating Icon Badge
//           _buildFloatingIconBadge(),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildEnhancedTitle() {
//     return SlideTransition(
//       position: _titleSlideAnimation,
//       child: FadeTransition(
//         opacity: _titleFadeAnimation,
//         child: Transform.scale(
//           scale: _titleScaleAnimation.value,
//           child: AnimatedBuilder(
//             animation: _pulseController,
//             builder: (context, child) {
//               return Container(
//                 margin: const EdgeInsets.symmetric(horizontal: 20),
//                 padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [
//                       Colors.white.withOpacity(0.15 + 0.1 * _glowAnimation.value),
//                       Colors.white.withOpacity(0.05 + 0.05 * _glowAnimation.value),
//                     ],
//                   ),
//                   borderRadius: BorderRadius.circular(25),
//                   border: Border.all(
//                     color: Colors.white.withOpacity(0.3 + 0.2 * _glowAnimation.value),
//                     width: 2,
//                   ),
//                   boxShadow: [
//                     BoxShadow(
//                       color: widget.data.primaryColor.withOpacity(0.3 * _glowAnimation.value),
//                       blurRadius: 20 * _glowAnimation.value,
//                       spreadRadius: 5 * _glowAnimation.value,
//                     ),
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.2),
//                       blurRadius: 15,
//                       offset: const Offset(0, 8),
//                     ),
//                   ],
//                 ),
//                 child: Text(
//                   widget.data.title,
//                   textAlign: TextAlign.center,
//                   style: getBoldStyle(
//                     fontSize: 18,
//                     color: Colors.white,
//                   ).copyWith(
//                     height: 1.3,
//                     letterSpacing: 0.5,
//                     shadows: [
//                       Shadow(
//                         offset: const Offset(0, 2),
//                         blurRadius: 8,
//                         color: Colors.black.withOpacity(0.5),
//                       ),
//                       Shadow(
//                         offset: const Offset(0, 4),
//                         blurRadius: 16,
//                         color: widget.data.primaryColor.withOpacity(0.3),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildEnhancedSubtitle() {
//     return SlideTransition(
//       position: _subtitleSlideAnimation,
//       child: FadeTransition(
//         opacity: _subtitleFadeAnimation,
//         child: Transform.scale(
//           scale: _subtitleScaleAnimation.value,
//           child: AnimatedBuilder(
//             animation: _pulseController,
//             builder: (context, child) {
//               return Container(
//                 margin: const EdgeInsets.symmetric(horizontal: 30),
//                 padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [
//                       Colors.white.withOpacity(0.08 + 0.05 * _glowAnimation.value),
//                       Colors.white.withOpacity(0.02 + 0.03 * _glowAnimation.value),
//                     ],
//                   ),
//                   borderRadius: BorderRadius.circular(20),
//                   border: Border.all(
//                     color: Colors.white.withOpacity(0.2 + 0.1 * _glowAnimation.value),
//                     width: 1,
//                   ),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.3),
//                       blurRadius: 10,
//                       offset: const Offset(0, 5),
//                     ),
//                   ],
//                 ),
//                 child: Text(
//                   widget.data.subtitle,
//                   textAlign: TextAlign.center,
//                   style: getRegularStyle(
//                     fontSize: 14,
//                     color: Colors.white.withOpacity(0.95),
//                   ).copyWith(
//                     height: 1.6,
//                     letterSpacing: 0.3,
//                     shadows: [
//                       Shadow(
//                         offset: const Offset(0, 1),
//                         blurRadius: 4,
//                         color: Colors.black.withOpacity(0.4),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildFloatingIconBadge() {
//     return AnimatedBuilder(
//       animation: Listenable.merge([_pulseController, _rotationController]),
//       builder: (context, child) {
//         return Transform.translate(
//           offset: Offset(
//             math.sin(_rotationController.value * 2 * math.pi) * 10,
//             math.cos(_rotationController.value * 2 * math.pi) * 5,
//           ),
//           child: Transform.scale(
//             scale: _pulseAnimation.value,
//             child: Container(
//               width: 65,
//               height: 65,
//               decoration: BoxDecoration(
//                 gradient: RadialGradient(
//                   colors: [
//                     widget.data.primaryColor.withOpacity(0.9),
//                     widget.data.secondaryColor.withOpacity(0.8),
//                   ],
//                 ),
//                 shape: BoxShape.circle,
//                 boxShadow: [
//                   BoxShadow(
//                     color: widget.data.primaryColor.withOpacity(0.6 * _glowAnimation.value),
//                     blurRadius: 25 * _glowAnimation.value,
//                     spreadRadius: 8 * _glowAnimation.value,
//                   ),
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.3),
//                     blurRadius: 15,
//                     offset: const Offset(0, 8),
//                   ),
//                 ],
//               ),
//               child: Transform.rotate(
//                 angle: _rotationController.value * 2 * math.pi * 0.1,
//                 child: Icon(
//                   widget.data.icon,
//                   color: Colors.white,
//                   size: 28,
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
//
// // Enhanced Page Indicator with more sophisticated animations
// class EnhancedPageIndicator extends StatefulWidget {
//   final int currentPage;
//   final int totalPages;
//   final Color activeColor;
//   final Color inactiveColor;
//
//   const EnhancedPageIndicator({
//     super.key,
//     required this.currentPage,
//     required this.totalPages,
//     required this.activeColor,
//     required this.inactiveColor,
//   });
//
//   @override
//   State<EnhancedPageIndicator> createState() => _EnhancedPageIndicatorState();
// }
//
// class _EnhancedPageIndicatorState extends State<EnhancedPageIndicator>
//     with TickerProviderStateMixin {
//   late AnimationController _animationController;
//   late AnimationController _pulseController;
//   late Animation<double> _scaleAnimation;
//   late Animation<double> _glowAnimation;
//   late Animation<double> _pulseAnimation;
//   int _previousPage = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     _previousPage = widget.currentPage;
//     _animationController = AnimationController(
//       duration: const Duration(milliseconds: 800),
//       vsync: this,
//     );
//
//     _pulseController = AnimationController(
//       duration: const Duration(milliseconds: 1500),
//       vsync: this,
//     )..repeat(reverse: true);
//
//     _scaleAnimation = Tween<double>(
//       begin: 1.0,
//       end: 1.3,
//     ).animate(CurvedAnimation(
//       parent: _animationController,
//       curve: Curves.elasticOut,
//     ));
//
//     _glowAnimation = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(CurvedAnimation(
//       parent: _animationController,
//       curve: Curves.easeInOut,
//     ));
//
//     _pulseAnimation = Tween<double>(
//       begin: 1.0,
//       end: 1.15,
//     ).animate(CurvedAnimation(
//       parent: _pulseController,
//       curve: Curves.easeInOut,
//     ));
//   }
//
//   @override
//   void didUpdateWidget(EnhancedPageIndicator oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (widget.currentPage != oldWidget.currentPage && widget.currentPage != _previousPage) {
//       _previousPage = widget.currentPage;
//       _animationController.reset();
//       _animationController.forward();
//     }
//   }
//
//   @override
//   void dispose() {
//     _animationController.dispose();
//     _pulseController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: Listenable.merge([_animationController, _pulseController]),
//       builder: (context, child) {
//         return Container(
//           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//           decoration: BoxDecoration(
//             color: Colors.white.withOpacity(0.1),
//             borderRadius: BorderRadius.circular(25),
//             border: Border.all(
//               color: Colors.white.withOpacity(0.2),
//               width: 1,
//             ),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.2),
//                 blurRadius: 10,
//                 offset: const Offset(0, 5),
//               ),
//             ],
//           ),
//           child: Row(
//             mainAxisSize: MainAxisSize.min,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: List.generate(
//               widget.totalPages,
//                   (index) => _buildIndicatorDot(index),
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildIndicatorDot(int index) {
//     final isActive = index == widget.currentPage;
//     final scale = isActive ? _scaleAnimation.value * _pulseAnimation.value : 1.0;
//
//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 600),
//       curve: Curves.elasticOut,
//       margin: const EdgeInsets.symmetric(horizontal: 6),
//       width: isActive ? 35 : 12,
//       height: 12,
//       decoration: BoxDecoration(
//         gradient: isActive
//             ? LinearGradient(
//           colors: [
//             widget.activeColor,
//             widget.activeColor.withOpacity(0.8),
//           ],
//         )
//             : null,
//         color: isActive ? null : widget.inactiveColor,
//         borderRadius: BorderRadius.circular(8),
//         boxShadow: isActive
//             ? [
//           BoxShadow(
//             color: widget.activeColor.withOpacity(0.6 * _glowAnimation.value),
//             blurRadius: 20 * _glowAnimation.value,
//             spreadRadius: 4 * _glowAnimation.value,
//           ),
//           BoxShadow(
//             color: widget.activeColor.withOpacity(0.4),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ]
//             : [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 4,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: isActive
//           ? Transform.scale(
//         scale: scale,
//         child: Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(8),
//             gradient: LinearGradient(
//               colors: [
//                 widget.activeColor,
//                 widget.activeColor.withOpacity(0.7),
//               ],
//             ),
//           ),
//         ),
//       )
//           : null,
//     );
//   }
// }