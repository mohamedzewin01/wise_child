import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wise_child/features/Children/data/models/response/get_children_dto.dart';

import '../../../../core/di/di.dart';
import '../bloc/SelectStoriesScreen_cubit.dart';

class SelectStoriesScreenPage extends StatefulWidget {
  const SelectStoriesScreenPage({super.key, required this.child});
  final Children child;
  @override
  State<SelectStoriesScreenPage> createState() => _SelectStoriesScreenPageState();
}

class _SelectStoriesScreenPageState extends State<SelectStoriesScreenPage> {

  late SelectStoriesScreenCubit viewModel;


  @override
  void initState() {
    viewModel = getIt.get<SelectStoriesScreenCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: viewModel,
      child: Scaffold(
        appBar: AppBar(title: const Text('SelectStoriesScreen')),
        body: const Center(child: Text('Hello SelectStoriesScreen')),
      ),
    );
  }
}

