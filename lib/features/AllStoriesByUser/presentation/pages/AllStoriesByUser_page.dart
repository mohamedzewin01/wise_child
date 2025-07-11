import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/di.dart';
import '../bloc/AllStoriesByUser_cubit.dart';

class AllStoriesByUserPage extends StatefulWidget {
  const AllStoriesByUserPage({super.key});

  @override
  State<AllStoriesByUserPage> createState() => _AllStoriesByUserPageState();
}

class _AllStoriesByUserPageState extends State<AllStoriesByUserPage> {

  late AllStoriesByUserCubit viewModel;

  @override
  void initState() {
    viewModel = getIt.get<AllStoriesByUserCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: viewModel,
      child: Scaffold(
        appBar: AppBar(title: const Text('AllStoriesByUser')),
        body: const Center(child: Text('Hello AllStoriesByUser')),
      ),
    );
  }
}

