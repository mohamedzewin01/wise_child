import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/di.dart';
import '../bloc/Analysis_cubit.dart';

class AnalysisPage extends StatefulWidget {
  const AnalysisPage({super.key});

  @override
  State<AnalysisPage> createState() => _AnalysisPageState();
}

class _AnalysisPageState extends State<AnalysisPage> {

  late AnalysisCubit viewModel;

  @override
  void initState() {
    viewModel = getIt.get<AnalysisCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: viewModel,
      child: Scaffold(
        appBar: AppBar(title: const Text('Analysis')),
        body: const Center(child: Text('Hello Analysis')),
      ),
    );
  }
}

