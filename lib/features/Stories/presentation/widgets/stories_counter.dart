import 'package:flutter/material.dart';
import 'package:wise_child/core/resources/color_manager.dart';

class StoriesCounter extends StatelessWidget {
  final int count;
  final bool hasFilters;
  final VoidCallback onClearFilters;

  const StoriesCounter({
    super.key,
    required this.count,
    required this.hasFilters,
    required this.onClearFilters,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          _buildCounterBadge(),
          const Spacer(),
          if (hasFilters) _buildClearFiltersButton(),
        ],
      ),
    );
  }

  Widget _buildCounterBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: ColorManager.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: ColorManager.primaryColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.auto_stories_rounded,
            size: 16,
            color: ColorManager.primaryColor,
          ),
          const SizedBox(width: 6),
          Text(
            '$count ${count == 1 ? 'قصة' : 'قصص'}',
            style: TextStyle(
              color: ColorManager.primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClearFiltersButton() {
    return TextButton.icon(
      onPressed: onClearFilters,
      icon: Icon(
        Icons.clear_all_rounded,
        size: 16,
        color: Colors.grey[600],
      ),
      label: Text(
        'مسح الفلاتر',
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 12,
        ),
      ),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}