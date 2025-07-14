import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wise_child/assets_manager.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'package:wise_child/core/resources/routes_manager.dart';
import 'package:wise_child/core/utils/cashed_data_shared_preferences.dart';
import 'package:wise_child/features/Onboarding/presentation/widgets/EnhancedOnboardingPageWidget.dart';


class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Animation Controllers
  late AnimationController _backgroundController;
  late AnimationController _contentController;
  late AnimationController _transitionController;
  late AnimationController _particleController;

  // Animations
  late Animation<double> _backgroundAnimation;
  late Animation<double> _contentFadeAnimation;
  late Animation<Offset> _contentSlideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  final List<OnboardingData> _onboardingPages = [
    OnboardingData(
      image: Assets.onbording1Jpg,
      title: 'اولادك متعبين؟ و إقناعهم صعب؟!!',
      subtitle: 'اكتشف طرق ذكية وممتعة للتواصل مع أطفالك وإقناعهم بسهولة',
      primaryColor: ColorManager.primaryColor,
      secondaryColor:  ColorManager.greenColor,
      icon: Icons.child_care,
    ),
    OnboardingData(
      image: Assets.onbording2Jpg,
      title: 'خليك عارف ان العصبيه مش تربيه',
      subtitle: 'تعلم كيفية التحكم في انفعالاتك وبناء علاقة صحية مع طفلك',
      primaryColor: const Color(0xFFFF6B6B),
      secondaryColor: const Color(0xFFE09B51),
      icon: Icons.psychology,
    ),
    OnboardingData(
      image: Assets.onbording3Jpg,
      title: 'اكتشف سر الاقناع الممتع',
      subtitle: 'تعلم أسهل الطرق لاكتساب العادات الإيجابية والسلوكيات الصحيحة',
      primaryColor: const Color(0xFF4ECDC4),
      secondaryColor: const Color(0xFF45B7AF),
      icon: Icons.lightbulb_outline,
    ),
    OnboardingData(
      image: Assets.onbording4Jpg,
      title: 'من خلال متعة المحاكاة والخيال',
      subtitle: 'استخدم قوة القصص والخيال لتكون أطفالك أبطال قصصهم الخاصة',
      primaryColor: const Color(0xFFFFA726),
      secondaryColor: const Color(0xFFFF7043),
      icon: Icons.auto_stories,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeAnimations() {
    // Background Animation Controller
    _backgroundController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();

    // Content Animation Controller
    _contentController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Transition Animation Controller
    _transitionController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Particle Animation Controller
    _particleController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();

    // Initialize Animations
    _backgroundAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _backgroundController,
      curve: Curves.linear,
    ));

    _contentFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _contentController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _contentSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _contentController,
      curve: const Interval(0.2, 0.8, curve: Curves.elasticOut),
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _contentController,
      curve: const Interval(0.0, 0.8, curve: Curves.elasticOut),
    ));

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _transitionController,
      curve: Curves.easeInOut,
    ));
  }

  void _startAnimations() {
    _contentController.forward();
    _transitionController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _backgroundController.dispose();
    _contentController.dispose();
    _transitionController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 800),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              _onboardingPages[_currentPage].primaryColor,
              _onboardingPages[_currentPage].secondaryColor,
              _onboardingPages[_currentPage].primaryColor.withOpacity(0.8),
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Animated Background Particles
            _buildAnimatedBackground(),

            // Main Content
            SafeArea(
              child: Column(
                children: [
                  // Top Bar with Skip Button
                  _buildTopBar(),

                  // Main PageView Content
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: _onPageChanged,
                      itemCount: _onboardingPages.length,
                      itemBuilder: (context, index) {
                        return EnhancedOnboardingPageWidget(
                          data: _onboardingPages[index],
                          pageIndex: index,
                          isActive: index == _currentPage,
                        );
                      },
                    ),
                  ),

                  // Bottom Navigation
                  _buildBottomNavigation(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return AnimatedBuilder(
      animation: _backgroundController,
      builder: (context, child) {
        return Stack(
          children: [
            // Floating Particles
            ...List.generate(15, (index) {
              final double animationOffset = (index * 0.1) % 1.0;
              final double animatedValue = (_backgroundAnimation.value + animationOffset) % 1.0;

              return Positioned(
                left: (50 + (index * 25)) + (animatedValue * 100),
                top: (100 + (index * 30)) + (sin(animatedValue * 2 * pi) * 50),
                child: Container(
                  width: 20 + (index % 3) * 10,
                  height: 20 + (index % 3) * 10,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1 + (index % 3) * 0.05),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.2),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
              );
            }),

            // Gradient Overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.1),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo or App Name
          SlideTransition(
            position: _contentSlideAnimation,
            child: FadeTransition(
              opacity: _contentFadeAnimation,
              child: Container(
                height: 45,
                width: 45,

                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1,
                  ),
                  image: DecorationImage(image: AssetImage(Assets.logoPng,),fit: BoxFit.cover)
                ),

              ),
            ),
          ),

          // Skip Button
          SlideTransition(
            position: _contentSlideAnimation,
            child: FadeTransition(
              opacity: _contentFadeAnimation,
              child: GestureDetector(
                onTap: _skipOnboarding,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: const Text(
                    'تخطي',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return SlideTransition(
      position: _contentSlideAnimation,
      child: FadeTransition(
        opacity: _contentFadeAnimation,
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Page Indicator
              EnhancedPageIndicator(
                currentPage: _currentPage,
                totalPages: _onboardingPages.length,
                activeColor: Colors.white,
                inactiveColor: Colors.white.withOpacity(0.3),
              ),

              const SizedBox(height: 30),

              // Navigation Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Previous Button
                  AnimatedOpacity(
                    opacity: _currentPage > 0 ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: _buildNavigationButton(
                      onPressed: _currentPage > 0 ? _previousPage : null,
                      icon: Icons.arrow_back_ios_new,
                      isSecondary: true,
                    ),
                  ),

                  // Next/Get Started Button
                  _buildMainActionButton(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationButton({
    required VoidCallback? onPressed,
    required IconData icon,
    bool isSecondary = false,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: isSecondary
            ? Colors.white.withOpacity(0.2)
            : Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: onPressed,
          child: Icon(
            icon,
            color: isSecondary ? Colors.white : _onboardingPages[_currentPage].primaryColor,
            size: 24,
          ),
        ),
      ),
    );
  }

  Widget _buildMainActionButton() {
    final isLastPage = _currentPage == _onboardingPages.length - 1;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.elasticOut,
      width: isLastPage ? 180 : 50,
      height: 50,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white,
            Colors.white.withOpacity(0.9),
          ],
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
            spreadRadius: 2,
          ),
          BoxShadow(
            color: _onboardingPages[_currentPage].primaryColor.withOpacity(0.3),
            blurRadius: 30,
            offset: const Offset(0, 15),
            spreadRadius: 5,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: isLastPage ? _finishOnboarding : _nextPage,
          child: Container(
            alignment: Alignment.center,
            child: isLastPage
                ? const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'اصنع البطل الان',
                  style: TextStyle(
                    color: Color(0xFF2D3436),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 8),
                Icon(
                  Icons.rocket_launch,
                  color: Color(0xFF2D3436),
                  size: 20,
                ),
              ],
            )
                : Icon(
              Icons.arrow_forward_ios,
              color: _onboardingPages[_currentPage].primaryColor,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });

    // Add haptic feedback
    HapticFeedback.lightImpact();

    // Reset and restart content animations for new page
    _contentController.reset();
    _contentController.forward();
  }

  void _nextPage() {
    if (_currentPage < _onboardingPages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void _skipOnboarding() {
    _finishOnboarding();
  }

  void _finishOnboarding() async {
    // Add haptic feedback
    HapticFeedback.mediumImpact();

      if (context.mounted) {
        Navigator.pushReplacementNamed(context, RoutesManager.loginPage);
      }
  }
}

// Data Model for Onboarding Pages
class OnboardingData {
  final String image;
  final String title;
  final String subtitle;
  final Color primaryColor;
  final Color secondaryColor;
  final IconData icon;

  OnboardingData({
    required this.image,
    required this.title,
    required this.subtitle,
    required this.primaryColor,
    required this.secondaryColor,
    required this.icon,
  });
}