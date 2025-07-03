// lib/features/welcome/presentation/pages/welcome_screen.dart
import 'package:flutter/material.dart';
import 'package:wise_child/assets_manager.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'package:wise_child/core/resources/routes_manager.dart';
import 'package:wise_child/core/resources/style_manager.dart';
import 'package:wise_child/core/utils/cashed_data_shared_preferences.dart';
import 'package:wise_child/core/widgets/language_toggle.dart';
import 'package:wise_child/l10n/app_localizations.dart';
import '../widgets/animated_welcome_background.dart';
import '../widgets/feature_card.dart';
import '../widgets/animated_logo.dart';
import '../widgets/modern_button.dart';
import '../../../../core/widgets/Privacy_Policy.dart';
import '../../../../core/widgets/change_language.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _staggerController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late List<Animation<double>> _staggeredAnimations;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _staggerController = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.2, 0.8, curve: Curves.easeOutBack),
    ));

    _staggeredAnimations = List.generate(3, (index) {
      return Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: _staggerController,
        curve: Interval(
          0.2 * index,
          0.4 + (0.2 * index),
          curve: Curves.easeOutBack,
        ),
      ));
    });

    _controller.forward();
    _staggerController.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _staggerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const AnimatedWelcomeBackground(),
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.topRight,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: const LanguageToggle(),
                      ),
                    ),
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: Column(
                          children: [
                            const AnimatedLogo(),
                            const SizedBox(height: 25),
                            Text(
                              AppLocalizations.of(context)!.appName,
                              style: getBoldStyle(
                                color: Colors.white,
                                fontSize: 32,
                              ).copyWith(
                                shadows: [
                                  Shadow(
                                    offset: const Offset(0, 2),
                                    blurRadius: 10,
                                    color: Colors.black.withOpacity(0.3),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 15),
                            Text(
                              AppLocalizations.of(context)!.appSubtitle,
                              textAlign: TextAlign.center,
                              style: getRegularStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 16,
                              ).copyWith(
                                height: 1.5,
                                shadows: [
                                  Shadow(
                                    offset: const Offset(0, 1),
                                    blurRadius: 5,
                                    color: Colors.black.withOpacity(0.2),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    Column(
                      children: [
                        AnimatedBuilder(
                          animation: _staggeredAnimations[0],
                          builder: (context, child) {
                            return Transform.translate(
                              offset: Offset(
                                0,
                                50 * (1 - _staggeredAnimations[0].value),
                              ),
                              child: Opacity(
                                opacity: _staggeredAnimations[0]
                                    .value
                                    .clamp(0.0, 1.0),
                                child: FeatureCard(
                                  icon: Icons.auto_stories_outlined,
                                  title: AppLocalizations.of(context)!
                                      .personalizedStories,
                                  gradientColors: const [
                                    Color(0xFF4facfe),
                                    Color(0xFF00f2fe),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 10),
                        AnimatedBuilder(
                          animation: _staggeredAnimations[1],
                          builder: (context, child) {
                            return Transform.translate(
                              offset: Offset(
                                0,
                                50 * (1 - _staggeredAnimations[1].value),
                              ),
                              child: Opacity(
                                opacity: _staggeredAnimations[1]
                                    .value
                                    .clamp(0.0, 1.0),
                                child: FeatureCard(
                                  icon: Icons.psychology_outlined,
                                  title: AppLocalizations.of(context)!
                                      .expertGuidedSolutions,
                                  subtitle:
                                  'Professional insights to support development',
                                  gradientColors: const [
                                    Color(0xFF43e97b),
                                    Color(0xFF38f9d7),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 10),
                        AnimatedBuilder(
                          animation: _staggeredAnimations[2],
                          builder: (context, child) {
                            return Transform.translate(
                              offset: Offset(
                                0,
                                50 * (1 - _staggeredAnimations[2].value),
                              ),
                              child: Opacity(
                                opacity: _staggeredAnimations[2]
                                    .value
                                    .clamp(0.0, 1.0),
                                child: FeatureCard(
                                  icon: Icons.volume_up_outlined,
                                  title: AppLocalizations.of(context)!
                                      .audioNarration,
                                  subtitle:
                                  'Beautiful voice narration brings stories to life',
                                  gradientColors: const [
                                    Color(0xFFfa709a),
                                    Color(0xFFfee140),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SlideTransition(
                      position: _slideAnimation,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: ModernButton(
                          text: AppLocalizations.of(context)!.getStarted,
                          onPressed: () => _checkUserStatus(context),
                          width: double.infinity,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: const PrivacyPolicy(),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _checkUserStatus(BuildContext context) async {
    final isActive =
        await CacheService.getData(key: CacheKeys.userActive) ?? false;

    if (isActive && context.mounted) {
      Navigator.pushNamed(context, RoutesManager.layoutScreen);
    } else {
      if (context.mounted) {
        Navigator.pushNamed(context, RoutesManager.loginPage);
      }
    }
  }
}
