import 'package:flutter/material.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'package:wise_child/core/resources/style_manager.dart';
import 'package:wise_child/core/resources/values_manager.dart';
import 'package:wise_child/l10n/app_localizations.dart';

class GenderSelector extends StatelessWidget {
  final String? selectedGender;
  final Function(String) onGenderChanged;

  const GenderSelector({
    super.key,
    required this.selectedGender,
    required this.onGenderChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.gender,
          style: getMediumStyle(
            color: ColorManager.darkGrey,
            fontSize: AppSize.s14,
          ),
        ),
        const SizedBox(height: AppSize.s8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: ColorManager.grey.withOpacity(0.5),
            ),
            borderRadius: BorderRadius.circular(AppSize.s12),
            color: Colors.white,
          ),
          child: Row(
            children: [
              Expanded(
                child: _buildGenderOption(
                  context,
                  'male',
                  AppLocalizations.of(context)!.male,
                  Icons.male,
                ),
              ),
              Container(
                width: 1,
                height: AppSize.s48,
                color: ColorManager.grey.withOpacity(0.3),
              ),
              Expanded(
                child: _buildGenderOption(
                  context,
                  'female',
                  AppLocalizations.of(context)!.female,
                  Icons.female,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGenderOption(
      BuildContext context,
      String value,
      String label,
      IconData icon,
      ) {
    final isSelected = selectedGender == value;

    return GestureDetector(
      onTap: () => onGenderChanged(value),
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: AppPadding.p12,
          horizontal: AppPadding.p8,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? ColorManager.primaryColor.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(AppSize.s12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? ColorManager.primaryColor
                  : ColorManager.grey,
              size: AppSize.s20,
            ),
             SizedBox(width: AppSize.s5),
            Text(
              label,
              style: getMediumStyle(
                color: isSelected
                    ? ColorManager.primaryColor
                    : ColorManager.grey,
                fontSize: AppSize.s12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}