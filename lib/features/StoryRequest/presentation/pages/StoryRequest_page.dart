import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/di.dart';
import '../bloc/StoryRequest_cubit.dart';

class StoryRequestPage extends StatefulWidget {
  const StoryRequestPage({super.key});

  @override
  State<StoryRequestPage> createState() => _StoryRequestPageState();
}

class _StoryRequestPageState extends State<StoryRequestPage> {

  late StoryRequestCubit viewModel;

  @override
  void initState() {
    viewModel = getIt.get<StoryRequestCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: viewModel,
      child: Scaffold(
        appBar: AppBar(title: const Text('StoryRequest')),
        body: const Center(child: Text('Hello StoryRequest')),
      ),
    );
  }
}

