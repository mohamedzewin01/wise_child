import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/di.dart';
import '../bloc/StoryInfo_cubit.dart';

class StoryInfoPage extends StatefulWidget {
  const StoryInfoPage({super.key});

  @override
  State<StoryInfoPage> createState() => _StoryInfoPageState();
}

class _StoryInfoPageState extends State<StoryInfoPage> {

  late StoryInfoCubit viewModel;

  @override
  void initState() {
    viewModel = getIt.get<StoryInfoCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: viewModel,
      child: Scaffold(
        appBar: AppBar(title: const Text('StoryInfo')),
        body: const Center(child: Text('Hello StoryInfo')),
      ),
    );
  }
}

