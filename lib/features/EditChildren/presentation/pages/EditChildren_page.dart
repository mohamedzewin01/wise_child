import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/di.dart';
import '../bloc/EditChildren_cubit.dart';

class EditChildrenPage extends StatefulWidget {
  const EditChildrenPage({super.key});

  @override
  State<EditChildrenPage> createState() => _EditChildrenPageState();
}

class _EditChildrenPageState extends State<EditChildrenPage> {

  late EditChildrenCubit viewModel;

  @override
  void initState() {
    viewModel = getIt.get<EditChildrenCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: viewModel,
      child: Scaffold(
        appBar: AppBar(title: const Text('EditChildren')),
        body: const Center(child: Text('Hello EditChildren')),
      ),
    );
  }
}

