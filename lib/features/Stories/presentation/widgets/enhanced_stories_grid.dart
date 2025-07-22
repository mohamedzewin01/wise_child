import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wise_child/features/Stories/data/models/response/children_stories_model_dto.dart';
import 'package:wise_child/features/Stories/presentation/bloc/ChildrenStoriesCubit/children_stories_cubit.dart';
import 'package:wise_child/features/Stories/presentation/widgets/stories_counter.dart';
import 'package:wise_child/features/Stories/presentation/widgets/stories_empty_state.dart';
import 'package:wise_child/features/Stories/presentation/widgets/stories_error_state.dart';
import 'package:wise_child/features/Stories/presentation/widgets/stories_grid_view.dart';
import 'package:wise_child/features/Stories/presentation/widgets/stories_loading_grid.dart';
import 'package:wise_child/features/Stories/presentation/widgets/stories_no_results.dart';
import 'package:wise_child/features/Stories/presentation/widgets/stories_search_bar.dart';

// تحتاج لإضافة هذه الملفات للمشروع
// import 'story_layout_switcher.dart';
// import 'story_list_view.dart';
// import 'story_carousel_view.dart';

enum StoryLayoutType {
  grid,
  list,
  carousel
}

class EnhancedStoriesGrid extends StatefulWidget {
  const EnhancedStoriesGrid({super.key});

  @override
  State<EnhancedStoriesGrid> createState() => _EnhancedStoriesGridState();
}

class _EnhancedStoriesGridState extends State<EnhancedStoriesGrid>
    with TickerProviderStateMixin {
  late AnimationController _listController;
  late AnimationController _emptyController;
  late AnimationController _refreshController;
  late AnimationController _layoutSwitchController;

  String _searchQuery = '';
  String _selectedCategory = '';
  StoryLayoutType _currentLayout = StoryLayoutType.grid;

  @override
  void initState() {
    super.initState();
    _listController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _emptyController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _refreshController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _layoutSwitchController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _listController.dispose();
    _emptyController.dispose();
    _refreshController.dispose();
    _layoutSwitchController.dispose();
    super.dispose();
  }

  List<StoriesModeData> _filterStories(List<StoriesModeData> stories) {
    return stories.where((story) {
      final matchesSearch = _searchQuery.isEmpty ||
          (story.storyTitle?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false) ||
          (story.storyDescription?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false);

      final matchesCategory = _selectedCategory.isEmpty ||
          story.categoryName == _selectedCategory;

      return matchesSearch && matchesCategory;
    }).toList();
  }

  Set<String> _getAvailableCategories(List<StoriesModeData> stories) {
    return stories
        .where((story) => story.categoryName != null && story.categoryName!.isNotEmpty)
        .map((story) => story.categoryName!)
        .toSet();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _onCategoryChanged(String category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  void _clearFilters() {
    setState(() {
      _searchQuery = '';
      _selectedCategory = '';
    });
  }

  void _onLayoutChanged(StoryLayoutType newLayout) {
    if (_currentLayout != newLayout) {
      _layoutSwitchController.forward().then((_) {
        setState(() {
          _currentLayout = newLayout;
        });
        _layoutSwitchController.reverse();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChildrenStoriesCubit, ChildrenStoriesState>(
      builder: (context, state) {
        if (state is ChildrenStoriesLoading) {
          return const StoriesLoadingGrid();
        }

        if (state is ChildrenStoriesSuccess) {
          final allStories = state.getChildrenEntity?.data ?? [];
          final filteredStories = _filterStories(allStories);
          final categories = _getAvailableCategories(allStories);

          if (allStories.isEmpty) {
            _emptyController.forward();
            return StoriesEmptyState(
              controller: _emptyController,
              refreshController: _refreshController,
            );
          }

          _listController.forward();
          return _buildStoriesContent(filteredStories, categories);
        }

        if (state is ChildrenStoriesFailure) {
          _emptyController.forward();
          return StoriesErrorState(controller: _emptyController);
        }

        return const StoriesLoadingGrid();
      },
    );
  }

  Widget _buildStoriesContent(List<StoriesModeData> stories, Set<String> categories) {
    return AnimatedBuilder(
      animation: _layoutSwitchController,
      builder: (context, child) {
        return Transform.scale(
          scale: 1.0 - (_layoutSwitchController.value * 0.05),
          child: Opacity(
            opacity: 1.0 - (_layoutSwitchController.value * 0.3),
            child: Column(
              children: [
                // مبدل التخطيط
                _buildLayoutSwitcher(),

                // شريط البحث والفلترة (اختياري حسب التخطيط)
                if (_currentLayout != StoryLayoutType.carousel) ...[
                  StoriesSearchBar(
                    searchQuery: _searchQuery,
                    selectedCategory: _selectedCategory,
                    categories: categories,
                    onSearchChanged: _onSearchChanged,
                    onCategoryChanged: _onCategoryChanged,
                  ),

                  // عداد القصص
                  StoriesCounter(
                    count: stories.length,
                    hasFilters: _searchQuery.isNotEmpty || _selectedCategory.isNotEmpty,
                    onClearFilters: _clearFilters,
                  ),
                ],

                // محتوى القصص حسب التخطيط المحدد
                Expanded(
                  child: stories.isEmpty
                      ? const StoriesNoResults()
                      : _buildLayoutView(stories),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLayoutSwitcher() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildLayoutOption(
              StoryLayoutType.grid,
              Icons.grid_view_rounded,
              'الشبكة',
            ),
          ),
          Expanded(
            child: _buildLayoutOption(
              StoryLayoutType.list,
              Icons.view_list_rounded,
              'القائمة',
            ),
          ),
          Expanded(
            child: _buildLayoutOption(
              StoryLayoutType.carousel,
              Icons.view_carousel_rounded,
              'الشريط',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLayoutOption(
      StoryLayoutType layoutType,
      IconData icon,
      String label,
      ) {
    final isSelected = _currentLayout == layoutType;

    return GestureDetector(
      onTap: () => _onLayoutChanged(layoutType),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOutCubic,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
            colors: [
              Colors.blue.shade400,
              Colors.blue.shade600,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
              : null,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: Colors.blue.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
              spreadRadius: 1,
            ),
          ]
              : [],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? Colors.white
                  : Colors.blue.shade400,
              size: 20,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                color: isSelected
                    ? Colors.white
                    : Colors.blue.shade400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLayoutView(List<StoriesModeData> stories) {
    switch (_currentLayout) {
      case StoryLayoutType.grid:
        return StoriesGridView(
          stories: stories,
          controller: _listController,
        );

      case StoryLayoutType.list:
        return _buildListView(stories);

      case StoryLayoutType.carousel:
        return _buildCarouselView(stories);
    }
  }

  // تنفيذ مبسط لعرض القائمة
  Widget _buildListView(List<StoriesModeData> stories) {
    return AnimatedBuilder(
      animation: _listController,
      builder: (context, child) {
        return Opacity(
          opacity: _listController.value,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            itemCount: stories.length,
            itemBuilder: (context, index) {
              final story = stories[index];

              return TweenAnimationBuilder<double>(
                duration: Duration(milliseconds: 600 + (index * 100)),
                tween: Tween(begin: 0.0, end: 1.0),
                curve: Curves.easeOutCubic,
                builder: (context, value, child) {
                  return Transform.translate(
                    offset: Offset(50 * (1 - value), 0),
                    child: Opacity(
                      opacity: value,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        height: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              // صورة القصة
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.blue.shade200,
                                      Colors.purple.shade200,
                                    ],
                                  ),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.auto_stories_rounded,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                              ),

                              const SizedBox(width: 12),

                              // معلومات القصة
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      story.storyTitle ?? 'قصة بدون عنوان',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),

                                    const SizedBox(height: 4),

                                    if (story.storyDescription != null)
                                      Text(
                                        story.storyDescription!,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                  ],
                                ),
                              ),

                              // زر التشغيل
                              IconButton(
                                onPressed: () {
                                  // تشغيل القصة
                                },
                                icon: Icon(
                                  Icons.play_circle_fill_rounded,
                                  color: Colors.blue.shade400,
                                  size: 32,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  // تنفيذ مبسط لعرض الشريط
  Widget _buildCarouselView(List<StoriesModeData> stories) {
    return AnimatedBuilder(
      animation: _listController,
      builder: (context, child) {
        return Opacity(
          opacity: _listController.value,
          child: PageView.builder(
            controller: PageController(viewportFraction: 0.85),
            itemCount: stories.length,
            itemBuilder: (context, index) {
              final story = stories[index];

              return TweenAnimationBuilder<double>(
                duration: Duration(milliseconds: 800 + (index * 100)),
                tween: Tween(begin: 0.0, end: 1.0),
                curve: Curves.easeOutCubic,
                builder: (context, value, child) {
                  return Transform.translate(
                    offset: Offset(0, 30 * (1 - value)),
                    child: Opacity(
                      opacity: value,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          gradient: LinearGradient(
                            colors: [
                              Colors.blue.shade300,
                              Colors.purple.shade300,
                              Colors.pink.shade200,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            // تدرج علوي
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24),
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withOpacity(0.7),
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                            ),

                            // المحتوى
                            Positioned(
                              bottom: 20,
                              left: 20,
                              right: 20,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    story.storyTitle ?? 'قصة بدون عنوان',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      shadows: [
                                        Shadow(
                                          blurRadius: 10.0,
                                          color: Colors.black,
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),

                                  const SizedBox(height: 8),

                                  if (story.storyDescription != null)
                                    Text(
                                      story.storyDescription!,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white.withOpacity(0.9),
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),

                                  const SizedBox(height: 16),

                                  // زر التشغيل
                                  Container(
                                    width: double.infinity,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.white.withOpacity(0.9),
                                          Colors.white.withOpacity(0.7),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(20),
                                        onTap: () {
                                          // تشغيل القصة
                                        },
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.play_arrow_rounded,
                                              color: Colors.blue.shade600,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              'تشغيل القصة',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blue.shade600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // زر المفضلة
                            Positioned(
                              top: 16,
                              right: 16,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.9),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.favorite_border_rounded,
                                  color: Colors.red.shade400,
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}