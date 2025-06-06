import 'package:flutter/material.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'package:wise_child/localization/locale_cubit.dart';

class ChangeLanguage extends StatelessWidget {
  const ChangeLanguage({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        transitionBuilder: (child, animation) => RotationTransition(
          turns: Tween<double>(begin: 0.8, end: 1.0).animate(animation),
          child: FadeTransition(opacity: animation, child: child),
        ),
        child: Icon(
          Icons.language,
          key: ValueKey(LocaleCubit.get(context).state.languageCode),
          size: 20,
          color: ColorManager.chatUserBg,
        ),
      ),
      onPressed: () {
        final currentLang = LocaleCubit.get(context).state.languageCode;
        final newLang = currentLang == 'en' ? 'ar' : 'en';

        /// Trigger language change
        LocaleCubit.get(context).changeLanguage(newLang);
      },
    );
  }
}
