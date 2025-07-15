import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'package:wise_child/core/resources/style_manager.dart';
import 'package:wise_child/features/StoriesUnderCategory/domain/entities/stories_under_category_entitiy.dart';
import 'package:wise_child/features/StoriesUnderCategory/data/models/response/stories_under_category_dto.dart';
import 'package:wise_child/features/StoriesUnderCategory/presentation/widgets/category_header_section.dart';
import 'package:wise_child/features/StoriesUnderCategory/presentation/widgets/stories_grid_section.dart';
import 'package:wise_child/features/StoriesUnderCategory/presentation/widgets/stories_filter_section.dart';

class StoriesUnderCategoryContent extends StatefulWidget {
  final StoriesUnderCategoryEntity storiesUnderCategory;
  final bool isRTL;
  final String? categoryName;

  const StoriesUnderCategoryContent({
    super.key,
    required this.storiesUnderCategory,
    required this.isRTL,
    this.categoryName,
  });

  @override
  State<StoriesUnderCategoryContent> createState() => _StoriesUnderCategoryContentState();
}

class _StoriesUnderCategoryContentState extends State<StoriesUnderCategoryContent>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  List<Stories> _filteredStories = [];
  String _selectedGender = 'الكل';
  String _selectedAgeGroup = 'الكل';
  String _sortBy = 'الأحدث';

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeStories();
    _startAnimations();
  }

  void _setupAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));
  }

  void _initializeStories() {
    _filteredStories = widget.storiesUnderCategory.category?.stories ?? [];
    _applyFilters();
  }

  void _startAnimations() {
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        _fadeController.forward();
        _slideController.forward();
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        _buildSliverAppBar(context),
        SliverToBoxAdapter(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  // Category Header
                  CategoryHeaderSection(
                    category: widget.storiesUnderCategory.category!,
                    isRTL: widget.isRTL,
                    totalStories: _filteredStories.length,
                  ),

                  const SizedBox(height: 20),

                  // Filter Section
                  StoriesFilterSection(
                    selectedGender: _selectedGender,
                    selectedAgeGroup: _selectedAgeGroup,
                    sortBy: _sortBy,
                    onGenderChanged: _onGenderChanged,
                    onAgeGroupChanged: _onAgeGroupChanged,
                    onSortChanged: _onSortChanged,
                    isRTL: widget.isRTL,
                    allStories: widget.storiesUnderCategory.category?.stories ?? [],
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),

        // Stories Grid
        StoriesGridSection(
          stories: _filteredStories,
          isRTL: widget.isRTL,
          fadeAnimation: _fadeAnimation,
        ),

        // Bottom padding
        const SliverToBoxAdapter(
          child: SizedBox(height: 40),
        ),
      ],
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 120,
      pinned: true,
      backgroundColor: ColorManager.primaryColor,
      leading: _AppBarButton(
        icon: Icons.arrow_back_ios,
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: [
        _AppBarButton(
          icon: Icons.search,
          onPressed: () {
            HapticFeedback.lightImpact();
            _showSearchDialog(context);
          },
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          widget.categoryName ?? widget.storiesUnderCategory.category?.categoryName ?? 'القصص',
          style: getBoldStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
        titlePadding: EdgeInsetsDirectional.only(
          start: 60,
          bottom: 16,
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                ColorManager.primaryColor,
                ColorManager.primaryColor.withOpacity(0.8),
              ],
            ),
          ),
          child: Center(
            child: Icon(
              Icons.auto_stories,
              size: 60,
              color: Colors.white.withOpacity(0.3),
            ),
          ),
        ),
      ),
    );
  }

  void _onGenderChanged(String gender) {
    setState(() {
      _selectedGender = gender;
      _applyFilters();
    });
    HapticFeedback.selectionClick();
  }

  void _onAgeGroupChanged(String ageGroup) {
    setState(() {
      _selectedAgeGroup = ageGroup;
      _applyFilters();
    });
    HapticFeedback.selectionClick();
  }

  void _onSortChanged(String sortBy) {
    setState(() {
      _sortBy = sortBy;
      _applyFilters();
    });
    HapticFeedback.selectionClick();
  }

  void _applyFilters() {
    List<Stories> stories = widget.storiesUnderCategory.category?.stories ?? [];

    // Apply gender filter
    if (_selectedGender != 'الكل') {
      stories = stories.where((story) => story.gender == _selectedGender).toList();
    }

    // Apply age group filter
    if (_selectedAgeGroup != 'الكل') {
      stories = stories.where((story) => story.ageGroup == _selectedAgeGroup).toList();
    }

    // Apply sorting
    switch (_sortBy) {
      case 'الأحدث':
        stories.sort((a, b) {
          if (a.createdAt == null || b.createdAt == null) return 0;
          return DateTime.parse(b.createdAt!).compareTo(DateTime.parse(a.createdAt!));
        });
        break;
      case 'الأقدم':
        stories.sort((a, b) {
          if (a.createdAt == null || b.createdAt == null) return 0;
          return DateTime.parse(a.createdAt!).compareTo(DateTime.parse(b.createdAt!));
        });
        break;
      case 'الأكثر مشاهدة':
        stories.sort((a, b) => (b.viewsCount ?? 0).compareTo(a.viewsCount ?? 0));
        break;
      case 'الأقل مشاهدة':
        stories.sort((a, b) => (a.viewsCount ?? 0).compareTo(b.viewsCount ?? 0));
        break;
      case 'الأبجدية':
        stories.sort((a, b) => (a.storyTitle ?? '').compareTo(b.storyTitle ?? ''));
        break;
    }

    _filteredStories = stories;
  }

  void _showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(
                Icons.search,
                color: ColorManager.primaryColor,
                size: 28,
              ),
              const SizedBox(width: 12),
              const Text('البحث في القصص'),
            ],
          ),
          content: TextField(
            onChanged: (value) {
              // Implement search functionality
            },
            decoration: InputDecoration(
              hintText: 'ابحث عن قصة...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              prefixIcon: const Icon(Icons.search),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'إلغاء',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorManager.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('بحث'),
            ),
          ],
        );
      },
    );
  }
}

// AppBar Button Component
class _AppBarButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _AppBarButton({
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          icon,
          color: ColorManager.primaryColor,
          size: 20,
        ),
      ),
    );
  }
}