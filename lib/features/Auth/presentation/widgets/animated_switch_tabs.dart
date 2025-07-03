
import 'package:flutter/material.dart';
import 'package:wise_child/core/resources/style_manager.dart';
import 'package:wise_child/l10n/app_localizations.dart';

class AnimatedSwitchTabs extends StatefulWidget {
  final bool isLoginSelected;
  final Function(bool) onTabChanged;

  const AnimatedSwitchTabs({
    super.key,
    required this.isLoginSelected,
    required this.onTabChanged,
  });

  @override
  State<AnimatedSwitchTabs> createState() => _AnimatedSwitchTabsState();
}

class _AnimatedSwitchTabsState extends State<AnimatedSwitchTabs>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _slideAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    ));

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    if (!widget.isLoginSelected) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(AnimatedSwitchTabs oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isLoginSelected != oldWidget.isLoginSelected) {
      if (widget.isLoginSelected) {
        _controller.reverse();
      } else {
        _controller.forward();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final tabWidth = (screenWidth - 108) / 2; // 108 = padding + margins

    return Container(
      height: 55,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Stack(
        children: [
          // Animated sliding background
          AnimatedBuilder(
            animation: _slideAnimation,
            builder: (context, child) {
              return Positioned(
                left: 4 + (_slideAnimation.value * (tabWidth + 8)),
                top: 4,
                bottom: 4,
                width: tabWidth,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.3),
                        Colors.white.withOpacity(0.1),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.2),
                        blurRadius: 15,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          // Tab buttons
          Row(
            children: [
              Expanded(
                child: _buildTabButton(
                  AppLocalizations.of(context)!.login,
                  widget.isLoginSelected,
                      () => widget.onTabChanged(true),
                ),
              ),
              Expanded(
                child: _buildTabButton(
                  AppLocalizations.of(context)!.register,
                  !widget.isLoginSelected,
                      () => widget.onTabChanged(false),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String text, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: isSelected ? _scaleAnimation.value : 1.0,
            child: Container(
              alignment: Alignment.center,
              child: Text(
                text,
                style: getBoldStyle(
                  color: isSelected
                      ? Colors.white
                      : Colors.white.withOpacity(0.6),
                  fontSize: 16,
                ).copyWith(
                  shadows: isSelected
                      ? [
                    Shadow(
                      offset: const Offset(0, 1),
                      blurRadius: 3,
                      color: Colors.black.withOpacity(0.3),
                    ),
                  ]
                      : null,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
