import 'package:flutter/material.dart';
import 'package:wise_child/features/ChildStories/data/models/response/get_child_stories_dto.dart';
import 'package:wise_child/features/ChildStories/presentation/widgets/story_card.dart' hide SizedBox;
import 'package:wise_child/features/ChildStories/presentation/widgets/stories_statistics.dart';
import 'package:wise_child/features/ChildStories/presentation/widgets/stories_filter.dart';
import 'package:wise_child/features/Children/data/models/response/get_children_dto.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'package:wise_child/core/resources/style_manager.dart';
import 'package:wise_child/localization/locale_cubit.dart';

class StoriesContent extends StatefulWidget {
  final List<Stories> stories;
  final Children child;
  final VoidCallback onRefresh;
  final bool isRTL;

  const StoriesContent({
    super.key,
    required this.stories,
    required this.child,
    required this.onRefresh,
    required this.isRTL,
  });

  @override
  State<StoriesContent> createState() => _StoriesContentState();
}

class _StoriesContentState extends State<StoriesContent>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;

  String _selectedFilter = 'all';
  List<Stories> _filteredStories = [];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideAnimation = Tween<double>(
      begin: 50.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _filteredStories = widget.stories;
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _filterStories(String filter) {
    setState(() {
      _selectedFilter = filter;

      switch (filter) {
        case 'recent':
          _filteredStories = List.from(widget.stories)
            ..sort((a, b) => (b.createdAt ?? '').compareTo(a.createdAt ?? ''));
          break;
        case 'popular':
          _filteredStories = List.from(widget.stories)
            ..sort((a, b) => (b.viewsCount ?? 0).compareTo(a.viewsCount ?? 0));
          break;
        case 'active':
          _filteredStories = widget.stories
              .where((story) => story.isActive == 1)
              .toList();
          break;
        default:
          _filteredStories = widget.stories;
      }
    });

    // Restart animation for filtered content
    _animationController.reset();
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final languageCode = LocaleCubit.get(context).state.languageCode;

    return RefreshIndicator(
      onRefresh: () async {
        widget.onRefresh();
      },
      color: ColorManager.primaryColor,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // Statistics Section
            AnimatedBuilder(
              animation: _slideAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _slideAnimation.value),
                  child: FadeTransition(
                    opacity: _animationController,
                    child: StoriesStatistics(
                      stories: widget.stories,
                      child: widget.child,
                      isRTL: widget.isRTL,
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 24),

            // Filter Section
            AnimatedBuilder(
              animation: _slideAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _slideAnimation.value * 0.8),
                  child: FadeTransition(
                    opacity: _animationController,
                    child: StoriesFilter(
                      selectedFilter: _selectedFilter,
                      onFilterChanged: _filterStories,
                      isRTL: widget.isRTL,
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            // Stories Grid
            AnimatedBuilder(
              animation: _slideAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _slideAnimation.value * 0.6),
                  child: FadeTransition(
                    opacity: _animationController,
                    child: _buildStoriesGrid(),
                  ),
                );
              },
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildStoriesGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      mainAxisExtent: 235
      ),
      itemCount: _filteredStories.length,
      itemBuilder: (context, index) {
        final story = _filteredStories[index];
        return AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            final delay = index * 0.1;
            final animationValue = Curves.easeOutCubic.transform(
              (_animationController.value - delay).clamp(0.0, 1.0),
            );

            return Transform.translate(
              offset: Offset(0, (1 - animationValue) * 30),
              child: Opacity(
                opacity: animationValue,
                child: StoryCard(
                  story: story,
                  child: widget.child,
                  index: index,
                  isRTL: widget.isRTL,
                ),
              ),
            );
          },
        );
      },
    );
  }
}