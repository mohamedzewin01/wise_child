import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'package:wise_child/core/resources/style_manager.dart';
import 'package:wise_child/localization/locale_cubit.dart';

class StoriesFilter extends StatefulWidget {
  final String selectedFilter;
  final Function(String) onFilterChanged;
  final bool isRTL;

  const StoriesFilter({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
    required this.isRTL,
  });

  @override
  State<StoriesFilter> createState() => _StoriesFilterState();
}

class _StoriesFilterState extends State<StoriesFilter>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> _getFilterOptions(String languageCode) {
    return [
      {
        'value': 'all',
        'title': languageCode == 'ar' ? 'الكل' : 'All',
        'icon': Icons.grid_view_rounded,
        'color': ColorManager.primaryColor,
      },
      {
        'value': 'recent',
        'title': languageCode == 'ar' ? 'الأحدث' : 'Recent',
        'icon': Icons.schedule_outlined,
        'color': Colors.green.shade600,
      },
      {
        'value': 'popular',
        'title': languageCode == 'ar' ? 'الأكثر مشاهدة' : 'Popular',
        'icon': Icons.trending_up_outlined,
        'color': Colors.orange.shade600,
      },
      {
        'value': 'active',
        'title': languageCode == 'ar' ? 'النشطة' : 'Active',
        'icon': Icons.check_circle_outline,
        'color': Colors.blue.shade600,
      },
    ];
  }

  void _onFilterTap(String filter) {
    HapticFeedback.selectionClick();
    widget.onFilterChanged(filter);

    _animationController.forward().then((_) {
      _animationController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    final languageCode = LocaleCubit.get(context).state.languageCode;
    final filterOptions = _getFilterOptions(languageCode);

    return Column(
      crossAxisAlignment: widget.isRTL ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            textDirection: widget.isRTL ? TextDirection.rtl : TextDirection.ltr,
            children: [
              Icon(
                Icons.filter_list_rounded,
                color: ColorManager.primaryColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                languageCode == 'ar' ? 'تصفية القصص' : 'Filter Stories',
                style: getBoldStyle(
                  color: ColorManager.primaryColor,
                  fontSize: 16,
                ),
                textDirection: widget.isRTL ? TextDirection.rtl : TextDirection.ltr,
              ),
            ],
          ),
        ),

        // Filter Options
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            textDirection: widget.isRTL ? TextDirection.rtl : TextDirection.ltr,
            children: filterOptions.map((option) {
              final isSelected = widget.selectedFilter == option['value'];
              return Padding(
                padding: EdgeInsets.only(
                  left: widget.isRTL ? 0 : 12,
                  right: widget.isRTL ? 12 : 0,
                ),
                child: _buildFilterChip(
                  value: option['value'],
                  title: option['title'],
                  icon: option['icon'],
                  color: option['color'],
                  isSelected: isSelected,
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip({
    required String value,
    required String title,
    required IconData icon,
    required Color color,
    required bool isSelected,
  }) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: isSelected && _animationController.isAnimating
              ? _scaleAnimation.value
              : 1.0,
          child: GestureDetector(
            onTap: () => _onFilterTap(value),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? color : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? color : color.withOpacity(0.3),
                  width: isSelected ? 2 : 1,
                ),
                boxShadow: [
                  if (isSelected)
                    BoxShadow(
                      color: color.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                textDirection: widget.isRTL ? TextDirection.rtl : TextDirection.ltr,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.white.withOpacity(0.2)
                          : color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      icon,
                      color: isSelected ? Colors.white : color,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 8),
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 300),
                    style: TextStyle(
                      color: isSelected ? Colors.white : color,
                      fontSize: 13,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                    ),
                    child: Text(title),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}