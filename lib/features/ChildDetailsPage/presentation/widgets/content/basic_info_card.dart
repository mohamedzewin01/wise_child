import 'package:flutter/material.dart';
import 'package:wise_child/core/functions/gender_to_text.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'package:wise_child/core/utils/date_formatter.dart';
import 'package:wise_child/features/ChildDetailsPage/presentation/widgets/app_bar/child_details_app_bar.dart';
import 'package:wise_child/features/ChildDetailsPage/presentation/widgets/components/info_row_widget.dart';
import 'package:wise_child/features/ChildDetailsPage/presentation/widgets/floating_actions/child_details_floating_actions.dart';
import 'package:wise_child/features/Children/data/models/response/get_children_dto.dart';


class BasicInfoCard extends StatelessWidget {
  final Children child;
  final String ageString;
  final String languageCode;

  const BasicInfoCard({
    super.key,
    required this.child,
    required this.ageString,
    required this.languageCode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: _buildCardDecoration(),
      child: Column(
        children: [
          _buildHeader(),
          _buildContent(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _buildHeaderDecoration(),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: ColorManager.primaryColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.person_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            'المعلومات الأساسية',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          InfoRowWidget(
            icon: Icons.cake_rounded,
            label: 'العمر',
            value:DateFormatter.calculateAge(child.dateOfBirth ?? '',languageCode:languageCode ),
            color: Colors.orange,
          ),
          const SizedBox(height: 16),
          InfoRowWidget(
            icon: _getGenderIcon(),
            label: 'الجنس',
            value: genderToText(child.gender ?? '', languageCode),
            color: _getGenderColor(),
          ),
          const SizedBox(height: 16),
          InfoRowWidget(
            icon: Icons.calendar_today_rounded,
            label: 'تاريخ الميلاد',
            value: DateFormatter.formatDateDisplay(child.dateOfBirth ?? '',languageCode:languageCode ),
            color: Colors.green,
          ),
          if (child.emailChildren?.isNotEmpty == true) ...[
            const SizedBox(height: 16),
            InfoRowWidget(
              icon: Icons.email_rounded,
              label: 'البريد الإلكتروني',
              value: child.emailChildren ?? '',
              color: Colors.purple,
            ),
          ],
        ],
      ),
    );
  }

  IconData _getGenderIcon() {
    return child.gender?.toLowerCase() == 'male'
        ? Icons.male_rounded
        : Icons.female_rounded;
  }

  Color _getGenderColor() {
    return child.gender?.toLowerCase() == 'male'
        ? Colors.blue
        : Colors.pink;
  }

  BoxDecoration _buildCardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          offset: const Offset(0, 4),
          blurRadius: 15,
        ),
      ],
    );
  }

  BoxDecoration _buildHeaderDecoration() {
    return BoxDecoration(
      color: ColorManager.primaryColor.withOpacity(0.05),
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
    );
  }
}