import 'package:flutter/material.dart';
import 'package:wise_child/core/resources/color_manager.dart';

enum StoryLayoutType {
  grid,
  list,
  carousel
}

class StoryLayoutSwitcher extends StatefulWidget {
  final StoryLayoutType currentLayout;
  final Function(StoryLayoutType) onLayoutChanged;

  const StoryLayoutSwitcher({
    super.key,
    required this.currentLayout,
    required this.onLayoutChanged,
  });

  @override
  State<StoryLayoutSwitcher> createState() => _StoryLayoutSwitcherState();
}

class _StoryLayoutSwitcherState extends State<StoryLayoutSwitcher>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          BoxShadow(
            color: ColorManager.primaryColor.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
            spreadRadius: 2,
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
    final isSelected = widget.currentLayout == layoutType;

    return GestureDetector(
      onTap: () {
        if (!isSelected) {
          _controller.forward().then((_) {
            _controller.reverse();
          });
          widget.onLayoutChanged(layoutType);
        }
      },
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: isSelected ? _scaleAnimation.value : 1.0,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOutCubic,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? LinearGradient(
                  colors: [
                    ColorManager.primaryColor,
                    ColorManager.primaryColor.withOpacity(0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
                    : null,
                borderRadius: BorderRadius.circular(12),
                boxShadow: isSelected
                    ? [
                  BoxShadow(
                    color: ColorManager.primaryColor.withOpacity(0.3),
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
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.white.withOpacity(0.2)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      icon,
                      color: isSelected
                          ? Colors.white
                          : ColorManager.primaryColor.withOpacity(0.7),
                      size: 20,
                    ),
                  ),
                  // const SizedBox(height: 4),
                  // Text(
                  //   label,
                  //   style: TextStyle(
                  //     fontSize: 10,
                  //     fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                  //     color: isSelected
                  //         ? Colors.white
                  //         : ColorManager.primaryColor.withOpacity(0.8),
                  //   ),
                  // ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}