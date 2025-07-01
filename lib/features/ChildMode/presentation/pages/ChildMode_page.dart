import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/di.dart';
import '../bloc/ChildMode_cubit.dart';

class ChildModePage extends StatefulWidget {
  const ChildModePage({super.key});

  @override
  State<ChildModePage> createState() => _ChildModePageState();
}

class _ChildModePageState extends State<ChildModePage> {

  late ChildModeCubit viewModel;

  @override
  void initState() {
    viewModel = getIt.get<ChildModeCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: viewModel,
      child: Scaffold(
        appBar: AppBar(title: const Text('ChildMode')),
        body: const Center(child: Text('Hello ChildMode')),
      ),
    );
  }
}

