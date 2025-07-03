import 'package:flutter/material.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'package:wise_child/core/resources/style_manager.dart';

class EnhancedLoadingScreen extends StatefulWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onBack;
  final bool showBackButton;

  const EnhancedLoadingScreen({
    super.key,
    this.title = 'جاري التحميل...',
    this.subtitle = 'يرجى الانتظار قليلاً',
    this.onBack,
    this.showBackButton = true,
  });

  @override
  State<EnhancedLoadingScreen> createState() => _EnhancedLoadingScreenState();
}

class _EnhancedLoadingScreenState extends State<EnhancedLoadingScreen>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  late AnimationController _fadeController;
  late AnimationController _floatingController;

  late Animation<double> _rotationAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _floatingAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startAnimations();
  }

  void _setupAnimations() {
    // دوران للأيقونة الرئيسية
    _rotationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    // نبضة للحاوية
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // تدرج للظهور
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // حركة عائمة للعناصر
    _floatingController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 2,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.linear,
    ));

    _pulseAnimation = Tween<double>(
      begin: 0.95,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    ));

    _floatingAnimation = Tween<double>(
      begin: -10,
      end: 10,
    ).animate(CurvedAnimation(
      parent: _floatingController,
      curve: Curves.easeInOut,
    ));
  }

  void _startAnimations() {
    _rotationController.repeat();
    _pulseController.repeat(reverse: true);
    _fadeController.forward();
    _floatingController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulseController.dispose();
    _fadeController.dispose();
    _floatingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              ColorManager.primaryColor.withOpacity(0.1),
              Colors.white,
              ColorManager.primaryColor.withOpacity(0.05),
              Colors.purple.shade50.withOpacity(0.3),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              if (widget.showBackButton) _buildAppBar(),
              Expanded(child: _buildLoadingContent()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                onPressed: widget.onBack,
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: ColorManager.primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingContent() {
    return Center(
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildMainIcon(),
            const SizedBox(height: 40),
            _buildLoadingIndicator(),
            const SizedBox(height: 32),
            _buildLoadingText(),
            const SizedBox(height: 40),
            _buildAnimatedBars(),
            const SizedBox(height: 60),
            _buildFloatingElements(),
          ],
        ),
      ),
    );
  }

  Widget _buildMainIcon() {
    return AnimatedBuilder(
      animation: Listenable.merge([_pulseAnimation, _rotationAnimation]),
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Transform.rotate(
            angle: _rotationAnimation.value * 3.14159,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    ColorManager.primaryColor.withOpacity(0.2),
                    ColorManager.primaryColor.withOpacity(0.1),
                  ],
                ),
                shape: BoxShape.circle,
                border: Border.all(
                  color: ColorManager.primaryColor.withOpacity(0.3),
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: ColorManager.primaryColor.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Center(
                child: Icon(
                  Icons.auto_stories,
                  size: 60,
                  color: ColorManager.primaryColor,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingIndicator() {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 60,
          height: 60,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              ColorManager.primaryColor,
            ),
            strokeWidth: 4,
          ),
        ),
        SizedBox(
          width: 40,
          height: 40,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              Colors.purple.shade300,
            ),
            strokeWidth: 2,
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingText() {
    return Column(
      children: [
        AnimatedBuilder(
          animation: _floatingAnimation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _floatingAnimation.value),
              child: Text(
                widget.title,
                style: getBoldStyle(
                  color: ColorManager.primaryColor,
                  fontSize: 24,
                ),
                textAlign: TextAlign.center,
              ),
            );
          },
        ),
        const SizedBox(height: 12),
        Text(
          widget.subtitle,
          style: getRegularStyle(
            color: Colors.grey.shade600,
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildAnimatedBars() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return AnimatedBuilder(
          animation: _fadeController,
          builder: (context, child) {
            final delay = index * 0.2;
            final animationValue = (_fadeController.value - delay).clamp(0.0, 1.0);

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: 6,
              height: 25 + (15 * animationValue),
              decoration: BoxDecoration(
                color: ColorManager.primaryColor.withOpacity(
                  0.3 + (0.7 * animationValue),
                ),
                borderRadius: BorderRadius.circular(3),
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    ColorManager.primaryColor.withOpacity(0.8),
                    Colors.purple.shade300.withOpacity(0.6),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildFloatingElements() {
    return AnimatedBuilder(
      animation: _floatingAnimation,
      builder: (context, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Transform.translate(
              offset: Offset(_floatingAnimation.value * 0.5, _floatingAnimation.value),
              child: _FloatingIcon(
                icon: Icons.book,
                color: Colors.blue.shade300,
                delay: 0,
              ),
            ),
            Transform.translate(
              offset: Offset(_floatingAnimation.value * -0.3, _floatingAnimation.value * 0.7),
              child: _FloatingIcon(
                icon: Icons.favorite,
                color: Colors.pink.shade300,
                delay: 500,
              ),
            ),
            Transform.translate(
              offset: Offset(_floatingAnimation.value * 0.8, _floatingAnimation.value * -0.5),
              child: _FloatingIcon(
                icon: Icons.star,
                color: Colors.amber.shade300,
                delay: 1000,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _FloatingIcon extends StatefulWidget {
  final IconData icon;
  final Color color;
  final int delay;

  const _FloatingIcon({
    required this.icon,
    required this.color,
    required this.delay,
  });

  @override
  State<_FloatingIcon> createState() => _FloatingIconState();
}

class _FloatingIconState extends State<_FloatingIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));

    _opacityAnimation = Tween<double>(
      begin: 0.3,
      end: 0.8,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) {
        _controller.repeat(reverse: true);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: widget.color.withOpacity(0.3),
                shape: BoxShape.circle,
                border: Border.all(
                  color: widget.color,
                  width: 1,
                ),
              ),
              child: Icon(
                widget.icon,
                color: widget.color,
                size: 20,
              ),
            ),
          ),
        );
      },
    );
  }
}

// مكون لشاشة الخطأ المحسنة
class EnhancedErrorScreen extends StatefulWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onRetry;
  final VoidCallback? onBack;
  final bool showBackButton;

  const EnhancedErrorScreen({
    super.key,
    this.title = 'حدث خطأ',
    this.subtitle = 'تأكد من اتصالك بالإنترنت وحاول مرة أخرى',
    this.onRetry,
    this.onBack,
    this.showBackButton = true,
  });

  @override
  State<EnhancedErrorScreen> createState() => _EnhancedErrorScreenState();
}

class _EnhancedErrorScreenState extends State<EnhancedErrorScreen>
    with TickerProviderStateMixin {
  late AnimationController _shakeController;
  late AnimationController _fadeController;
  late AnimationController _bounceController;

  late Animation<double> _shakeAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startAnimations();
  }

  void _setupAnimations() {
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _shakeAnimation = Tween<double>(
      begin: -5,
      end: 5,
    ).animate(CurvedAnimation(
      parent: _shakeController,
      curve: Curves.elasticIn,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    ));

    _bounceAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _bounceController,
      curve: Curves.elasticOut,
    ));
  }

  void _startAnimations() {
    _fadeController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _bounceController.forward();
        _shakeController.repeat(reverse: true);
      }
    });
  }

  @override
  void dispose() {
    _shakeController.dispose();
    _fadeController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.red.withOpacity(0.1),
              Colors.white,
              Colors.red.withOpacity(0.05),
              Colors.orange.shade50.withOpacity(0.3),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              if (widget.showBackButton) _buildAppBar(),
              Expanded(child: _buildErrorContent()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                onPressed: widget.onBack,
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: ColorManager.primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorContent() {
    return Center(
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildErrorIcon(),
              const SizedBox(height: 32),
              _buildErrorText(),
              const SizedBox(height: 40),
              if (widget.onRetry != null) _buildRetryButton(),
              const SizedBox(height: 20),
              _buildHelpText(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorIcon() {
    return AnimatedBuilder(
      animation: Listenable.merge([_shakeAnimation, _bounceAnimation]),
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_shakeAnimation.value, 0),
          child: Transform.scale(
            scale: _bounceAnimation.value,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.red.withOpacity(0.2),
                    Colors.orange.withOpacity(0.1),
                  ],
                ),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.red.withOpacity(0.3),
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Center(
                child: Icon(
                  Icons.error_outline,
                  size: 60,
                  color: Colors.red.shade400,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildErrorText() {
    return Column(
      children: [
        Text(
          widget.title,
          style: getBoldStyle(
            color: Colors.red.shade600,
            fontSize: 24,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          widget.subtitle,
          style: getRegularStyle(
            color: Colors.grey.shade600,
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildRetryButton() {
    return ScaleTransition(
      scale: _bounceAnimation,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: ElevatedButton.icon(
          onPressed: widget.onRetry,
          icon: const Icon(Icons.refresh),
          label: const Text('إعادة المحاولة'),
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorManager.primaryColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
            elevation: 4,
            shadowColor: ColorManager.primaryColor.withOpacity(0.3),
          ),
        ),
      ),
    );
  }

  Widget _buildHelpText() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.blue.shade200,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: Colors.blue.shade600,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'تأكد من اتصالك بالإنترنت وإعادة تشغيل التطبيق إذا استمرت المشكلة',
              style: getRegularStyle(
                color: Colors.blue.shade700,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// مكون محسن لشاشة النجاح
class EnhancedSuccessScreen extends StatefulWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onContinue;
  final String? buttonText;

  const EnhancedSuccessScreen({
    super.key,
    this.title = 'تم بنجاح!',
    this.subtitle = 'تمت العملية بنجاح',
    this.onContinue,
    this.buttonText = 'متابعة',
  });

  @override
  State<EnhancedSuccessScreen> createState() => _EnhancedSuccessScreenState();
}

class _EnhancedSuccessScreenState extends State<EnhancedSuccessScreen>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _fadeController;
  late AnimationController _checkController;

  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _checkAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startAnimations();
  }

  void _setupAnimations() {
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _checkController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    ));

    _checkAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _checkController,
      curve: Curves.easeInOut,
    ));
  }

  void _startAnimations() {
    _fadeController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        _scaleController.forward();
      }
    });
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _checkController.forward();
      }
    });
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _fadeController.dispose();
    _checkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.green.withOpacity(0.1),
              Colors.white,
              Colors.green.withOpacity(0.05),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildSuccessIcon(),
                    const SizedBox(height: 32),
                    _buildSuccessText(),
                    const SizedBox(height: 40),
                    if (widget.onContinue != null) _buildContinueButton(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessIcon() {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.green.withOpacity(0.2),
              Colors.green.withOpacity(0.1),
            ],
          ),
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.green.withOpacity(0.3),
            width: 3,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.green.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: AnimatedBuilder(
          animation: _checkAnimation,
          builder: (context, child) {
            return CustomPaint(
              painter: CheckMarkPainter(_checkAnimation.value),
              child: Center(
                child: Icon(
                  Icons.check,
                  size: 60,
                  color: Colors.green.shade600.withOpacity(_checkAnimation.value),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSuccessText() {
    return Column(
      children: [
        Text(
          widget.title,
          style: getBoldStyle(
            color: Colors.green.shade600,
            fontSize: 24,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          widget.subtitle,
          style: getRegularStyle(
            color: Colors.grey.shade600,
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildContinueButton() {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: ElevatedButton(
          onPressed: widget.onContinue,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green.shade600,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
            elevation: 4,
            shadowColor: Colors.green.withOpacity(0.3),
          ),
          child: Text(
            widget.buttonText!,
            style: getBoldStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}

// رسام مخصص لعلامة الصح
class CheckMarkPainter extends CustomPainter {
  final double progress;

  CheckMarkPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.green.shade600
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    final center = Offset(size.width / 2, size.height / 2);

    // نقاط علامة الصح
    final point1 = Offset(center.dx - 15, center.dy);
    final point2 = Offset(center.dx - 5, center.dy + 10);
    final point3 = Offset(center.dx + 15, center.dy - 10);

    // رسم علامة الصح بناءً على التقدم
    if (progress > 0) {
      path.moveTo(point1.dx, point1.dy);
      if (progress <= 0.5) {
        // الجزء الأول من علامة الصح
        final currentPoint = Offset.lerp(point1, point2, progress * 2)!;
        path.lineTo(currentPoint.dx, currentPoint.dy);
      } else {
        // الجزء الكامل من علامة الصح
        path.lineTo(point2.dx, point2.dy);
        final currentPoint = Offset.lerp(point2, point3, (progress - 0.5) * 2)!;
        path.lineTo(currentPoint.dx, currentPoint.dy);
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}