import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wise_child/core/widgets/custom_app_bar.dart';

import '../../../../core/di/di.dart';
import '../bloc/Home_cubit.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomeCubit viewModel;

  @override
  void initState() {
    viewModel = getIt.get<HomeCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: viewModel,
      child: CustomBackGround(
        child: Stack(
          children: [
            CustomAppBar(),
            Scaffold(
              backgroundColor: Colors.transparent,
              body: const Center(child: Text('Hello Home')),
            ),
          ],
        ),
      ),
    );
  }
}


class CustomBackGround extends StatelessWidget {
  final Widget child;

  const CustomBackGround({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF667eea), Color(0xFF764ba2), Color(0xFF6B73FF)],
          stops: [0.0, 0.5, 1.0],
        ),
      ),
      child: child,
    );
  }
}
