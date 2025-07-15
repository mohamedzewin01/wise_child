import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/di.dart';
import '../bloc/StoriesUnderCategory_cubit.dart';

class StoriesUnderCategoryPage extends StatefulWidget {
  const StoriesUnderCategoryPage({super.key});

  @override
  State<StoriesUnderCategoryPage> createState() => _StoriesUnderCategoryPageState();
}

class _StoriesUnderCategoryPageState extends State<StoriesUnderCategoryPage> {

  late StoriesUnderCategoryCubit viewModel;

  @override
  void initState() {
    viewModel = getIt.get<StoriesUnderCategoryCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: viewModel,
      child: Scaffold(
        appBar: AppBar(title: const Text('StoriesUnderCategory')),
        body: const Center(child: Text('Hello StoriesUnderCategory')),
      ),
    );
  }
}

