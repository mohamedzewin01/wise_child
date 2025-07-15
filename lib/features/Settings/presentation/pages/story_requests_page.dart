
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wise_child/features/Settings/presentation/bloc/StoryRequestsCubit/story_requests_cubit.dart';

import '../../../../core/di/di.dart';

class StoryRequestsPage extends StatefulWidget {
  const StoryRequestsPage({super.key});

  @override
  State<StoryRequestsPage> createState() => _StoryRequestsPageState();
}

class _StoryRequestsPageState extends State<StoryRequestsPage> {
  late StoryRequestsCubit viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = getIt.get<StoryRequestsCubit>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: viewModel,
      child: Scaffold(
        appBar: AppBar(),
      ),
    );
  }
}