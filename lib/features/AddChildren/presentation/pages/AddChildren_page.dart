import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/di.dart';
import '../bloc/AddChildren_cubit.dart';

class AddChildrenPage extends StatefulWidget {
  const AddChildrenPage({super.key});

  @override
  State<AddChildrenPage> createState() => _AddChildrenPageState();
}

class _AddChildrenPageState extends State<AddChildrenPage> {

  late AddChildrenCubit viewModel;

  @override
  void initState() {
    viewModel = getIt.get<AddChildrenCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: viewModel,
      child: Scaffold(
        appBar: AppBar(title: const Text('AddChildren')),
        body: const Center(child: Text('Hello AddChildren')),
      ),
    );
  }
}

