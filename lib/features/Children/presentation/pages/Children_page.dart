import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:wise_child/core/resources/routes_manager.dart';
import 'package:wise_child/features/Children/data/models/response/get_children_dto.dart';
import 'package:wise_child/features/Children/presentation/widgets/child_card.dart';
import 'package:wise_child/features/Children/presentation/widgets/skeletonizer_children.dart';

import '../../../../core/di/di.dart';
import '../bloc/Children_cubit.dart';

class ChildrenPage extends StatefulWidget {
  const ChildrenPage({super.key});

  @override
  State<ChildrenPage> createState() => _ChildrenPageState();
}

class _ChildrenPageState extends State<ChildrenPage> {
  late ChildrenCubit viewModel;

  @override
  void initState() {
    viewModel = getIt.get<ChildrenCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: viewModel..getChildrenByUser(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Children'),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: ()async {
                final result = await Navigator.pushNamed(context, RoutesManager.newChildrenPage);

                if (result == true && context.mounted) {
                  context.read<ChildrenCubit>().getChildrenByUser();
                }
              },
            ),
          ],

        ),

        body: BlocBuilder<ChildrenCubit, ChildrenState>(
          builder: (context, state) {
            if (state is ChildrenSuccess) {
              List<Children> children = state.getChildrenEntity.children ?? [];
              return children.isNotEmpty ? ListView.builder(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                itemCount: children.length,
                itemBuilder: (context, index) {

                  return ChildCard(children: children[index]);
                },
              ): const Center(child: Text('No Children'),);
            }
            if (state is ChildrenFailure) {
              return const Center(child: Text('No Children'),);
            }

            return SkeChildren();
          },
        ),
      ),
    );
  }
}

//NetworkImage('https://i.pravatar.cc/300'),
