import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wise_child/assets_manager.dart';
import 'package:wise_child/core/resources/app_constants.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'package:wise_child/core/resources/routes_manager.dart';
import 'package:wise_child/core/resources/style_manager.dart';
import 'package:wise_child/core/resources/values_manager.dart';
import 'package:wise_child/core/widgets/movable_icon_button.dart';
import 'package:wise_child/features/layout/presentation/cubit/layout_cubit.dart';
import 'package:wise_child/features/layout/presentation/widgets/custom_button_navigation_bar.dart';
import 'package:wise_child/l10n/app_localizations.dart';

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
        return Scaffold(
          body: Stack(
            children: [
              AppConstants.viewOptions[cubit.index],
              Align(
                alignment: Alignment.bottomCenter,
                child: CustomBottomNavigationBar(
                  currentIndex: cubit.index,
                  onItemTapped: (index) {
                    setState(() {});
                    cubit.changeIndex(index);
                  },
                ),
              ),
              MovableIcon(
                onTap: () {
                  // if (cubit.index == 1) {
                  //   Navigator.pushNamed(context, RoutesManager.chatBotAddChildScreen);
                  //   return;
                  // }
                  Navigator.pushNamed(context, RoutesManager.chatBotAssistantScreen);


                },
              ),
            ],
          ),
        );
      },
    );
  }
}

