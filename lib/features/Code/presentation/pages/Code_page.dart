
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wise_child/core/di/di.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'package:wise_child/core/resources/routes_manager.dart';
import 'package:wise_child/core/resources/style_manager.dart';
import 'package:wise_child/features/Code/presentation/bloc/Code_cubit.dart';
import 'package:wise_child/features/Welcome/presentation/widgets/animated_welcome_background.dart';
import 'package:wise_child/features/Welcome/presentation/widgets/animated_logo.dart';

class CodeVerificationPage extends StatefulWidget {
  const CodeVerificationPage({super.key});

  @override
  State<CodeVerificationPage> createState() => _CodeVerificationPageState();
}

class _CodeVerificationPageState extends State<CodeVerificationPage>
    with TickerProviderStateMixin {
  late CodeCubit viewModel;
  late AnimationController _controller;
  late AnimationController _staggerController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final TextEditingController _codeController = TextEditingController();
  final FocusNode _codeFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    viewModel = getIt.get<CodeCubit>();
    _initializeAnimations();
    _startAnimations();

    // التحقق التلقائي من الكود عند الدخول
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.checkCode(null);
    });
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
  }

  void _startAnimations() {
    _controller.forward();
    _staggerController.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _staggerController.dispose();
    _codeController.dispose();
    _codeFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: viewModel,
      child: BlocListener<CodeCubit, CodeState>(
        listener: (context, state) {
          if (state is CodeSuccess) {
            // الانتقال إلى صفحة NewChildrenPage عند النجاح
            Navigator.pushReplacementNamed(
              context,
              RoutesManager.newChildrenPage, // استبدل بالمسار الصحيح
            );
          }
        },
        child: Scaffold(
          body: Stack(
            children: [
              const AnimatedWelcomeBackground(),
              SafeArea(
                child: BlocBuilder<CodeCubit, CodeState>(
                  builder: (context, state) {
                    return SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.15,
                            width: MediaQuery.of(context).size.width,
                          ),
                          _buildAnimatedContent(state),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedContent(CodeState state) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            const AnimatedLogo(),
            const SizedBox(height: 40),
            _buildTitle(state),

            const SizedBox(height: 20),
            _buildSubtitle(state),
            const SizedBox(height: 50),
            if (state is CodeLoading)
              _buildLoadingIndicator()
            else if (state is CodeFailure || state is CodeInitial)
              _buildCodeInputForm(state),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(CodeState state) {
    String title = "تفعيل الحساب";
    if (state is CodeLoading) {
      title = "جاري التحقق...";
    } else if (state is CodeSuccess) {
      title = "تم التفعيل بنجاح!";
    }

    return Text(
      title,
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
      textAlign: TextAlign.center,
    );
  }

  Widget _buildSubtitle(CodeState state) {
    String subtitle = "الرجاء إدخال كود التفعيل للمتابعة";
    if (state is CodeLoading) {
      subtitle = "جاري التحقق من صحة الكود...";
    } else if (state is CodeSuccess) {
      subtitle = "سيتم توجيهك تلقائياً...";
    } else if (state is CodeFailure) {
      subtitle = "حدث خطأ، يرجى المحاولة مرة أخرى";
    }

    return Text(
      subtitle,
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

  Widget _buildLoadingIndicator() {
    return Column(
      children: [
        CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            ColorManager.white,
          ),
          strokeWidth: 3.0,
        ),
        const SizedBox(height: 20),
        Text(
          "جاري التحقق من الكود...",
          style: getRegularStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildCodeInputForm(CodeState state) {
    return Column(
      children: [
        _buildCodeInputField(state),
        if (state is CodeFailure) ...[
          const SizedBox(height: 20),
          _buildErrorMessage(state),
        ],
        const SizedBox(height: 40),
        _buildActivateButton(),
      ],
    );
  }

  Widget _buildCodeInputField(CodeState state) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: state is CodeFailure
              ? Colors.red.withOpacity(0.5)
              : Colors.white.withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: TextField(
        controller: _codeController,
        focusNode: _codeFocusNode,
        textAlign: TextAlign.center,
        style: getBoldStyle(
          color: Colors.white,
          fontSize: 24,
        ),
        decoration: InputDecoration(
          hintText: "أدخل كود التفعيل",
          hintStyle: getRegularStyle(
            color: Colors.white.withOpacity(0.5),
            fontSize: 18,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 20,
          ),
          prefixIcon: Icon(
            Icons.vpn_key_rounded,
            color: Colors.white.withOpacity(0.7),
            size: 28,
          ),
        ),
        keyboardType: TextInputType.text,
        textCapitalization: TextCapitalization.characters,
        onSubmitted: (_) => _handleActivate(),
      ),
    );
  }

  Widget _buildErrorMessage(CodeFailure state) {
    // استخراج رسالة الخطأ من الاستثناء
    String errorMessage = "لا يوجد كود مفعل لك";

    try {
      final exception = state.exception.toString();
      if (exception.contains('message')) {
        // محاولة استخراج الرسالة من الاستثناء
        errorMessage = exception;
      }
    } catch (e) {
      // استخدام الرسالة الافتراضية
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.red.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: Colors.red.shade300,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              errorMessage,
              style: getRegularStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivateButton() {
    return GestureDetector(
      onTap: _handleActivate,
      child: Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white,
              Colors.white.withOpacity(0.9),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
              spreadRadius: 2,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(30),
            onTap: _handleActivate,
            child: Container(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "تفعيل",
                    style: getBoldStyle(
                      color: const Color(0xFF667eea),
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Icon(
                    Icons.check_circle_outline,
                    color: Color(0xFF667eea),
                    size: 24,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleActivate() {
    final code = _codeController.text.trim();

    if (code.isEmpty) {
      _showSnackBar("الرجاء إدخال كود التفعيل", Colors.orange);
      _codeFocusNode.requestFocus();
      return;
    }

    // إخفاء لوحة المفاتيح
    FocusScope.of(context).unfocus();

    // استدعاء التحقق من الكود
    viewModel.checkCode(code);
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: getRegularStyle(color: Colors.white, fontSize: 14),
        ),
        backgroundColor: color.withOpacity(0.8),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}