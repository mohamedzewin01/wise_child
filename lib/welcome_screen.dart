import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'package:wise_child/core/resources/routes_manager.dart';
import 'package:wise_child/core/resources/style_manager.dart';
import 'package:wise_child/l10n/app_localizations.dart';

import 'core/widgets/Privacy_Policy.dart';
import 'core/widgets/animated_arrow_button.dart';
import 'core/widgets/change_language.dart';
import 'core/widgets/feature_row.dart';
import 'localization/locale_cubit.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.appBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 0.0),
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: ColorManager.cardBackground,
                        child: const Text("🧸", style: TextStyle(fontSize: 48)),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        AppLocalizations.of(context)!.appName,
                        style: getBoldStyle(
                          color: ColorManager.titleColor,
                          fontSize: 30,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        AppLocalizations.of(context)!.appSubtitle,
                        textAlign: TextAlign.center,
                        style: getBoldStyle(
                          color: ColorManager.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        FeatureRow(
                          circleBgColor: ColorManager.feature1Bg,
                          iconColor: ColorManager.feature1Icon,
                          text: AppLocalizations.of(context)!.personalizedStories,
                        ),
                        const SizedBox(height: 18),
                        FeatureRow(
                          circleBgColor: ColorManager.feature2Bg,
                          iconColor: ColorManager.feature2IconColor,
                          text: AppLocalizations.of(context)!.expertGuidedSolutions,
                        ),
                        const SizedBox(height: 18),
                        FeatureRow(
                          circleBgColor: ColorManager.feature3Bg,
                          iconColor: ColorManager.feature3Icon,
                          text: AppLocalizations.of(context)!.audioNarration,
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      AnimatedArrowButton(
                        onTap:  () {
                          Navigator.pushNamed(context, RoutesManager.authPage);
                        },
                        title: AppLocalizations.of(context)!.getStarted,

                      ),
                      const SizedBox(height: 20),
                      PrivacyPolicy(),
                      const SizedBox(height: 10),
                    ],
                  ),
                ],
              ),

              Positioned(
                top: 0,
                right: 0,
                child:  ChangeLanguage(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

