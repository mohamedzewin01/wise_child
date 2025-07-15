import 'package:flutter/material.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'package:wise_child/core/resources/style_manager.dart';
import 'package:wise_child/features/StoriesUnderCategory/data/models/response/stories_under_category_dto.dart';

class StoriesFilterSection extends StatelessWidget {
  final String selectedGender;
  final String selectedAgeGroup;
  final String sortBy;
  final Function(String) onGenderChanged;
  final Function(String) onAgeGroupChanged;
  final Function(String) onSortChanged;
  final bool isRTL;
  final List<Stories> allStories;

  const StoriesFilterSection({
    super.key,
    required this.selectedGender,
    required this.selectedAgeGroup,
    required this.sortBy,
    required this.onGenderChanged,
    required this.onAgeGroupChanged,
    required this.onSortChanged,
    required this.isRTL,
    required this.allStories,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 1000),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.grey.shade200,
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade100,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                    children: [
                      Icon(
                        Icons.filter_list,
                        color: ColorManager.primaryColor,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'تصفية وترتيب القصص',
                        style: getBoldStyle(
                          color: ColorManager.primaryColor,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Gender Filter
                  _buildFilterRow(
                    title: 'الجنس',
                    icon: Icons.person,
                    selectedValue: selectedGender,
                    options: _getGenderOptions(),
                    onChanged: onGenderChanged,
                  ),

                  const SizedBox(height: 12),

                  // Age Group Filter
                  _buildFilterRow(
                    title: 'الفئة العمرية',
                    icon: Icons.child_care,
                    selectedValue: selectedAgeGroup,
                    options: _getAgeGroupOptions(),
                    onChanged: onAgeGroupChanged,
                  ),

                  const SizedBox(height: 12),

                  // Sort Options
                  _buildFilterRow(
                    title: 'ترتيب حسب',
                    icon: Icons.sort,
                    selectedValue: sortBy,
                    options: [
                      'الأحدث',
                      'الأقدم',
                      'الأكثر مشاهدة',
                      'الأقل مشاهدة',
                      'الأبجدية',
                    ],
                    onChanged: onSortChanged,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFilterRow({
    required String title,
    required IconData icon,
    required String selectedValue,
    required List<String> options,
    required Function(String) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
          children: [
            Icon(
              icon,
              size: 16,
              color: Colors.grey.shade600,
            ),
            const SizedBox(width: 6),
            Text(
              title,
              style: getMediumStyle(
                color: Colors.grey.shade700,
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
            children: options.map((option) {
              final isSelected = selectedValue == option;
              return Container(
                margin: const EdgeInsets.only(right: 8),
                child: _buildFilterChip(
                  label: option,
                  isSelected: isSelected,
                  onTap: () => onChanged(option),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? ColorManager.primaryColor
              : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? ColorManager.primaryColor
                : Colors.grey.shade300,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey.shade700,
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  List<String> _getGenderOptions() {
    Set<String> genders = {'الكل'};
    for (var story in allStories) {
      if (story.gender != null && story.gender!.isNotEmpty) {
        genders.add(story.gender!);
      }
    }
    return genders.toList();
  }

  List<String> _getAgeGroupOptions() {
    Set<String> ageGroups = {'الكل'};
    for (var story in allStories) {
      if (story.ageGroup != null && story.ageGroup!.isNotEmpty) {
        ageGroups.add(story.ageGroup!);
      }
    }
    return ageGroups.toList();
  }
}