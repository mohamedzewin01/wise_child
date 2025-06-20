import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:wise_child/assets_manager.dart';
import 'package:wise_child/core/resources/app_constants.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'package:wise_child/core/resources/style_manager.dart';
import 'package:wise_child/l10n/app_localizations.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  final PersistentTabController _controller = PersistentTabController(
    initialIndex: 0,
  );

  @override
  Widget build(BuildContext context) {
    const double navIconSize = 28;
    return PersistentTabView(
      context,
      controller: _controller,
      screens: AppConstants.viewOptions,
      items: [
        PersistentBottomNavBarItem(
          icon: SvgPicture.asset(Assets.homeSvg),
          title: AppLocalizations.of(context)!.home,
          activeColorPrimary: ColorManager.primaryColor,
          inactiveColorPrimary: Colors.grey,
        ),
        PersistentBottomNavBarItem(
          icon: SvgPicture.asset(Assets.childrenSvg),
          title: AppLocalizations.of(context)!.children,
          activeColorPrimary: ColorManager.primaryColor,
          inactiveColorPrimary: Colors.grey,
        ),
        PersistentBottomNavBarItem(
          icon: SvgPicture.asset(Assets.storiesSvg),
          title: AppLocalizations.of(context)!.stories,
          activeColorPrimary: ColorManager.primaryColor,

          inactiveColorPrimary: Colors.grey,
        ),
        PersistentBottomNavBarItem(
          icon: SvgPicture.asset(Assets.settingSvg),
          opacity: .8,
          title: AppLocalizations.of(context)!.setting,
          activeColorPrimary: ColorManager.primaryColor,
          inactiveColorPrimary: Colors.grey,
        ),
      ],
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      hideNavigationBarWhenKeyboardAppears: true,
      popBehaviorOnSelectedNavBarItemPress: PopBehavior.once,

      backgroundColor: ColorManager.white,
      bottomScreenMargin: 10,
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(20),
        colorBehindNavBar: Colors.white,
        border: Border.all(color: Colors.grey.shade200, width: 1),
      ),
      isVisible: true,

      margin: EdgeInsets.all(8),
      confineToSafeArea: true,
      navBarHeight: kBottomNavigationBarHeight + 5,
      navBarStyle:
          NavBarStyle.style3, // Choose the nav bar style with this property
    );
  }
}




// class GradientBackground extends StatelessWidget {
//   final Widget child;
//
//   const GradientBackground({super.key, required this.child});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: const BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [Color(0xFF667eea), Color(0xFF764ba2), Color(0xFF6B73FF)],
//           stops: [0.0, 0.5, 1.0],
//         ),
//       ),
//       child: child,
//     );
//   }
// }
