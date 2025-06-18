import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wise_child/core/functions/calculate_age.dart';
import 'package:wise_child/core/functions/gender_to_text.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'package:wise_child/core/resources/style_manager.dart';
import 'package:wise_child/core/resources/values_manager.dart';
import 'package:wise_child/core/widgets/delete_confirmation_dialog.dart';
import 'package:wise_child/features/Children/data/models/response/get_children_dto.dart';
import 'package:wise_child/features/Children/presentation/bloc/Children_cubit.dart';
import 'package:wise_child/features/Children/presentation/widgets/avatar_image.dart';
import 'package:wise_child/l10n/app_localizations.dart';

import '../../../../localization/locale_cubit.dart';

class ChildCard extends StatelessWidget {
  const ChildCard({super.key, required this.children});

  final Children children;

  @override
  Widget build(BuildContext context) {
    final languageCode = LocaleCubit.get(context).state.languageCode;

    final ageString = calculateAgeInYearsAndMonths(
      children.dateOfBirth ?? '',
      languageCode,
    );
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.grey.shade500, width: 1.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            AvatarWidget(
              firstName: children.firstName ?? '',
              lastName: children.lastName ?? '',
              backgroundColor: Colors.purple.shade300,
              textColor: Colors.white,
              imageUrl: children.imageUrl,
              radius: 30.0,
            ),
            const SizedBox(width: 16.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${children.firstName} ${children.lastName}',
                  style: getMediumStyle(
                    color: ColorManager.white,
                    fontSize: 16,
                  ),
                ),
                Text(
                  ageString,
                  style: getSemiBoldStyle(
                    color: ColorManager.white.withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '${AppLocalizations.of(context)!.gender} : ',
                        style: getSemiBoldStyle(
                          color: ColorManager.white.withOpacity(0.7),
                          fontSize: AppSize.s14,
                        ),
                      ),
                      TextSpan(
                        text: genderToText(children.gender ?? '', languageCode),
                        style: getSemiBoldStyle(
                          color: ColorManager.white.withOpacity(0.7),
                          fontSize: AppSize.s14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // زر التعديل
                InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () {
                    // context.read<ChildrenCubit>().editChild(children);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Icon(
                      Icons.edit_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                // زر الحذف
                InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () {
                    DeleteConfirmationDialog.show(
                      context,
                      childName: '${children.firstName} ${children.lastName}',
                      onConfirm: () async {
                        await context.read<ChildrenCubit>().deleteChild(
                          children.idChildren!,
                        );
                      },
                      onCancel: () {},
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10.0),

                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Icon(
                      Icons.delete_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
