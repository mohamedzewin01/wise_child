import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/di.dart';
import '../bloc/StoryDetails_cubit.dart';

class StoryDetailsPage extends StatefulWidget {
  const StoryDetailsPage({super.key});

  @override
  State<StoryDetailsPage> createState() => _StoryDetailsPageState();
}

class _StoryDetailsPageState extends State<StoryDetailsPage> {

  late StoryDetailsCubit viewModel;

  @override
  void initState() {
    viewModel = getIt.get<StoryDetailsCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: viewModel,
      child: Scaffold(
        appBar: AppBar(title: const Text('StoryDetails')),
        body: const Center(child: Text('Hello StoryDetails')),
      ),
    );
  }
}

