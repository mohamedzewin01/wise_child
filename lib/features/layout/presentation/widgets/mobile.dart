import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wise_child/core/resources/app_constants.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'package:wise_child/core/resources/routes_manager.dart';
import 'package:wise_child/core/widgets/movable_icon_button.dart';
import 'package:wise_child/features/layout/presentation/cubit/layout_cubit.dart';

class LayoutMobileView extends StatelessWidget {
  const LayoutMobileView({super.key});

  @override
  Widget build(BuildContext context) {
    var cubit = LayoutCubit.get(context);
    return BlocBuilder<LayoutCubit, LayoutState>(
      builder: (context, state) {
        return Scaffold(

          bottomNavigationBar: AnimatedBottomNavigationBar(
            icons: [Icons.home, Icons.event, Icons.settings],
            iconSize: 24,
            splashRadius: 20,
            // elevation: 1,
            height: 55,
            activeIndex: cubit.index,
            gapLocation: GapLocation.none,
            backgroundColor: ColorManager.appBackground,
            activeColor: ColorManager.primaryColor,
            inactiveColor:  ColorManager.primaryColor.withOpacity(0.5),
            rightCornerRadius: 25,
            leftCornerRadius: 25,
            notchSmoothness: NotchSmoothness.softEdge,
            onTap: (index) {
              cubit.changeIndex(index);
            },
          ),
          body: Stack(
            children: [
              AppConstants.viewOptions[cubit.index],
              MovableIcon(
                onTap: () {
                  if (cubit.index == 1) {
                    Navigator.pushNamed(context, RoutesManager.chatBotAddChildScreen);
                    return;
                  }
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
