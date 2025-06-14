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
      decoration: BoxDecoration(
        color: ColorManager.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: BottomNavigationBar(
        // elevation: 6,
        backgroundColor: Colors.white,

        items: [
          BottomNavigationBarItem(
            icon: buildIcon(Assets.homeSvg, 0, currentIndex),
            label: AppLocalizations.of(context)!.home,
          ),
          BottomNavigationBarItem(
            icon: buildIcon(Assets.childrenSvg, 1, currentIndex),
            label: AppLocalizations.of(context)!.children,
          ),
          BottomNavigationBarItem(
            icon: buildIcon(Assets.storiesSvg, 2, currentIndex),
            label: AppLocalizations.of(context)!.stories,
          ),
          BottomNavigationBarItem(
            icon: buildIcon(Assets.settingSvg, 3, currentIndex),
            label: AppLocalizations.of(context)!.setting,
          ),
        ],
        selectedFontSize: AppSize.s14,
        selectedLabelStyle: getSemiBoldStyle(color: ColorManager.textSecondary),
        unselectedLabelStyle: getSemiBoldStyle(
          color: ColorManager.primaryColor,
        ),
        currentIndex: currentIndex,
        onTap: onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: ColorManager.primaryColor,
      ),
    );
  }
}

Widget buildIcon(String assetPath, int index, int currentIndex) {
  bool isSelected = index == currentIndex;

  return Container(
    padding: const EdgeInsets.symmetric(
      horizontal: AppPadding.p20,
      vertical: AppPadding.p4,
    ),
    decoration: BoxDecoration(
      color: isSelected
          ? ColorManager.primaryColor.withAlpha(100)
          : Colors.transparent,
      borderRadius: BorderRadius.circular(12),
    ),
    child: SvgPicture.asset(
      assetPath,
      width: 24,
      height: 24,
      colorFilter: ColorFilter.mode(
        isSelected ? ColorManager.primaryColor : ColorManager.textSecondary,
        BlendMode.srcIn,
      ),
    ),
  );
}
