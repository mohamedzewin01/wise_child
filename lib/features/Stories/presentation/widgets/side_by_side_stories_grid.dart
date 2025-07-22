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


class SideBySideStoriesGrid extends StatefulWidget {
  const SideBySideStoriesGrid({super.key});

  @override
  State<SideBySideStoriesGrid> createState() => _SideBySideStoriesGridState();
}

class _SideBySideStoriesGridState extends State<SideBySideStoriesGrid>
    with TickerProviderStateMixin {
  late AnimationController _listController;
  late AnimationController _emptyController;
  late AnimationController _refreshController;

  String _searchQuery = '';
  String _selectedCategory = '';

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
  }

  @override
  void dispose() {
    _listController.dispose();
    _emptyController.dispose();
    _refreshController.dispose();
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
    return Column(
      children: [
        // // شريط البحث والفلترة
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

        // شبكة القصص
        stories.isEmpty
            ? const StoriesNoResults()
            : StoriesGridView(
          stories: stories,
          controller: _listController,
        ),
      ],
    );
  }
}