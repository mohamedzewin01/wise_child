// // import 'package:flutter/material.dart';
// // import 'package:flutter_bloc/flutter_bloc.dart';
// //
// // import '../../../../core/di/di.dart';
// // import '../bloc/Onboarding_cubit.dart';
// //
// // class OnboardingPage extends StatefulWidget {
// //   const OnboardingPage({super.key});
// //
// //   @override
// //   State<OnboardingPage> createState() => _OnboardingPageState();
// // }
// //
// // class _OnboardingPageState extends State<OnboardingPage> {
// //
// //   late OnboardingCubit viewModel;
// //
// //   @override
// //   void initState() {
// //     viewModel = getIt.get<OnboardingCubit>();
// //     super.initState();
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return BlocProvider.value(
// //       value: viewModel,
// //       child: Scaffold(
// //         appBar: AppBar(title: const Text('Onboarding')),
// //         body: const Center(child: Text('Hello Onboarding')),
// //       ),
// //     );
// //   }
// // }
// //
// // lib/features/onboarding/presentation/pages/onboarding_screen.dart
// import 'package:flutter/material.dart';
// import 'package:wise_child/assets_manager.dart';
// import 'package:wise_child/core/resources/color_manager.dart';
// import 'package:wise_child/core/resources/routes_manager.dart';
// import 'package:wise_child/core/resources/style_manager.dart';
// import 'package:wise_child/core/utils/cashed_data_shared_preferences.dart';
// import 'package:wise_child/features/Onboarding/presentation/widgets/onboarding_page_widget.dart';
// import 'package:wise_child/l10n/app_localizations.dart';
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
//   late AnimationController _animationController;
//   late AnimationController _slideController;
//   late Animation<double> _fadeAnimation;
//   late Animation<Offset> _slideAnimation;
//
//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       duration: const Duration(milliseconds: 1500),
//       vsync: this,
//     );
//     _slideController = AnimationController(
//       duration: const Duration(milliseconds: 800),
//       vsync: this,
//     );
//
//     _fadeAnimation = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(CurvedAnimation(
//       parent: _animationController,
//       curve: Curves.easeInOut,
//     ));
//
//     _slideAnimation = Tween<Offset>(
//       begin: const Offset(0, 1),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(
//       parent: _slideController,
//       curve: Curves.elasticOut,
//     ));
//
//     _animationController.forward();
//     _slideController.forward();
//   }
//
//   @override
//   void dispose() {
//     _pageController.dispose();
//     _animationController.dispose();
//     _slideController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           // Animated Background
//           const AnimatedBackground(),
//
//           // Main Content
//           SafeArea(
//             child: Column(
//               children: [
//                 // Skip Button
//                 Padding(
//                   padding: const EdgeInsets.only(top: 20, right: 20),
//                   child: Align(
//                     alignment: Alignment.topRight,
//                     child: SlideTransition(
//                       position: _slideAnimation,
//                       child: TextButton(
//                         onPressed: () => _skipOnboarding(),
//                         style: TextButton.styleFrom(
//                           backgroundColor: Colors.white.withOpacity(0.2),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 20,
//                             vertical: 10,
//                           ),
//                         ),
//                         child: Text(
//                           AppLocalizations.of(context)!.skip ?? 'Skip',
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//
//                 // PageView
//                 Expanded(
//                   child: FadeTransition(
//                     opacity: _fadeAnimation,
//                     child: PageView(
//                       controller: _pageController,
//                       onPageChanged: (index) {
//                         setState(() {
//                           _currentPage = index;
//                         });
//                       },
//                       children: [
//                         OnboardingPageWidget(
//                           image: Assets.onboarding1,
//                           title: AppLocalizations.of(context)!.onboarding1Title ??
//                               'Personalized Stories',
//                           subtitle: AppLocalizations.of(context)!.onboarding1Subtitle ??
//                               'Create magical stories tailored to your child\'s interests and imagination',
//                           pageIndex: 0,
//                         ),
//                         OnboardingPageWidget(
//                           image: Assets.onboarding2,
//                           title: AppLocalizations.of(context)!.onboarding2Title ??
//                               'Expert Guidance',
//                           subtitle: AppLocalizations.of(context)!.onboarding2Subtitle ??
//                               'Professional insights and tips to support your child\'s development',
//                           pageIndex: 1,
//                         ),
//                         OnboardingPageWidget(
//                           image: Assets.onboarding3,
//                           title: AppLocalizations.of(context)!.onboarding3Title ??
//                               'Audio Narration',
//                           subtitle: AppLocalizations.of(context)!.onboarding3Subtitle ??
//                               'Enjoy beautiful voice narration that brings stories to life',
//                           pageIndex: 2,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//
//                 // Bottom Section
//                 SlideTransition(
//                   position: _slideAnimation,
//                   child: Container(
//                     padding: const EdgeInsets.all(30),
//                     child: Column(
//                       children: [
//                         // Page Indicator
//                         PageIndicator(
//                           currentPage: _currentPage,
//                           totalPages: 3,
//                         ),
//
//                         const SizedBox(height: 30),
//
//                         // Action Buttons
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             // Previous Button
//                             if (_currentPage > 0)
//                               _buildActionButton(
//                                 onPressed: () => _previousPage(),
//                                 icon: Icons.arrow_back_ios,
//                                 isSecondary: true,
//                               )
//                             else
//                               const SizedBox(width: 60),
//
//                             // Next/Get Started Button
//                             _buildMainActionButton(),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildActionButton({
//     required VoidCallback onPressed,
//     required IconData icon,
//     bool isSecondary = false,
//   }) {
//     return Container(
//       width: 60,
//       height: 60,
//       decoration: BoxDecoration(
//         color: isSecondary
//             ? Colors.white.withOpacity(0.2)
//             : ColorManager.primaryColor,
//         shape: BoxShape.circle,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 10,
//             offset: const Offset(0, 5),
//           ),
//         ],
//       ),
//       child: IconButton(
//         onPressed: onPressed,
//         icon: Icon(
//           icon,
//           color: Colors.white,
//           size: 24,
//         ),
//       ),
//     );
//   }
//
//   Widget _buildMainActionButton() {
//     final isLastPage = _currentPage == 2;
//
//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 300),
//       width: isLastPage ? 200 : 60,
//       height: 60,
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [
//             ColorManager.primaryColor,
//             ColorManager.primaryColor.withOpacity(0.8),
//           ],
//         ),
//         borderRadius: BorderRadius.circular(30),
//         boxShadow: [
//           BoxShadow(
//             color: ColorManager.primaryColor.withOpacity(0.3),
//             blurRadius: 20,
//             offset: const Offset(0, 10),
//           ),
//         ],
//       ),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           borderRadius: BorderRadius.circular(30),
//           onTap: isLastPage ? _finishOnboarding : _nextPage,
//           child: Container(
//             alignment: Alignment.center,
//             child: isLastPage
//                 ? Text(
//               AppLocalizations.of(context)!.getStarted ?? 'Get Started',
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//               ),
//             )
//                 : const Icon(
//               Icons.arrow_forward_ios,
//               color: Colors.white,
//               size: 24,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   void _nextPage() {
//     if (_currentPage < 2) {
//       _pageController.nextPage(
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeInOut,
//       );
//     }
//   }
//
//   void _previousPage() {
//     if (_currentPage > 0) {
//       _pageController.previousPage(
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeInOut,
//       );
//     }
//   }
//
//   void _skipOnboarding() {
//     _finishOnboarding();
//   }
//
//   void _finishOnboarding() async {
//     // Save onboarding completion
//     await CacheService.setData(key: CacheKeys.onboardingCompleted, value: true);
//
//     if (mounted) {
//       Navigator.pushReplacementNamed(context, RoutesManager.welcomeScreen);
//     }
//   }
// }