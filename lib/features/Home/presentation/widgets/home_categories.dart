import 'package:flutter/material.dart';
import 'package:wise_child/core/resources/style_manager.dart';
import 'package:wise_child/core/utils/icon_category.dart';
import 'package:wise_child/features/Home/data/models/response/get_home_request.dart';
import 'package:wise_child/features/StoriesUnderCategory/presentation/pages/StoriesUnderCategory_page.dart';

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
                'الأقسام',
                style:getSemiBoldStyle(
                  // color: colorScheme.primary,
                  fontSize: 16,
                )

                // textTheme.titleLarge?.copyWith(
                //   fontWeight: FontWeight.bold,
                // ),
              ),
              TextButton(
                onPressed: () => _viewAllCategories(context),
                child: Text(
                  'عرض الكل',
                  style:getSemiBoldStyle(
                    color: colorScheme.primary
                  ),


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
    return SizedBox(
      height: 350,
      child: GridView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          mainAxisExtent: 120,
          // childAspectRatio: 1.2,
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
      ),
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
              flex: 2,
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
                      size: 25,
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
                          fontSize: 16
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
    Navigator.push(context, MaterialPageRoute(builder: (context) => StoriesUnderCategoryPage(categoryId: category.categoryId??0),));
  }
}