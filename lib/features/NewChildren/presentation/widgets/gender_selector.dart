

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'package:wise_child/core/resources/style_manager.dart';
import 'package:wise_child/features/NewChildren/presentation/bloc/NewChildren_cubit.dart';
import 'package:wise_child/features/NewChildren/presentation/widgets/section_header.dart';
import 'package:wise_child/l10n/app_localizations.dart';




class GenderToggle extends StatefulWidget {
  const GenderToggle({super.key});

  @override
  State<GenderToggle> createState() => _GenderToggleState();
}

class _GenderToggleState extends State<GenderToggle> {
  bool isMaleSelected = true; // الافتراضي: ذكر

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return Center(
      child: Column(
        children: [
          SectionHeader(
            title: AppLocalizations.of(context)!.gender,
          ),
          Container(
            height: 50,
            width: double.infinity,
            decoration: BoxDecoration(
              color: ColorManager.primaryColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Stack(
              children: [
                // ✅ الخلفية المتحركة تحت الزر المحدد
                AnimatedAlign(
                  duration: const Duration(milliseconds: 200),
                  alignment: isMaleSelected
                      ? AlignmentDirectional.centerStart
                      : AlignmentDirectional.centerEnd,
                  child: Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width / 2 - 32,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                ),

                // ✅ زرّا الاختيار
                Row(
                  children: [
                    // ذكر
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            context.read<NewChildrenCubit>().gender = 'Male';
                            isMaleSelected = true;
                          });
                        },
                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.male,
                                size: 20,
                                color: isMaleSelected
                                    ? Colors.blueAccent
                                    : Colors.grey,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                AppLocalizations.of(context)!.genderBoy,
                                style: getBoldStyle(
                                  color: isMaleSelected
                                      ? Colors.blueAccent
                                      : Colors.grey,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // أنثى
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            context.read<NewChildrenCubit>().gender = 'Female';
                            isMaleSelected = false;
                          });
                        },
                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.female,
                                size: 20,
                                color: !isMaleSelected
                                    ? Colors.pinkAccent
                                    : Colors.grey,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                AppLocalizations.of(context)!.genderGirl,
                                style: getBoldStyle(
                                  color: !isMaleSelected
                                      ? Colors.pinkAccent
                                      : Colors.grey,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
