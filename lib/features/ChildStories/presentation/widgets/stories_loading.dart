import 'package:flutter/material.dart';
import 'package:wise_child/core/resources/color_manager.dart';

class StoriesLoading extends StatefulWidget {
  const StoriesLoading({super.key});

  @override
  State<StoriesLoading> createState() => _StoriesLoadingState();
}

class _StoriesLoadingState extends State<StoriesLoading>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _pulseController;
  late Animation<double> _animation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 0.7,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 60),

          // Main Loading Animation
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation.value,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        ColorManager.primaryColor,
                        ColorManager.primaryColor.withOpacity(0.7),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: ColorManager.primaryColor.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Transform.rotate(
                    angle: _animation.value * 6.28,
                    child: Icon(
                      Icons.auto_stories_outlined,
                      color: Colors.white,
                      size: 36,
                    ),
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 32),

          // Loading Text
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Opacity(
                opacity: _pulseAnimation.value,
                child: Text(
                  'جاري تحميل القصص...',
                  style: TextStyle(
                    color: ColorManager.primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            },
          ),

          const SizedBox(height: 40),

          // Shimmer Cards
          _buildShimmerContent(),
        ],
      ),
    );
  }

  Widget _buildShimmerContent() {
    return Column(
      children: [
        // Statistics Shimmer
        _buildShimmerStatistics(),

        const SizedBox(height: 24),

        // Filter Shimmer




        // Grid Shimmer
        _buildShimmerGrid(),
      ],
    );
  }

  Widget _buildShimmerStatistics() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: ColorManager.primaryColor.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          _buildShimmerItem(height: 20, width: 150),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: _buildShimmerStatCard()),
              const SizedBox(width: 12),
              Expanded(child: _buildShimmerStatCard()),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildShimmerStatCard()),
              const SizedBox(width: 12),
              Expanded(child: _buildShimmerStatCard()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerStatCard() {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
      ),
      child: _buildShimmerItem(height: 80, width: double.infinity),
    );
  }



  Widget _buildShimmerGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      mainAxisExtent: 235
      ),
      itemCount: 4,
      itemBuilder: (context, index) {
        return _buildShimmerCard();
      },
    );
  }

  Widget _buildShimmerCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.grey.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: _buildShimmerItem(
              height: double.infinity,
              width: double.infinity,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildShimmerItem(height: 16, width: double.infinity),
                  const SizedBox(height: 8),
                  _buildShimmerItem(height: 12, width: 120),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerItem({
    required double height,
    required double width,
    BorderRadius? borderRadius,
  }) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            borderRadius: borderRadius ?? BorderRadius.circular(8),
            gradient: LinearGradient(
              begin: Alignment(-1.0 + _animation.value * 2, 0.0),
              end: Alignment(1.0 + _animation.value * 2, 0.0),
              colors: [
                Colors.grey.shade200,
                Colors.grey.shade100,
                Colors.grey.shade200,
              ],
            ),
          ),
        );
      },
    );
  }
}