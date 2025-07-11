import 'package:flutter/material.dart';

class LoadingShimmer extends StatefulWidget {
  const LoadingShimmer({super.key});

  @override
  State<LoadingShimmer> createState() => _LoadingShimmerState();
}

class _LoadingShimmerState extends State<LoadingShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Column(
          children: [
            // Welcome Header Shimmer
            _buildWelcomeHeaderShimmer(),
            const SizedBox(height: 20),

            // Quick Actions Shimmer
            _buildQuickActionsShimmer(),
            const SizedBox(height: 24),

            // Statistics Overview Shimmer
            _buildStatisticsShimmer(),
            const SizedBox(height: 24),

            // Stories Grid Shimmer
            _buildStoriesGridShimmer(),
            const SizedBox(height: 24),

            // Gender Statistics Shimmer
            _buildGenderStatisticsShimmer(),
            const SizedBox(height: 24),

            // Categories Shimmer
            _buildCategoriesShimmer(),
          ],
        );
      },
    );
  }

  Widget _buildWelcomeHeaderShimmer() {
    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar shimmer
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: _buildShimmerGradient(),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name shimmer
                Container(
                  width: double.infinity,
                  height: 24,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    gradient: _buildShimmerGradient(),
                  ),
                ),
                const SizedBox(height: 8),
                // Subtitle shimmer
                Container(
                  width: 200,
                  height: 16,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    gradient: _buildShimmerGradient(),
                  ),
                ),
                const SizedBox(height: 8),
                // Badge shimmer
                Container(
                  width: 80,
                  height: 20,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: _buildShimmerGradient(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsShimmer() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title shimmer
          Container(
            width: 120,
            height: 20,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              gradient: _buildShimmerGradient(),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: List.generate(3, (index) {
              return Expanded(
                child: Container(
                  margin: EdgeInsets.only(right: index < 2 ? 12 : 0),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Icon shimmer
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: _buildShimmerGradient(),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Title shimmer
                      Container(
                        width: 60,
                        height: 12,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          gradient: _buildShimmerGradient(),
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Subtitle shimmer
                      Container(
                        width: 40,
                        height: 10,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          gradient: _buildShimmerGradient(),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsShimmer() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title shimmer
          Container(
            width: 100,
            height: 20,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              gradient: _buildShimmerGradient(),
            ),
          ),
          const SizedBox(height: 16),
          // Stats grid
          Column(
            children: [
              Row(
                children: [
                  Expanded(child: _buildStatCardShimmer()),
                  const SizedBox(width: 12),
                  Expanded(child: _buildStatCardShimmer()),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _buildStatCardShimmer()),
                  const SizedBox(width: 12),
                  Expanded(child: _buildStatCardShimmer()),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCardShimmer() {
    return Container(
      padding: const EdgeInsets.all(16),
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
          Row(
            children: [
              // Icon shimmer
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: _buildShimmerGradient(),
                ),
              ),
              const Spacer(),
              // Value shimmer
              Container(
                width: 40,
                height: 32,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  gradient: _buildShimmerGradient(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Title shimmer
          Container(
            width: double.infinity,
            height: 16,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              gradient: _buildShimmerGradient(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoriesGridShimmer() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Title shimmer
              Container(
                width: 150,
                height: 20,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  gradient: _buildShimmerGradient(),
                ),
              ),
              // View all shimmer
              Container(
                width: 60,
                height: 16,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  gradient: _buildShimmerGradient(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              itemBuilder: (context, index) {
                return Container(
                  width: 160,
                  margin: EdgeInsets.only(right: index < 2 ? 12 : 0),
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
                      // Image shimmer
                      Container(
                        height: 100,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                          gradient: _buildShimmerGradient(),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title shimmer
                              Container(
                                width: double.infinity,
                                height: 16,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  gradient: _buildShimmerGradient(),
                                ),
                              ),
                              const SizedBox(height: 4),
                              // Category shimmer
                              Container(
                                width: 60,
                                height: 20,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  gradient: _buildShimmerGradient(),
                                ),
                              ),
                              const Spacer(),
                              // Stats shimmer
                              Container(
                                width: 80,
                                height: 12,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  gradient: _buildShimmerGradient(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderStatisticsShimmer() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title shimmer
          Container(
            width: 140,
            height: 20,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              gradient: _buildShimmerGradient(),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
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
              children: List.generate(3, (index) {
                return Padding(
                  padding: EdgeInsets.only(bottom: index < 2 ? 16 : 0),
                  child: Row(
                    children: [
                      // Icon shimmer
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          gradient: _buildShimmerGradient(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Label shimmer
                                Container(
                                  width: 60,
                                  height: 16,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    gradient: _buildShimmerGradient(),
                                  ),
                                ),
                                // Value shimmer
                                Container(
                                  width: 80,
                                  height: 16,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    gradient: _buildShimmerGradient(),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            // Progress bar shimmer
                            Container(
                              width: double.infinity,
                              height: 6,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                gradient: _buildShimmerGradient(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesShimmer() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Title shimmer
              Container(
                width: 80,
                height: 20,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  gradient: _buildShimmerGradient(),
                ),
              ),
              // View all shimmer
              Container(
                width: 60,
                height: 16,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  gradient: _buildShimmerGradient(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              mainAxisExtent: 230,
              childAspectRatio: 1.5,
            ),
            itemCount: 4,
            itemBuilder: (context, index) {
              return Container(
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
                  children: [
                    // Header shimmer
                    Expanded(
                      flex: 2,
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                          gradient: _buildShimmerGradient(),
                        ),
                      ),
                    ),
                    // Content shimmer
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          children: [
                            // Title shimmer
                            Container(
                              width: double.infinity,
                              height: 16,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                gradient: _buildShimmerGradient(),
                              ),
                            ),
                            const SizedBox(height: 4),
                            // Description shimmer
                            Container(
                              width: 100,
                              height: 12,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                gradient: _buildShimmerGradient(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  LinearGradient _buildShimmerGradient() {
    return LinearGradient(
      colors: [
        Colors.grey[300]!,
        Colors.grey[100]!,
        Colors.grey[300]!,
      ],
      stops: [
        _animation.value - 0.3,
        _animation.value,
        _animation.value + 0.3,
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }
}