import 'package:flutter/material.dart';
import 'package:wise_child/core/utils/icon_category.dart';
import 'package:wise_child/features/Home/data/models/response/get_home_request.dart';

class HomeCategories extends StatelessWidget {
  final List<StoriesByCategory> categories;

  const HomeCategories({
    super.key,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    if (categories.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'الفئات',
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () => _viewAllCategories(context),
                child: Text(
                  'عرض الكل',
                  style: TextStyle(color: colorScheme.primary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildCategoriesGrid(context, textTheme),
        ],
      ),
    );
  }

  Widget _buildCategoriesGrid(BuildContext context, TextTheme textTheme) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        mainAxisExtent: 180,
        childAspectRatio: 1.5,
      ),
      itemCount: categories.length > 6 ? 6 : categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return _buildCategoryCard(
          context: context,
          category: category,
          textTheme: textTheme,
          index: index,
        );
      },
    );
  }

  Widget _buildCategoryCard({
    required BuildContext context,
    required StoriesByCategory category,
    required TextTheme textTheme,
    required int index,
  }) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal,
      Colors.indigo,
      Colors.pink,
    ];
    final color = colors[index % colors.length];

    return GestureDetector(
      onTap: () => _viewCategoryDetails(context, category),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(
            color: color.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            // Header with gradient
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      color.withOpacity(0.8),
                      color,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      getCategoryIcon(category.categoryName ?? ''),
                      color: Colors.white,
                      size: 32,
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${category.count ?? 0}',
                        style: textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Content
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.categoryName ?? 'غير محدد',
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    if (category.categoryDescription?.isNotEmpty == true)
                      Expanded(
                        child: Text(
                          category.categoryDescription!,
                          style: textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                          // textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }



  void _viewAllCategories(BuildContext context) {
    // Navigate to categories page
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('عرض جميع الفئات')),
    );
  }

  void _viewCategoryDetails(BuildContext context, StoriesByCategory category) {
    // Navigate to specific category details
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('عرض تفاصيل الفئة: ${category.categoryName}'),
      ),
    );
  }
}