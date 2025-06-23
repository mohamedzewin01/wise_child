import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wise_child/core/resources/app_constants.dart';
import 'package:wise_child/features/layout/presentation/widgets/custom_button_navigation_bar.dart';
import '../cubit/layout_cubit.dart';


class LayoutScreen extends StatefulWidget {
  const LayoutScreen({super.key});

  @override
  State<LayoutScreen> createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen> {
  @override
  Widget build(BuildContext context) {
    var cubit = LayoutCubit.get(context);
    return BlocBuilder<LayoutCubit, LayoutState>(
      builder: (context, state) {
        return Scaffold(
          body: AppConstants.viewOptions[cubit.index],
          bottomNavigationBar: CustomBottomNavigationBar(
            currentIndex: cubit.index,
            onItemTapped: (index) {
              cubit.changeIndex(index);
            },
          ),
        );
      },
    );
  }
}
