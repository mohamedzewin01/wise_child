import 'package:flutter/material.dart';
import 'package:wise_child/core/api/api_constants.dart';
import 'package:wise_child/core/resources/style_manager.dart';
import 'package:wise_child/core/widgets/custom_app_bar_app.dart';

import 'package:wise_child/features/Home/data/models/response/get_home_request.dart';
import 'package:wise_child/features/Home/presentation/widgets/home_stories_grid.dart';



class AllStoriesPage extends StatefulWidget {
  final String title;
  final List<dynamic> stories;
  final StoriesType type;

  const AllStoriesPage({
    super.key,
    required this.title,
    required this.stories,
    required this.type,
  });

  @override
  State<AllStoriesPage> createState() => _AllStoriesPageState();
}

class _AllStoriesPageState extends State<AllStoriesPage> {
  String selectedCategory = 'الكل';
  String selectedAgeGroup = 'الكل';
  String selectedGender = 'الكل';
  String searchQuery = '';
  List<dynamic> filteredStories = [];

  @override
  void initState() {
    super.initState();
    filteredStories = widget.stories;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   elevation: 0,
      //   leading: IconButton(
      //     icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
      //     onPressed: () => Navigator.pop(context),
      //   ),
      //   title: Text(
      //     widget.title,
      //     style: textTheme.titleLarge?.copyWith(
      //       fontWeight: FontWeight.bold,
      //       color: Colors.black87,
      //     ),
      //   ),
      //   centerTitle: true,
      //   actions: [
      //     IconButton(
      //       icon: const Icon(Icons.search, color: Colors.black87),
      //       onPressed: () => _showSearchDialog(context),
      //     ),
      //   ],
      // ),
      body: Column(
        children: [
          // Filter Section
          CustomAppBarApp(subtitle: "يمكن البحث عن القصص المناسبة",title: widget.title,backFunction: () {
            _showSearchDialog(context);
          },),
          _buildFilterSection(colorScheme, textTheme),

          // Stories Count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                Text(
                  'عدد القصص: ${filteredStories.length}',
                  style: textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                if (searchQuery.isNotEmpty ||
                    selectedCategory != 'الكل' ||
                    selectedAgeGroup != 'الكل' ||
                    selectedGender != 'الكل')
                  TextButton(
                    onPressed: _clearAllFilters,
                    child: Text(
                      'إزالة الفلاتر',
                      style: TextStyle(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Stories Grid
          Expanded(
            child: filteredStories.isEmpty
                ? _buildEmptyState(colorScheme, textTheme)
                : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: filteredStories.length,
                itemBuilder: (context, index) {
                  final story = filteredStories[index];
                  return _buildStoryCard(
                    story: story,
                    colorScheme: colorScheme,
                    textTheme: textTheme,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection(ColorScheme colorScheme, TextTheme textTheme) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip(
                  label: 'الفئة',
                  value: selectedCategory,
                  onTap: () => _showCategoryFilter(colorScheme),
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  label: 'الفئة العمرية',
                  value: selectedAgeGroup,
                  onTap: () => _showAgeGroupFilter(colorScheme),
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  label: 'الجنس',
                  value: selectedGender,
                  onTap: () => _showGenderFilter(colorScheme),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final isSelected = value != 'الكل';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.primary : Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? colorScheme.primary : Colors.grey[300]!,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$label: $value',
              style: getMediumStyle(
                color: isSelected ? Colors.white : Colors.grey[700],
                fontSize: 10,
              )


            ),
            const SizedBox(width: 4),
            Icon(
              Icons.keyboard_arrow_down,
              size: 16,
              color: isSelected ? Colors.white : Colors.grey[700],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoryCard({
    required dynamic story,
    required ColorScheme colorScheme,
    required TextTheme textTheme,
  }) {
    final String title = story is TopViewedStories
        ? story.storyTitle ?? 'بدون عنوان'
        : story is TopInactiveStories
        ? story.storyTitle ?? 'بدون عنوان'
        : 'بدون عنوان';

    final String imageUrl = story is TopViewedStories
        ? story.imageCover ?? ''
        : story is TopInactiveStories
        ? story.imageCover ?? ''
        : '';

    final int viewsCount = story is TopViewedStories
        ? story.viewsCount ?? 0
        : story is TopInactiveStories
        ? story.viewsCount ?? 0
        : 0;

    final String categoryName = story is TopViewedStories
        ? story.categoryName ?? 'عام'
        : story is TopInactiveStories
        ? story.categoryName ?? 'عام'
        : 'عام';

    final String ageGroup = story is TopViewedStories
        ? story.ageGroup ?? ''
        : story is TopInactiveStories
        ? story.ageGroup ?? ''
        : '';

    final String gender = story is TopViewedStories
        ? story.gender ?? ''
        : story is TopInactiveStories
        ? story.gender ?? ''
        : '';

    return GestureDetector(
      onTap: () {
        // Navigate to story details
      },
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
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Story Image
            Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                color: colorScheme.primary.withOpacity(0.1),
              ),
              child: imageUrl.isNotEmpty
                  ? ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                child: Image.network(
                  "${ApiConstants.urlImage}$imageUrl",
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return _buildPlaceholderImage(colorScheme);
                  },
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return _buildPlaceholderImage(colorScheme);
                  },
                ),
              )
                  : _buildPlaceholderImage(colorScheme),
            ),

            // Story Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Story Title
                    Text(
                      title,
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),

                    // Category
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        categoryName,
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const Spacer(),

                    // Story Info
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.visibility,
                              size: 14,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '$viewsCount',
                              style: textTheme.bodySmall?.copyWith(
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        if (ageGroup.isNotEmpty)
                          Text(
                            ageGroup,
                            style: textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                      ],
                    ),

                    if (gender.isNotEmpty)
                      const SizedBox(height: 2),
                    if (gender.isNotEmpty)
                      Text(
                        gender,
                        style: textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
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

  Widget _buildPlaceholderImage(ColorScheme colorScheme) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.primary.withOpacity(0.1),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Center(
        child: Icon(
          Icons.menu_book,
          size: 40,
          color: colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildEmptyState(ColorScheme colorScheme, TextTheme textTheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'لا توجد قصص تطابق البحث',
            style: textTheme.titleMedium?.copyWith(
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'حاول تغيير الفلاتر أو البحث بكلمات مختلفة',
            style: textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        String tempQuery = searchQuery;
        return AlertDialog(
          title: const Text('البحث في القصص'),
          content: TextField(
            onChanged: (value) => tempQuery = value,
            decoration: const InputDecoration(
              hintText: 'ابحث في عناوين القصص...',
              border: OutlineInputBorder(),
            ),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  searchQuery = tempQuery;
                });
                _applyFilters();
                Navigator.pop(context);
              },
              child: const Text('بحث'),
            ),
          ],
        );
      },
    );
  }

  void _showCategoryFilter(ColorScheme colorScheme) {
    final categories = _getUniqueCategories();
    _showFilterBottomSheet(
      title: 'اختر الفئة',
      options: categories,
      selectedValue: selectedCategory,
      onSelected: (value) {
        setState(() {
          selectedCategory = value;
        });
        _applyFilters();
      },
    );
  }

  void _showAgeGroupFilter(ColorScheme colorScheme) {
    final ageGroups = _getUniqueAgeGroups();
    _showFilterBottomSheet(
      title: 'اختر الفئة العمرية',
      options: ageGroups,
      selectedValue: selectedAgeGroup,
      onSelected: (value) {
        setState(() {
          selectedAgeGroup = value;
        });
        _applyFilters();
      },
    );
  }

  void _showGenderFilter(ColorScheme colorScheme) {
    final genders = _getUniqueGenders();
    _showFilterBottomSheet(
      title: 'اختر الجنس',
      options: genders,
      selectedValue: selectedGender,
      onSelected: (value) {
        setState(() {
          selectedGender = value;
        });
        _applyFilters();
      },
    );
  }

  void _showFilterBottomSheet({
    required String title,
    required List<String> options,
    required String selectedValue,
    required Function(String) onSelected,
  }) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ...options.map((option) {
                return ListTile(
                  title: Text(option),
                  trailing: selectedValue == option
                      ? const Icon(Icons.check, color: Colors.green)
                      : null,
                  onTap: () {
                    onSelected(option);
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }

  List<String> _getUniqueCategories() {
    final categories = <String>{'الكل'};
    for (final story in widget.stories) {
      final categoryName = story is TopViewedStories
          ? story.categoryName ?? 'عام'
          : story is TopInactiveStories
          ? story.categoryName ?? 'عام'
          : 'عام';
      categories.add(categoryName);
    }
    return categories.toList();
  }

  List<String> _getUniqueAgeGroups() {
    final ageGroups = <String>{'الكل'};
    for (final story in widget.stories) {
      final ageGroup = story is TopViewedStories
          ? story.ageGroup ?? ''
          : story is TopInactiveStories
          ? story.ageGroup ?? ''
          : '';
      if (ageGroup.isNotEmpty) {
        ageGroups.add(ageGroup);
      }
    }
    return ageGroups.toList();
  }

  List<String> _getUniqueGenders() {
    final genders = <String>{'الكل'};
    for (final story in widget.stories) {
      final gender = story is TopViewedStories
          ? story.gender ?? ''
          : story is TopInactiveStories
          ? story.gender ?? ''
          : '';
      if (gender.isNotEmpty) {
        genders.add(gender);
      }
    }
    return genders.toList();
  }

  void _applyFilters() {
    setState(() {
      filteredStories = widget.stories.where((story) {
        // Search filter
        if (searchQuery.isNotEmpty) {
          final title = story is TopViewedStories
              ? story.storyTitle ?? ''
              : story is TopInactiveStories
              ? story.storyTitle ?? ''
              : '';
          if (!title.toLowerCase().contains(searchQuery.toLowerCase())) {
            return false;
          }
        }

        // Category filter
        if (selectedCategory != 'الكل') {
          final categoryName = story is TopViewedStories
              ? story.categoryName ?? 'عام'
              : story is TopInactiveStories
              ? story.categoryName ?? 'عام'
              : 'عام';
          if (categoryName != selectedCategory) {
            return false;
          }
        }

        // Age group filter
        if (selectedAgeGroup != 'الكل') {
          final ageGroup = story is TopViewedStories
              ? story.ageGroup ?? ''
              : story is TopInactiveStories
              ? story.ageGroup ?? ''
              : '';
          if (ageGroup != selectedAgeGroup) {
            return false;
          }
        }

        // Gender filter
        if (selectedGender != 'الكل') {
          final gender = story is TopViewedStories
              ? story.gender ?? ''
              : story is TopInactiveStories
              ? story.gender ?? ''
              : '';
          if (gender != selectedGender) {
            return false;
          }
        }

        return true;
      }).toList();
    });
  }

  void _clearAllFilters() {
    setState(() {
      selectedCategory = 'الكل';
      selectedAgeGroup = 'الكل';
      selectedGender = 'الكل';
      searchQuery = '';
      filteredStories = widget.stories;
    });
  }
}