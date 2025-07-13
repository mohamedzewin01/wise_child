
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
// import 'package:wise_child/assets_manager.dart';
// import 'package:wise_child/core/resources/app_constants.dart';
// import 'package:wise_child/core/resources/color_manager.dart';
// import 'package:wise_child/core/resources/style_manager.dart';
// import 'package:wise_child/core/resources/values_manager.dart';
// import 'package:wise_child/core/utils/helper.dart';
// import 'package:wise_child/l10n/app_localizations.dart';
//
//
// class CustomBottomNavigationBar extends StatelessWidget {
//   const CustomBottomNavigationBar({
//     super.key,
//     required this.currentIndex,
//     required this.onItemTapped,
//   });
//
//   final int currentIndex;
//   final Function(int) onItemTapped;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//
//       decoration: BoxDecoration(
//           color: ColorManager.white,
//           borderRadius: BorderRadius.only(topLeft: Radius.circular(16),topRight: Radius.circular(16)))
//       ,
//       child: BottomNavigationBar(
//         elevation: 6,
//         backgroundColor: ColorManager.background,
//
//         items: [
//           BottomNavigationBarItem(
//             icon: buildIcon(Assets.homeSvg, 0, currentIndex),
//             label: AppLocalizations.of(context)!.home,
//             backgroundColor: ColorManager.background,
//           ),
//           BottomNavigationBarItem(
//             icon: buildIcon(Assets.childrenSvg, 1, currentIndex),
//             label: AppLocalizations.of(context)!.children,
//             backgroundColor: ColorManager.background,
//           ),
//           BottomNavigationBarItem(
//             icon: buildIcon(Assets.storiesSvg, 2, currentIndex),
//             label: AppLocalizations.of(context)!.stories,
//             backgroundColor: ColorManager.background,
//           ),
//           BottomNavigationBarItem(
//             icon: buildIcon(Assets.settingSvg, 3, currentIndex),
//             label: AppLocalizations.of(context)!.setting,
//             backgroundColor: ColorManager.background,
//           ),
//
//         ],
//         selectedFontSize: AppSize.s14,
//         unselectedItemColor: ColorManager.chatAssistantText,
//         selectedItemColor: ColorManager.primaryColor,
//         selectedLabelStyle: getSemiBoldStyle(color: ColorManager.textSecondary),
//         unselectedLabelStyle: getSemiBoldStyle(color: ColorManager.textSecondary),
//         currentIndex: currentIndex,
//         onTap: onItemTapped,
//         type: BottomNavigationBarType.fixed,
//
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wise_child/assets_manager.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'package:wise_child/core/resources/style_manager.dart';
import 'package:wise_child/core/resources/values_manager.dart';
import 'package:wise_child/l10n/app_localizations.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onItemTapped,
  });

  final int currentIndex;
  final Function(int) onItemTapped;

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: const EdgeInsets.all(AppMargin.m16),
      decoration: BoxDecoration(
        color: ColorManager.white,
        borderRadius: BorderRadius.circular(AppSize.s20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSize.s20),
        child: BottomNavigationBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          items: [
            _buildNavItem(
              context,
              Assets.homeSvg,
              AppLocalizations.of(context)!.home,
              0,
            ),
            _buildNavItem(
              context,
              Assets.childrenSvg,
              AppLocalizations.of(context)!.children,
              1,
            ),
            _buildNavItem(
              context,
              Assets.storiesSvg,
              AppLocalizations.of(context)!.stories,
              2,
            ),

            _buildNavItem(
              context,
              Assets.storiesSvg,
              AppLocalizations.of(context)!.stories,
              3,
            ),
            _buildNavItem(
              context,
              Assets.settingSvg,
              AppLocalizations.of(context)!.setting,
              4,
            ),
          ],
          selectedFontSize: AppSize.s12,
          unselectedFontSize: AppSize.s10,
          selectedItemColor: ColorManager.primaryColor,
          unselectedItemColor: ColorManager.grey,
          selectedLabelStyle: getSemiBoldStyle(
            color: ColorManager.primaryColor,
            fontSize: AppSize.s12,
          ),
          unselectedLabelStyle: getRegularStyle(
            color: ColorManager.grey,
            fontSize: AppSize.s10,
          ),
          currentIndex: currentIndex,
          onTap: onItemTapped,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: true,
          showUnselectedLabels: true,
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(
      BuildContext context,
      String iconPath,
      String label,
      int index,
      ) {
    final bool isSelected = currentIndex == index;

    return BottomNavigationBarItem(
      icon: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppPadding.p12,
          vertical: AppPadding.p8,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? ColorManager.primaryColor.withOpacity(0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(AppSize.s12),
        ),
        child: SvgPicture.asset(
          iconPath,
          width: AppSize.s24,
          height: AppSize.s24,
          colorFilter: ColorFilter.mode(
            isSelected ? ColorManager.primaryColor : ColorManager.grey,
            BlendMode.srcIn,
          ),
        ),
      ),
      label: label,
    );
  }
}

// // دالة مساعدة لبناء الأيقونات (إذا كنت تحتاجها في مكان آخر)
// Widget buildIcon(String iconPath, int index, int currentIndex) {
//   final bool isSelected = currentIndex == index;
//
//   return Container(
//     padding: const EdgeInsets.symmetric(
//       horizontal: AppPadding.p8,
//       vertical: AppPadding.p4,
//     ),
//     decoration: BoxDecoration(
//       color: isSelected
//           ? ColorManager.primaryColor.withOpacity(0.15)
//           : Colors.transparent,
//       borderRadius: BorderRadius.circular(AppSize.s8),
//     ),
//     child: SvgPicture.asset(
//       iconPath,
//       width: AppSize.s24,
//       height: AppSize.s24,
//       colorFilter: ColorFilter.mode(
//         isSelected ? ColorManager.primaryColor : ColorManager.grey,
//         BlendMode.srcIn,
//       ),
//     ),
//   );
// }