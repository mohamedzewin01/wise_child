// lib/features/Welcome/presentation/pages/maintenance_page.dart
import 'package:flutter/material.dart';
import 'package:wise_child/assets_manager.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'package:wise_child/core/resources/style_manager.dart';
import 'package:wise_child/features/Welcome/domain/entities/app_status_entity.dart';
import 'package:wise_child/features/Welcome/presentation/widgets/animated_logo.dart';
import 'package:wise_child/features/Welcome/presentation/widgets/maintenance_info_card.dart';
import 'package:wise_child/l10n/app_localizations.dart';
import '../widgets/animated_welcome_background.dart';

class MaintenancePage extends StatefulWidget {
  final AppStatusEntity appStatus;

  const MaintenancePage({
    super.key,
    required this.appStatus,
  });

  @override
  State<MaintenancePage> createState() => _MaintenancePageState();
}

class _MaintenancePageState extends State<MaintenancePage>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _pulseController;
  late AnimationController _toolsController;
  late AnimationController _floatController;

  late Animation<double> _fadeInAnimation;
  late Animation<Offset> _slideInAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rotateAnimation;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeAnimations() {
    _mainController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _toolsController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _floatController = AnimationController(
      duration: const Duration(milliseconds: 4000),
      vsync: this,
    );

    _fadeInAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _mainController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _slideInAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _mainController,
      curve: const Interval(0.2, 0.8, curve: Curves.easeOutBack),
    ));

    _pulseAnimation = Tween<double>(
      begin: 0.9,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _rotateAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_toolsController);

    _floatAnimation = Tween<double>(
      begin: -10,
      end: 10,
    ).animate(CurvedAnimation(
      parent: _floatController,
      curve: Curves.easeInOut,
    ));
  }

  void _startAnimations() {
    _mainController.forward();
    _pulseController.repeat(reverse: true);
    _toolsController.repeat();
    _floatController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _mainController.dispose();
    _pulseController.dispose();
    _toolsController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const AnimatedWelcomeBackground(),
          _buildMaintenanceContent(),
          _buildFloatingTools(),
        ],
      ),
    );
  }

  Widget _buildMaintenanceContent() {
    return SafeArea(
      child: AnimatedBuilder(
        animation: _mainController,
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeInAnimation,
            child: SlideTransition(
              position: _slideInAnimation,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    _buildAnimatedMaintenanceIcon(),
                    const SizedBox(height: 30),
                    _buildMaintenanceTitle(),
                    const SizedBox(height: 30),
                    MaintenanceInfoCard(appStatus: widget.appStatus),
                    const SizedBox(height: 40),
                    _buildAnimatedLogo(),
                    const SizedBox(height: 30),
                    _buildRefreshButton(),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAnimatedMaintenanceIcon() {
    return AnimatedBuilder(
      animation: _pulseController,
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
                  Colors.orange.withOpacity(0.8),
                  Colors.deepOrange.withOpacity(0.6),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.orange.withOpacity(0.4),
                  blurRadius: 30,
                  spreadRadius: 10,
                ),
              ],
            ),
            child: const Icon(
              Icons.construction,
              size: 60,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }

  Widget _buildMaintenanceTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          Text(
           widget. appStatus.data?.title?? "جاري الصيانة",
            style: getBoldStyle(
              color: Colors.white,
              fontSize: 25,
            ).copyWith(
              shadows: [
                Shadow(
                  offset: const Offset(0, 2),
                  blurRadius: 10,
                  color: Colors.black.withOpacity(0.3),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            "نعمل على تحسين التطبيق لتجربة أفضل",
            style: getRegularStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedLogo() {
    return AnimatedBuilder(
      animation: _floatController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _floatAnimation.value),
          child: const AnimatedLogo(),
        );
      },
    );
  }

  Widget _buildRefreshButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white.withOpacity(0.2),
              Colors.white.withOpacity(0.1),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(28),
            onTap: () {
              _refreshAppStatus();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.refresh,
                  color: Colors.white,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  "إعادة المحاولة",
                  style: getMediumStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingTools() {
    return AnimatedBuilder(
      animation: _toolsController,
      builder: (context, child) {
        return Stack(
          children: [
            _buildFloatingTool(
              icon: Icons.build,
              left: 50,
              top: 150,
              delay: 0.0,
            ),
            _buildFloatingTool(
              icon: Icons.settings,
              right: 60,
              top: 200,
              delay: 0.33,
            ),
            _buildFloatingTool(
              icon: Icons.engineering,
              left: 80,
              bottom: 200,
              delay: 0.66,
            ),
            _buildFloatingTool(
              icon: Icons.hardware,
              right: 40,
              bottom: 150,
              delay: 1.0,
            ),
          ],
        );
      },
    );
  }

  Widget _buildFloatingTool({
    required IconData icon,
    double? left,
    double? right,
    double? top,
    double? bottom,
    required double delay,
  }) {
    return Positioned(
      left: left,
      right: right,
      top: top,
      bottom: bottom,
      child: Transform.rotate(
        angle: (_rotateAnimation.value + delay) * 6.28,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Icon(
            icon,
            color: Colors.white.withOpacity(0.6),
            size: 20,
          ),
        ),
      ),
    );
  }

  void _refreshAppStatus() {
    // يمكن إضافة منطق إعادة فحص حالة التطبيق هنا
    // مثل استدعاء الـ Cubit مرة أخرى
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "جاري إعادة فحص حالة التطبيق...",
          style: getRegularStyle(color: Colors.white, fontSize: 14),
        ),
        backgroundColor: Colors.blue.withOpacity(0.8),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}