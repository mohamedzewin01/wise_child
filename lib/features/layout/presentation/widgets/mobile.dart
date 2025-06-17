
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wise_child/features/layout/presentation/cubit/layout_cubit.dart';
import 'package:wise_child/features/layout/presentation/widgets/custom_button_navigation_bar.dart';


class LayoutMobileView extends StatefulWidget {
  const LayoutMobileView({super.key});

  @override
  State<LayoutMobileView> createState() => _LayoutMobileViewState();
}

class _LayoutMobileViewState extends State<LayoutMobileView> {
  @override
  Widget build(BuildContext context) {
    var cubit = LayoutCubit.get(context);
    return BlocBuilder<LayoutCubit, LayoutState>(
      builder: (context, state) {
        return Stack(
          children: [
            GradientBackground(
              child: Scaffold(
                  backgroundColor: Colors.transparent,
                  resizeToAvoidBottomInset: false,
                  body: CustomBottomNavigationBar()
              ),
            )
          ],
        );
      },
    );
  }
}

