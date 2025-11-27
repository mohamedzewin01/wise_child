// lib/features/Welcome/presentation/pages/Welcome_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wise_child/assets_manager.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'package:wise_child/core/resources/routes_manager.dart';
import 'package:wise_child/core/resources/style_manager.dart';
import 'package:wise_child/core/utils/cashed_data_shared_preferences.dart';
import 'package:wise_child/core/widgets/language_toggle.dart';
import 'package:wise_child/features/ChildMode/presentation/pages/ChildMode_page.dart';
import 'package:wise_child/features/Welcome/presentation/bloc/Welcome_cubit.dart';
import 'package:wise_child/features/Welcome/presentation/pages/maintenance_page.dart';
import 'package:wise_child/l10n/app_localizations.dart';
import '../../../../core/di/di.dart';
import '../widgets/animated_welcome_background.dart';

import '../widgets/animated_logo.dart';


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
  late WelcomeCubit viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = getIt.get<WelcomeCubit>();
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeAnimations() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _staggerController = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.2, 0.8, curve: Curves.easeOutBack),
          ),
        );

    _staggeredAnimations = List.generate(3, (index) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _staggerController,
          curve: Interval(
            0.2 * index,
            0.4 + (0.2 * index),
            curve: Curves.easeOutBack,
          ),
        ),
      );
    });
  }

  void _startAnimations() {
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
    return BlocProvider.value(
      value: viewModel..getAppStatus(),
      child: BlocListener<WelcomeCubit, WelcomeState>(
        listener: (context, state) async {
          _handleStateChanges(context, state);

          if (state is AppStatusSuccess) {
            await Future.delayed(const Duration(seconds: 3));

            if (!context.mounted) return;

            final isActive = await CacheService.getData(key: CacheKeys.userActive) ?? false;
            final isChildMode = CacheService.getData(key: CacheKeys.childModeActive);

            if (isChildMode == true && context.mounted) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChildModePage(selectedChildId: 2089),
                ),
              );
              return;
            }

            if (isActive && context.mounted) {
              Navigator.pushReplacementNamed(context, RoutesManager.layoutScreen);
            } else if (context.mounted) {
              Navigator.pushReplacementNamed(context, RoutesManager.onboardingScreen);
            }
          }
        },
        child: BlocBuilder<WelcomeCubit, WelcomeState>(
          builder: (context, state) {
            if (state is AppMaintenanceState) {
              return MaintenancePage(appStatus: state.appStatus);
            }

            return _buildWelcomeScreen(state);
          },
        ),
      ),
    );
  }


  void _handleStateChanges(BuildContext context, WelcomeState state) {
    if (state is AppStatusSuccess) {
      // التطبيق يعمل بشكل طبيعي
      debugPrint('التطبيق يعمل بشكل طبيعي: ${state.data?.status}');
    } else if (state is AppMaintenanceState) {
      // التطبيق في حالة صيانة
      debugPrint('التطبيق في حالة صيانة: ${state.appStatus.data?.message}');
    } else if (state is AppStatusFailure) {
      // خطأ في الحصول على حالة التطبيق
      debugPrint('خطأ في الحصول على حالة التطبيق: ${state.exception}');
    }
  }

  Widget _buildWelcomeScreen(WelcomeState state) {
    return Scaffold(
      body: Stack(
        children: [
          const AnimatedWelcomeBackground(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  _buildLanguageToggle(),
                  _buildMainContent(state),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageToggle() {
    return Align(
      alignment: Alignment.topRight,
      child: SlideTransition(
        position: _slideAnimation,
        child: const LanguageToggle(),
      ),
    );
  }

  Widget _buildMainContent(WelcomeState state) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
            ),
            const AnimatedLogo(),
            const SizedBox(height: 25),
            _buildAppTitle(),
            const SizedBox(height: 15),
            _buildAppSubtitle(),
            const SizedBox(height: 60),
            _buildLoadingIndicator(state),
          ],
        ),
      ),
    );
  }

  Widget _buildAppTitle() {
    return Text(
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
    );
  }

  Widget _buildAppSubtitle() {
    return Text(
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
    );
  }

  Widget _buildLoadingIndicator(WelcomeState state) {
    return Column(
      children: [
        CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            ColorManager.white,
          ),
          strokeWidth: 3.0,
        ),
        const SizedBox(height: 20),
        _buildStatusText(state),
      ],
    );
  }

  Widget _buildStatusText(WelcomeState state) {
    String statusText = "جاري التحميل...";

    if (state is AppStatusLoading) {
      statusText = "جاري فحص حالة التطبيق...";
    } else if (state is AppStatusSuccess) {
      statusText = "التطبيق جاهز للاستخدام";
    } else if (state is AppStatusFailure) {
      statusText = "تعذر الاتصال بالخادم";
    }

    return Text(
      statusText,
      style: getRegularStyle(
        color: Colors.white.withOpacity(0.8),
        fontSize: 14,
      ),
      textAlign: TextAlign.center,
    );
  }

  void _checkUserStatus(BuildContext context) async {
    final isActive =
        await CacheService.getData(key: CacheKeys.userActive) ?? false;

    if (isActive && context.mounted) {
      Navigator.pushReplacementNamed(context, RoutesManager.layoutScreen);
    } else {
      if (context.mounted) {
        Navigator.pushReplacementNamed(context, RoutesManager.loginPage);
      }
    }
  }
}