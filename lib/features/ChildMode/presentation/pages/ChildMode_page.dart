// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// import '../../../../core/di/di.dart';
// import '../bloc/ChildMode_cubit.dart';
//
// class ChildModePage extends StatefulWidget {
//   const ChildModePage({super.key});
//
//   @override
//   State<ChildModePage> createState() => _ChildModePageState();
// }
//
// class _ChildModePageState extends State<ChildModePage> {
//
//   late ChildModeCubit viewModel;
//
//   @override
//   void initState() {
//     viewModel = getIt.get<ChildModeCubit>();
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider.value(
//       value: viewModel,
//       child: Scaffold(
//         appBar: AppBar(title: const Text('ChildMode')),
//         body: const Center(child: Text('Hello ChildMode')),
//       ),
//     );
//   }
// }
//


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'package:wise_child/features/Stories/presentation/bloc/ChildrenStoriesCubit/children_stories_cubit.dart';
import 'package:wise_child/features/Stories/presentation/bloc/Stories_cubit.dart';
import '../../../../core/di/di.dart';
import '../widgets/ChildBackground.dart';
import '../widgets/ChildHeader.dart';
import '../widgets/ChildStoryGrid.dart';
import '../widgets/FloatingExitButton.dart';

class ChildModePage extends StatefulWidget {
  const ChildModePage({super.key});

  @override
  State<ChildModePage> createState() => _ChildModePageState();
}

class _ChildModePageState extends State<ChildModePage>
    with TickerProviderStateMixin {
  late StoriesCubit storiesCubit;
  late ChildrenStoriesCubit childrenStoriesCubit;
  late AnimationController _backgroundController;
  late AnimationController _entranceController;
  late Animation<double> _backgroundAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    storiesCubit = getIt.get<StoriesCubit>();
    childrenStoriesCubit = getIt.get<ChildrenStoriesCubit>();

    _backgroundController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    );

    _entranceController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _backgroundAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _backgroundController,
      curve: Curves.linear,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _entranceController,
      curve: Curves.elasticOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
    ));

    _startAnimations();
    _loadData();
  }

  void _startAnimations() {
    _backgroundController.repeat();
    _entranceController.forward();
  }

  Future<void> _loadData() async {
    await storiesCubit.getChildrenByUser();
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _entranceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: storiesCubit),
        BlocProvider.value(value: childrenStoriesCubit),
      ],
      child: Scaffold(
        body: AnimatedBuilder(
          animation: Listenable.merge([_backgroundAnimation, _entranceController]),
          builder: (context, child) {
            return Stack(
              children: [
                // خلفية متحركة ملونة للأطفال
                ChildBackground(animation: _backgroundAnimation),

                // المحتوى الرئيسي
                SafeArea(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Column(
                        children: [
                          // رأس الصفحة مع ترحيب بالطفل
                          const ChildHeader(),

                          // قائمة القصص
                          // const Expanded(
                          //   child: ChildStoryGrid(),
                          // ),
                        ],
                      ),
                    ),
                  ),
                ),

                // زر الخروج العائم (للأولياء فقط)
                const FloatingExitButton(),

                // شاشة الترحيب الأولى
                if (_entranceController.value < 0.5)
                  _buildWelcomeOverlay(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildWelcomeOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.8),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // رسوم متحركة ترحيبية
            TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 2000),
              tween: Tween(begin: 0.0, end: 1.0),
              builder: (context, value, child) {
                return Transform.scale(
                  scale: 0.5 + (value * 0.5),
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.yellow.shade300,
                          Colors.orange.shade300,
                          Colors.pink.shade300,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orange.withOpacity(0.6),
                          blurRadius: 30,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                    child:  Icon(
                      Icons.auto_stories_rounded,
                      size: 80,
                      color: Colors.white,
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 30),

            // نص الترحيب
            ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [
                  Colors.yellow.shade300,
                  Colors.orange.shade300,
                  Colors.pink.shade300,
                ],
              ).createShader(bounds),
              child: const Text(
                'أهلاً وسهلاً! 🌟',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 15),

            const Text(
              'وقت القصص الممتعة!',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 40),

            // مؤشر التحميل اللطيف
            Container(
              width: 60,
              height: 60,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.yellow.shade300,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}