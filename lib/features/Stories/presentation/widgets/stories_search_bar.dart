import 'package:flutter/material.dart';
import 'package:wise_child/core/resources/color_manager.dart';

class StoriesSearchBar extends StatelessWidget {
  final String searchQuery;
  final String selectedCategory;
  final Set<String> categories;
  final Function(String) onSearchChanged;
  final Function(String) onCategoryChanged;

  const StoriesSearchBar({
    super.key,
    required this.searchQuery,
    required this.selectedCategory,
    required this.categories,
    required this.onSearchChanged,
    required this.onCategoryChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        children: [
          // شريط البحث
          _buildSearchField(),

          const SizedBox(height: 12),

          // فلترة الفئات
          if (categories.isNotEmpty) _buildCategoryFilters(),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        onChanged: onSearchChanged,
        decoration: InputDecoration(
          hintText: 'البحث في القصص...',
          hintStyle: TextStyle(color: Colors.grey[500]),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: ColorManager.primaryColor,
          ),
          suffixIcon: searchQuery.isNotEmpty
              ? IconButton(
            icon: Icon(Icons.clear_rounded, color: Colors.grey[500]),
            onPressed: () => onSearchChanged(''),
          )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryFilters() {
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildCategoryChip('الكل', ''),
          const SizedBox(width: 8),
          ...categories.map((category) => Padding(
            padding: const EdgeInsets.only(left: 8),
            child: _buildCategoryChip(category, category),
          )),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label, String value) {
    final isSelected = selectedCategory == value;
    return FilterChip(
      label: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : ColorManager.primaryColor,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
      selected: isSelected,
      onSelected: (selected) => onCategoryChanged(selected ? value : ''),
      backgroundColor: Colors.white,
      selectedColor: ColorManager.primaryColor,
      checkmarkColor: Colors.white,
      side: BorderSide(
        color: isSelected ? ColorManager.primaryColor : Colors.grey.shade300,
        width: 1,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    );
  }
}