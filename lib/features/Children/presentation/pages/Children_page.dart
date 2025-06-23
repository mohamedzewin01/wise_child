import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:wise_child/core/widgets/custom_app_bar.dart';
import 'package:wise_child/core/widgets/custom_app_bar2.dart';
import 'package:wise_child/features/Children/data/models/response/get_children_dto.dart';
import 'package:wise_child/features/Children/presentation/widgets/child_card.dart';
import 'package:wise_child/features/Children/presentation/widgets/skeletonizer_children.dart';
import 'package:wise_child/features/NewChildren/presentation/pages/NewChildren_page.dart';
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
        backgroundColor: Colors.white,
        body: CustomScrollView(
          slivers: [

            SliverCustomAppBar(
              iconActionOne: Icons.add,
              onTapActionTow: () async {
                final result = await Navigator.push(
                  context,
                  CupertinoPageRoute(builder: (context) => NewChildrenPage()),
                );
                if (result == true && context.mounted) {
                  context.read<ChildrenCubit>().getChildrenByUser();
                }
              },
            ),

            SliverToBoxAdapter(
              child: BlocBuilder<ChildrenCubit, ChildrenState>(
                builder: (context, state) {
                  if (state is ChildrenSuccess) {
                    List<Children> children =
                        state.getChildrenEntity.children ?? [];
                    return children.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.only(
                              bottom: kBottomNavigationBarHeight,
                              right: 16,
                              left: 16,
                            ),
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.only(
                                top: 8.0,
                                bottom: 8.0,
                              ),
                              itemCount: children.length,
                              itemBuilder: (context, index) {
                                return ChildCard(children: children[index]);
                              },
                            ),
                          )
                        : const Center(child: Text('No Children'));
                  }
                  if (state is ChildrenFailure) {
                    return const Center(child: Text('No Children'));
                  }

                  return SkeChildren();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//NetworkImage('https://i.pravatar.cc/300'),


