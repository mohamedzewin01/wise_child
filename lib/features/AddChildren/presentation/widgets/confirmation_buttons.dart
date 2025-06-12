import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wise_child/features/AddChildren/data/models/request/add_child_request.dart';
import 'package:wise_child/features/AddChildren/presentation/bloc/AddChildren_cubit.dart';

import '../../../../core/di/di.dart';

class ConfirmationButtons extends StatefulWidget {
  const ConfirmationButtons({super.key, required this.addChildRequest});
final  AddChildRequest addChildRequest;
  @override
  State<ConfirmationButtons> createState() => _ConfirmationButtonsState();
}

class _ConfirmationButtonsState extends State<ConfirmationButtons> {
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
      child: Row(
        key: UniqueKey(),
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton.icon(
            icon: const Icon(Icons.check_circle),
            label: const Text("تأكيد وحفظ"),
            onPressed: () {

              viewModel.addChild(widget.addChildRequest);

            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          ),
          const SizedBox(width: 16),
          OutlinedButton.icon(
            icon: const Icon(Icons.refresh),
            label: const Text("البدء من جديد"),
            onPressed: () {
              AddChildRequest addChildRequest = AddChildRequest();
viewModel.addChild(AddChildRequest());
            },
            style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
          ),
        ],
      ),
    );
  }
}