import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wise_child/core/functions/calculate_age.dart';
import 'package:wise_child/core/functions/gender_to_text.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'package:wise_child/core/resources/style_manager.dart';
import 'package:wise_child/core/resources/values_manager.dart';
import 'package:wise_child/core/widgets/delete_confirmation_dialog.dart';
import 'package:wise_child/features/ChildDetailsPage/presentation/pages/ChildDetailsPage_page.dart';
import 'package:wise_child/features/Children/data/models/response/get_children_dto.dart';
import 'package:wise_child/features/Children/presentation/bloc/Children_cubit.dart';
import 'package:wise_child/features/Children/presentation/widgets/avatar_image.dart';
import 'package:wise_child/l10n/app_localizations.dart';

import '../../../../core/di/di.dart';
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
    return  InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return BlocProvider.value(
              value: getIt.get<ChildrenCubit>(),
              child: ChildDetailsPage(child:children),
            );
          },
        ));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: const [
            BoxShadow(
              color: Colors.white,
              offset: Offset(-2, -2),
              blurRadius: 4,
              spreadRadius: 1,
            ),
            BoxShadow(
              color: Colors.black12,
              offset: Offset(2, 2),
              blurRadius: 4,
              spreadRadius: 1,
            ),
          ],
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
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: getBoldStyle(
                      color: ColorManager.primaryColor,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    ageString,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: getSemiBoldStyle(
                      color: ColorManager.textSecondary.withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        children.gender?.toLowerCase() == 'male'
                            ? Icons.male
                            : Icons.female,
                        size: 16,
                        color: children.gender?.toLowerCase() == 'male'
                            ? Colors.blue.shade400
                            : Colors.pink.shade400,
                      ),
                      const SizedBox(width: 4.0),
                      Text(
                        genderToText(children.gender ?? '', languageCode),
                        style: getSemiBoldStyle(
                          color: ColorManager.textSecondary.withOpacity(0.8),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),

                ],
              ),
              const Spacer(),
              Row(
                children: [
                  _buildActionButton(
                    icon: Icons.edit_rounded,
                    color: ColorManager.primaryColor,
                    onTap: () {
                      // context.read<ChildrenCubit>().editChild(widget.children);
                    },
                    tooltip: 'تعديل',
                  ),

                  const SizedBox(width: 8.0),

                  _buildActionButton(
                    icon: Icons.delete_rounded,
                    color: ColorManager.red,
                    onTap: () {
                      _showDeleteConfirmation(context);
                    },
                    tooltip: 'حذف',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(
                color: color.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
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
  }
}

