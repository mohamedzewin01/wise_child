// import 'dart:math';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:wise_child/assets_manager.dart';
// import 'package:wise_child/core/resources/color_manager.dart';
// import 'package:wise_child/core/resources/routes_manager.dart';
// import 'package:wise_child/core/utils/cashed_data_shared_preferences.dart';
// import 'package:wise_child/features/Onboarding/presentation/widgets/EnhancedOnboardingPageWidget.dart';
// import 'package:wise_child/features/Onboarding/presentation/widgets/EnhancedOnboardingPageWidget2.dart';
//
// class OnboardingScreen extends StatefulWidget {
//   const OnboardingScreen({super.key});
//
//   @override
//   State<OnboardingScreen> createState() => _OnboardingScreenState();
// }
//
// class _OnboardingScreenState extends State<OnboardingScreen>
//     with TickerProviderStateMixin {
//   final PageController _pageController = PageController();
//   int _currentPage = 0;
//
//   // Enhanced Animation Controllers
//   late AnimationController _backgroundController;
//   late AnimationController _contentController;
//   late AnimationController _transitionController;
//   late AnimationController _particleController;
//   late AnimationController _glowController;
//
//   // Enhanced Animations
//   late Animation<double> _backgroundAnimation;
//   late Animation<double> _contentFadeAnimation;
//   late Animation<Offset> _contentSlideAnimation;
//   late Animation<double> _scaleAnimation;
//   late Animation<double> _rotationAnimation;
//   late Animation<double> _glowAnimation;
//
//   final List<OnboardingData> _onboardingPages = [
//     OnboardingData(
//       image: Assets.onbording1Jpg,
//       title: 'اولادك متعبين؟ و إقناعهم صعب؟!!',
//       subtitle: 'اكتشف طرق ذكية وممتعة للتواصل مع أطفالك وإقناعهم بسهولة',
//       primaryColor: ColorManager.primaryColor,
//       secondaryColor: ColorManager.greenColor,
//       icon: Icons.child_care,
//     ),
//     OnboardingData(
//       image: Assets.onbording2Jpg,
//       title: 'خليك عارف ان العصبيه مش تربيه',
//       subtitle: 'تعلم كيفية التحكم في انفعالاتك وبناء علاقة صحية مع طفلك',
//       primaryColor: const Color(0xFFFF6B6B),
//       secondaryColor: const Color(0xFFE09B51),
//       icon: Icons.psychology,
//     ),
//     OnboardingData(
//       image: Assets.onbording3Jpg,
//       title: 'اكتشف سر الاقناع الممتع',
//       subtitle: 'تعلم أسهل الطرق لاكتساب العادات الإيجابية والسلوكيات الصحيحة',
//       primaryColor: const Color(0xFF4ECDC4),
//       secondaryColor: const Color(0xFF45B7AF),
//       icon: Icons.lightbulb_outline,
//     ),
//     OnboardingData(
//       image: Assets.onbording4Jpg,
//       title: 'من خلال متعة المحاكاة والخيال',
//       subtitle: 'استخدم قوة القصص والخيال لتكون أطفالك أبطال قصصهم الخاصة',
//       primaryColor: const Color(0xFFFFA726),
//       secondaryColor: const Color(0xFFFF7043),
//       icon: Icons.auto_stories,
//     ),
//   ];
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeAnimations();
//     _startAnimations();
//   }
//
//   void _initializeAnimations() {
//     // Enhanced Background Animation Controller
//     _backgroundController = AnimationController(
//       duration: const Duration(seconds: 25),
//       vsync: this,
//     )..repeat();
//
//     // Content Animation Controller
//     _contentController = AnimationController(
//       duration: const Duration(milliseconds: 2000),
//       vsync: this,
//     );
//
//     // Transition Animation Controller
//     _transitionController = AnimationController(
//       duration: const Duration(milliseconds: 1000),
//       vsync: this,
//     );
//
//     // Enhanced Particle Animation Controller
//     _particleController = AnimationController(
//       duration: const Duration(seconds: 15),
//       vsync: this,
//     )..repeat();
//
//     // Glow Animation Controller
//     _glowController = AnimationController(
//       duration: const Duration(seconds: 4),
//       vsync: this,
//     )..repeat(reverse: true);
//
//     // Initialize Enhanced Animations
//     _backgroundAnimation = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(CurvedAnimation(
//       parent: _backgroundController,
//       curve: Curves.linear,
//     ));
//
//     _contentFadeAnimation = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(CurvedAnimation(
//       parent: _contentController,
//       curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
//     ));
//
//     _contentSlideAnimation = Tween<Offset>(
//       begin: const Offset(0, 0.8),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(
//       parent: _contentController,
//       curve: const Interval(0.2, 1.0, curve: Curves.elasticOut),
//     ));
//
//     _scaleAnimation = Tween<double>(
//       begin: 0.3,
//       end: 1.0,
//     ).animate(CurvedAnimation(
//       parent: _contentController,
//       curve: const Interval(0.0, 0.8, curve: Curves.elasticOut),
//     ));
//
//     _rotationAnimation = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(CurvedAnimation(
//       parent: _transitionController,
//       curve: Curves.easeInOut,
//     ));
//
//     _glowAnimation = Tween<double>(
//       begin: 0.3,
//       end: 1.0,
//     ).animate(CurvedAnimation(
//       parent: _glowController,
//       curve: Curves.easeInOut,
//     ));
//   }
//
//   void _startAnimations() {
//     _contentController.forward();
//     _transitionController.forward();
//   }
//
//   @override
//   void dispose() {
//     _pageController.dispose();
//     _backgroundController.dispose();
//     _contentController.dispose();
//     _transitionController.dispose();
//     _particleController.dispose();
//     _glowController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBodyBehindAppBar: true,
//       body: Stack(
//         children: [
//           // Main PageView Content with Full Screen Images
//           PageView.builder(
//             controller: _pageController,
//             onPageChanged: _onPageChanged,
//             itemCount: _onboardingPages.length,
//             itemBuilder: (context, index) {
//               return EnhancedOnboardingPageWidget(
//                 data: _onboardingPages[index],
//                 pageIndex: index,
//                 isActive: index == _currentPage,
//               );
//             },
//           ),
//
//           // Enhanced Floating Elements
//           _buildEnhancedFloatingElements(),
//
//           // Top Navigation Bar
//           _buildEnhancedTopBar(),
//
//           // Bottom Navigation
//           _buildEnhancedBottomNavigation(),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildEnhancedFloatingElements() {
//     return AnimatedBuilder(
//       animation: Listenable.merge([_backgroundController, _glowController]),
//       builder: (context, child) {
//         return Stack(
//           children: [
//             // Enhanced Floating Particles with Different Behaviors
//             ...List.generate(25, (index) {
//               final double animationOffset = (index * 0.08) % 1.0;
//               final double animatedValue = (_backgroundAnimation.value + animationOffset) % 1.0;
//               final double glowValue = _glowAnimation.value;
//
//               // Different movement patterns for different particles
//               double xPosition, yPosition;
//               if (index % 3 == 0) {
//                 // Circular motion
//                 xPosition = (150 + (index * 30)) + (cos(animatedValue * 2 * pi) * 80);
//                 yPosition = (200 + (index * 25)) + (sin(animatedValue * 2 * pi) * 80);
//               } else if (index % 3 == 1) {
//                 // Wave motion
//                 xPosition = (100 + (index * 35)) + (animatedValue * 120);
//                 yPosition = (150 + (index * 40)) + (sin(animatedValue * 4 * pi) * 60);
//               } else {
//                 // Figure-8 motion
//                 xPosition = (80 + (index * 25)) + (sin(animatedValue * 2 * pi) * 100);
//                 yPosition = (180 + (index * 35)) + (sin(animatedValue * 4 * pi) * 50);
//               }
//
//               return Positioned(
//                 left: xPosition,
//                 top: yPosition,
//                 child: Transform.rotate(
//                   angle: animatedValue * 2 * pi,
//                   child: Container(
//                     width: 15 + (index % 4) * 8,
//                     height: 15 + (index % 4) * 8,
//                     decoration: BoxDecoration(
//                       gradient: RadialGradient(
//                         colors: [
//                           _onboardingPages[_currentPage].primaryColor.withOpacity(0.03 + (index % 3) * 0.02 * glowValue),
//                           _onboardingPages[_currentPage].secondaryColor.withOpacity(0.02 + (index % 3) * 0.01 * glowValue),
//                           Colors.transparent,
//                         ],
//                       ),
//                       shape: BoxShape.circle,
//                       boxShadow: [
//                         BoxShadow(
//                           color: _onboardingPages[_currentPage].primaryColor.withOpacity(0.05 * glowValue),
//                           blurRadius: 8 * glowValue,
//                           spreadRadius: 1 * glowValue,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               );
//             }),
//
//             // Enhanced Gradient Overlay for better text readability
//             Container(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                   colors: [
//                     Colors.black.withOpacity(0.05),
//                     Colors.transparent,
//                     Colors.transparent,
//                     Colors.black.withOpacity(0.3),
//                   ],
//                   stops: const [0.0, 0.3, 0.7, 1.0],
//                 ),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   Widget _buildEnhancedTopBar() {
//     return SafeArea(
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             // Enhanced Logo
//             SlideTransition(
//               position: _contentSlideAnimation,
//               child: FadeTransition(
//                 opacity: _contentFadeAnimation,
//                 child: AnimatedBuilder(
//                   animation: _glowController,
//                   builder: (context, child) {
//                     return Transform.scale(
//                       scale: 1.0 + (0.05 * _glowAnimation.value),
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//                         decoration: BoxDecoration(
//                           gradient: LinearGradient(
//                             colors: [
//                               Colors.white.withOpacity(0.25 + 0.1 * _glowAnimation.value),
//                               Colors.white.withOpacity(0.15 + 0.05 * _glowAnimation.value),
//                             ],
//                           ),
//                           borderRadius: BorderRadius.circular(25),
//                           border: Border.all(
//                             color: Colors.white.withOpacity(0.4 + 0.2 * _glowAnimation.value),
//                             width: 2,
//                           ),
//                           boxShadow: [
//                             BoxShadow(
//                               color: _onboardingPages[_currentPage].primaryColor.withOpacity(0.3 * _glowAnimation.value),
//                               blurRadius: 15 * _glowAnimation.value,
//                               spreadRadius: 2 * _glowAnimation.value,
//                             ),
//                             BoxShadow(
//                               color: Colors.black.withOpacity(0.2),
//                               blurRadius: 10,
//                               offset: const Offset(0, 5),
//                             ),
//                           ],
//                         ),
//                         child: const Text(
//                           'Wise Child',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                             letterSpacing: 0.5,
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ),
//
//             // Enhanced Skip Button
//             SlideTransition(
//               position: _contentSlideAnimation,
//               child: FadeTransition(
//                 opacity: _contentFadeAnimation,
//                 child: AnimatedBuilder(
//                   animation: _glowController,
//                   builder: (context, child) {
//                     return Transform.scale(
//                       scale: 1.0 + (0.03 * _glowAnimation.value),
//                       child: GestureDetector(
//                         onTap: _skipOnboarding,
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
//                           decoration: BoxDecoration(
//                             gradient: LinearGradient(
//                               colors: [
//                                 Colors.white.withOpacity(0.2 + 0.1 * _glowAnimation.value),
//                                 Colors.white.withOpacity(0.1 + 0.05 * _glowAnimation.value),
//                               ],
//                             ),
//                             borderRadius: BorderRadius.circular(30),
//                             border: Border.all(
//                               color: Colors.white.withOpacity(0.3 + 0.2 * _glowAnimation.value),
//                               width: 1.5,
//                             ),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black.withOpacity(0.2),
//                                 blurRadius: 8,
//                                 offset: const Offset(0, 4),
//                               ),
//                             ],
//                           ),
//                           child: const Text(
//                             'تخطي',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 16,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildEnhancedBottomNavigation() {
//     return Positioned(
//       bottom: 0,
//       left: 0,
//       right: 0,
//       child: SafeArea(
//         child: SlideTransition(
//           position: _contentSlideAnimation,
//           child: FadeTransition(
//             opacity: _contentFadeAnimation,
//             child: Container(
//               padding: const EdgeInsets.all(28),
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                   colors: [
//                     Colors.transparent,
//                     Colors.black.withOpacity(0.1),
//                     Colors.black.withOpacity(0.2),
//                   ],
//                 ),
//               ),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   // Enhanced Page Indicator
//                   AnimatedBuilder(
//                     animation: _contentController,
//                     builder: (context, child) {
//                       return EnhancedPageIndicator(
//                         currentPage: _currentPage,
//                         totalPages: _onboardingPages.length,
//                         activeColor: Colors.white,
//                         inactiveColor: Colors.white.withOpacity(0.4),
//                       );
//                     },
//                   ),
//
//                   const SizedBox(height: 35),
//
//                   // Enhanced Navigation Buttons
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       // Enhanced Previous Button
//                       AnimatedOpacity(
//                         opacity: _currentPage > 0 ? 1.0 : 0.0,
//                         duration: const Duration(milliseconds: 400),
//                         child: _buildEnhancedNavigationButton(
//                           onPressed: _currentPage > 0 ? _previousPage : null,
//                           icon: Icons.arrow_back_ios_new,
//                           isSecondary: true,
//                         ),
//                       ),
//
//                       // Enhanced Next/Get Started Button
//                       _buildEnhancedMainActionButton(),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildEnhancedNavigationButton({
//     required VoidCallback? onPressed,
//     required IconData icon,
//     bool isSecondary = false,
//   }) {
//     return AnimatedBuilder(
//       animation: _glowController,
//       builder: (context, child) {
//         return Transform.scale(
//           scale: 1.0 + (0.05 * _glowAnimation.value),
//           child: AnimatedContainer(
//             duration: const Duration(milliseconds: 400),
//             width: 60,
//             height: 60,
//             decoration: BoxDecoration(
//               gradient: isSecondary
//                   ? LinearGradient(
//                 colors: [
//                   Colors.white.withOpacity(0.2 + 0.1 * _glowAnimation.value),
//                   Colors.white.withOpacity(0.1 + 0.05 * _glowAnimation.value),
//                 ],
//               )
//                   : LinearGradient(
//                 colors: [
//                   Colors.white,
//                   Colors.white.withOpacity(0.9),
//                 ],
//               ),
//               shape: BoxShape.circle,
//               border: Border.all(
//                 color: Colors.white.withOpacity(0.4 + 0.2 * _glowAnimation.value),
//                 width: 2,
//               ),
//               boxShadow: [
//                 BoxShadow(
//                   color: _onboardingPages[_currentPage].primaryColor.withOpacity(0.3 * _glowAnimation.value),
//                   blurRadius: 20 * _glowAnimation.value,
//                   spreadRadius: 3 * _glowAnimation.value,
//                 ),
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.15),
//                   blurRadius: 15,
//                   offset: const Offset(0, 8),
//                 ),
//               ],
//             ),
//             child: Material(
//               color: Colors.transparent,
//               child: InkWell(
//                 borderRadius: BorderRadius.circular(30),
//                 onTap: onPressed,
//                 child: Icon(
//                   icon,
//                   color: isSecondary ? Colors.white : _onboardingPages[_currentPage].primaryColor,
//                   size: 28,
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildEnhancedMainActionButton() {
//     final isLastPage = _currentPage == _onboardingPages.length - 1;
//
//     return AnimatedBuilder(
//       animation: _glowController,
//       builder: (context, child) {
//         return Transform.scale(
//           scale: 1.0 + (0.08 * _glowAnimation.value),
//           child: AnimatedContainer(
//             duration: const Duration(milliseconds: 600),
//             curve: Curves.elasticOut,
//             width: isLastPage ? 200 : 60,
//             height: 60,
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [
//                   Colors.white,
//                   Colors.white.withOpacity(0.95),
//                   Colors.white.withOpacity(0.9),
//                 ],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//               borderRadius: BorderRadius.circular(35),
//               boxShadow: [
//                 BoxShadow(
//                   color: _onboardingPages[_currentPage].primaryColor.withOpacity(0.4 * _glowAnimation.value),
//                   blurRadius: 25 * _glowAnimation.value,
//                   spreadRadius: 5 * _glowAnimation.value,
//                 ),
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.25),
//                   blurRadius: 20,
//                   offset: const Offset(0, 10),
//                   spreadRadius: 2,
//                 ),
//                 BoxShadow(
//                   color: Colors.white.withOpacity(0.8),
//                   blurRadius: 5,
//                   offset: const Offset(0, -2),
//                   spreadRadius: 1,
//                 ),
//               ],
//             ),
//             child: Material(
//               color: Colors.transparent,
//               child: InkWell(
//                 borderRadius: BorderRadius.circular(35),
//                 onTap: isLastPage ? _finishOnboarding : _nextPage,
//                 child: Container(
//                   alignment: Alignment.center,
//                   child: isLastPage
//                       ? const Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         'ابدأ الآن',
//                         style: TextStyle(
//                           color: Color(0xFF2D3436),
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           letterSpacing: 0.5,
//                         ),
//                       ),
//                       SizedBox(width: 10),
//                       Icon(
//                         Icons.rocket_launch,
//                         color: Color(0xFF2D3436),
//                         size: 24,
//                       ),
//                     ],
//                   )
//                       : Icon(
//                     Icons.arrow_forward_ios,
//                     color: _onboardingPages[_currentPage].primaryColor,
//                     size: 28,
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
//   void _onPageChanged(int index) {
//     setState(() {
//       _currentPage = index;
//     });
//
//     // Enhanced haptic feedback
//     HapticFeedback.mediumImpact();
//
//     // Reset and restart content animations for new page
//     _contentController.reset();
//     _contentController.forward();
//   }
//
//   void _nextPage() {
//     if (_currentPage < _onboardingPages.length - 1) {
//       _pageController.nextPage(
//         duration: const Duration(milliseconds: 500),
//         curve: Curves.easeInOutCubic,
//       );
//     }
//   }
//
//   void _previousPage() {
//     if (_currentPage > 0) {
//       _pageController.previousPage(
//         duration: const Duration(milliseconds: 500),
//         curve: Curves.easeInOutCubic,
//       );
//     }
//   }
//
//   void _skipOnboarding() {
//     _finishOnboarding();
//   }
//
//   void _finishOnboarding() async {
//     // Enhanced haptic feedback
//     HapticFeedback.heavyImpact();
//
//     // Save onboarding completion
//     await CacheService.setData(key: CacheKeys.onboardingCompleted, value: true);
//
//     if (mounted) {
//       final isActive =
//           await CacheService.getData(key: CacheKeys.userActive) ?? false;
//
//       if (isActive && context.mounted) {
//         Navigator.pushReplacementNamed(context, RoutesManager.layoutScreen);
//       } else {
//         if (context.mounted) {
//           Navigator.pushReplacementNamed(context, RoutesManager.loginPage);
//         }
//       }
//     }
//   }
// }
//
// // Enhanced Data Model for Onboarding Pages
// class OnboardingData {
//   final String image;
//   final String title;
//   final String subtitle;
//   final Color primaryColor;
//   final Color secondaryColor;
//   final IconData icon;
//
//   OnboardingData({
//     required this.image,
//     required this.title,
//     required this.subtitle,
//     required this.primaryColor,
//     required this.secondaryColor,
//     required this.icon,
//   });
// }