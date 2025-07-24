import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/di.dart';
import '../bloc/ChildStories_cubit.dart';

class ChildStoriesPage extends StatefulWidget {
  const ChildStoriesPage({super.key});

  @override
  State<ChildStoriesPage> createState() => _ChildStoriesPageState();
}

class _ChildStoriesPageState extends State<ChildStoriesPage> {

  late ChildStoriesCubit viewModel;

  @override
  void initState() {
    viewModel = getIt.get<ChildStoriesCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: viewModel,
      child: Scaffold(
        appBar: AppBar(title: const Text('ChildStories')),
        body: const Center(child: Text('Hello ChildStories')),
      ),
    );
  }
}

