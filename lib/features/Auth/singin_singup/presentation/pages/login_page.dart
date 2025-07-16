// lib/features/Auth/presentation/pages/login_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wise_child/assets_manager.dart';
import 'package:wise_child/core/functions/auth_function.dart';
import 'package:wise_child/core/functions/custom_dailog.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'package:wise_child/core/resources/routes_manager.dart';
import 'package:wise_child/core/resources/style_manager.dart';
import 'package:wise_child/core/widgets/Privacy_Policy.dart';
import 'package:wise_child/core/widgets/change_language.dart';
import 'package:wise_child/core/widgets/language_toggle.dart';
import 'package:wise_child/l10n/app_localizations.dart';

import '../../../../../core/di/di.dart';
import '../bloc/Auth_cubit.dart';
import '../widgets/auth_animated_background.dart';
import '../widgets/glassmorphism_container.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/gradient_button.dart';
import '../widgets/social_auth_buttons.dart';
import '../widgets/floating_elements.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  late AuthCubit viewModel;
  late AnimationController _mainController;
  late AnimationController _formController;
  late AnimationController _pulseController;

  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _formSlideAnimation;
  late Animation<double> _pulseAnimation;

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    viewModel = getIt.get<AuthCubit>();
    _initAnimations();
    _startAnimations();
  }

  void _initAnimations() {
    _mainController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _formController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _mainController,
            curve: const Interval(0.2, 0.8, curve: Curves.easeOutBack),
          ),
        );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.3, 1.0, curve: Curves.elasticOut),
      ),
    );

    _formSlideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(parent: _formController, curve: Curves.easeOutBack),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  void _startAnimations() {
    _mainController.forward();
    _formController.forward();
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _mainController.dispose();
    _formController.dispose();
    _pulseController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: viewModel,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          extendBodyBehindAppBar: true,
          body: Stack(
            children: [
              // Animated Background
              const AuthAnimatedBackground(),

              // Floating Elements
              const FloatingElements(),

              // Main Content
              SafeArea(
                child: BlocListener<AuthCubit, AuthState>(
                  listener: _handleAuthState,
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 5),

                        _buildLanguageToggle(),

                        _buildHeader(),
                        const SizedBox(height: 20),
                        _buildLoginForm(),
                        const SizedBox(height: 10),
                        _buildPrivacyPolicy(),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageToggle() {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Align(
          alignment: Alignment.topRight,
          child: const LanguageToggle(),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            // Animated Logo
            ScaleTransition(
              scale: _scaleAnimation,
              child: AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _pulseAnimation.value,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withOpacity(0.3),
                            Colors.white.withOpacity(0.1),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.4),
                            blurRadius: 30,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(40),
                            child: Image.asset(
                              Assets.logoPng,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.child_care,
                                  size: 40,
                                  color: Color(0xFF667eea),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // Title
            Text(
              AppLocalizations.of(context)!.login,
              style: getBoldStyle(color: Colors.white, fontSize: 18).copyWith(
                shadows: [
                  Shadow(
                    offset: const Offset(0, 3),
                    blurRadius: 15,
                    color: Colors.black.withOpacity(0.3),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Subtitle
            Text(
              AppLocalizations.of(context)!.loginToContinue,
              textAlign: TextAlign.center,
              style:
                  getRegularStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                  ).copyWith(
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
    );
  }

  Widget _buildLoginForm() {
    return AnimatedBuilder(
      animation: _formController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _formSlideAnimation.value),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  GlassmorphismContainer(
                    child: Column(
                      children: [
                        // Email field
                        CustomTextField(
                          controller: _emailController,
                          label: AppLocalizations.of(context)!.email,
                          icon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          validator: _validateEmail,
                        ),

                        const SizedBox(height: 16),

                        // Password field
                        CustomTextField(
                          controller: _passwordController,
                          label: AppLocalizations.of(context)!.password,
                          icon: Icons.lock_outline,
                          isPassword: true,
                          validator: _validatePassword,
                        ),

                        const SizedBox(height: 16),

                        // Forgot Password
                        _buildForgotPassword(),

                        const SizedBox(height: 16),

                        // Login Button
                        GradientButton(
                          text: AppLocalizations.of(context)!.login,
                          onPressed: _handleLogin,
                          icon: Icons.arrow_forward_ios,
                        ),

                        const SizedBox(height: 16),
                        _buildDivider(),

                        const SizedBox(height: 16),

                        // Social Login
                        SocialAuthButtons(
                          onGooglePressed: () => viewModel.signInWithGoogle(),
                        ),

                        const SizedBox(height: 24),

                        // Navigate to Register
                        _buildNavigateToRegister(),
                      ],
                    ),
                  ),
                  // Divider

                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildForgotPassword() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          Navigator.pushNamed(context, RoutesManager.forgotPasswordScreen, arguments: 'mohammedzewin01@gmail.com');
          // AuthFunctions.resetPassword(
          //   context,
          //   _emailController.text.isEmpty
          //       ? 'user@example.com'
          //       : _emailController.text,
          // );
        },
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Text(
          AppLocalizations.of(context)!.forgotPassword,
          style:
              getRegularStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 14,
              ).copyWith(
                decoration: TextDecoration.underline,
                decorationColor: Colors.white.withOpacity(0.9),
              ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Colors.white.withOpacity(0.3),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            AppLocalizations.of(context)!.orContinueWith,
            style: getRegularStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 14,
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Colors.white.withOpacity(0.3),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNavigateToRegister() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Don't have an account? ",
            style: getRegularStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14,
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushReplacementNamed(context, RoutesManager.registerPage);
            },
            child: Text(
              AppLocalizations.of(context)!.register,
              style: getBoldStyle(color: Colors.white, fontSize: 14).copyWith(
                decoration: TextDecoration.underline,
                decorationColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacyPolicy() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child:  const PrivacyPolicy(),
    );
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      viewModel.signIn(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
    }
  }

  void _handleAuthState(BuildContext context, AuthState state) {
    if (state is AuthLoginSuccess) {
      Navigator.pushReplacementNamed(context, RoutesManager.layoutScreen);
    } else if (state is AuthLoginFailure) {
      _showErrorSnackBar(context, state.exception.toString());
    } else if (state is AuthLoginLoading) {
      CustomDialog.showLoadingDialog(context);
    }
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red.shade400,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!.pleaseEnterYourEmail;
    }
    if (!value.contains('@')) {
      return AppLocalizations.of(context)!.pleaseEnterAValidEmail;
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!.pleaseEnterYourPassword;
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }
}
