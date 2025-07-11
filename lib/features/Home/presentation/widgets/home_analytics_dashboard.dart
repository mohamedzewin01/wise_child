import 'package:flutter/material.dart';
import 'package:wise_child/features/Home/data/models/response/get_home_request.dart';

class HomeAnalyticsDashboard extends StatefulWidget {
  final DataHome? data;

  const HomeAnalyticsDashboard({
    super.key,
    required this.data,
  });

  @override
  State<HomeAnalyticsDashboard> createState() => _HomeAnalyticsDashboardState();
}

class _HomeAnalyticsDashboardState extends State<HomeAnalyticsDashboard>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    if (widget.data == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'لوحة التحليلات',
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Container(
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
                // Tab Bar
                Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: BoxDecoration(
                      color: colorScheme.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.grey[600],
                    dividerColor: Colors.transparent,
                    tabs: const [
                      Tab(text: 'النشاط'),
                      Tab(text: 'الفئات'),
                      Tab(text: 'الأعمار'),
                    ],
                  ),
                ),

                // Tab Content
                SizedBox(
                  height: 300,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildActivityTab(),
                      _buildCategoriesTab(),
                      _buildAgeGroupsTab(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityTab() {
    final total = widget.data!.totalStories ?? 0;
    final active = widget.data!.activeStories ?? 0;
    final inactive = widget.data!.inactiveStories ?? 0;
    final zeroViews = widget.data!.storiesWithZeroViews ?? 0;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Activity Chart (Pie-like visualization)
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Expanded(
                  child: _buildActivityChart(total, active, inactive),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildLegendItem(
                        'نشطة',
                        active,
                        Colors.green,
                        total,
                      ),
                      const SizedBox(height: 8),
                      _buildLegendItem(
                        'غير نشطة',
                        inactive,
                        Colors.orange,
                        total,
                      ),
                      const SizedBox(height: 8),
                      _buildLegendItem(
                        'بدون مشاهدات',
                        zeroViews,
                        Colors.red,
                        total,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Activity Stats
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  'إجمالي القصص',
                  '$total',
                  Icons.library_books,
                  Colors.blue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatItem(
                  'معدل النشاط',
                  '${total > 0 ? ((active / total) * 100).toStringAsFixed(1) : 0}%',
                  Icons.trending_up,
                  Colors.green,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesTab() {
    final categories = widget.data!.storiesByCategory ?? [];

    if (categories.isEmpty) {
      return const Center(
        child: Text('لا توجد بيانات فئات'),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final maxCount = categories
                    .map((e) => e.count ?? 0)
                    .reduce((a, b) => a > b ? a : b);

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildCategoryProgress(
                    category.categoryName ?? 'غير محدد',
                    category.count ?? 0,
                    maxCount,
                    _getCategoryColor(index),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAgeGroupsTab() {
    final ageGroups = widget.data!.storiesByAgeGroup ?? [];

    if (ageGroups.isEmpty) {
      return const Center(
        child: Text('لا توجد بيانات فئات عمرية'),
      );
    }

    final totalStories = ageGroups
        .map((e) => e.count ?? 0)
        .fold(0, (a, b) => a + b);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Age Distribution Chart
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Expanded(
                  child: _buildAgeDistributionChart(ageGroups),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: ageGroups.asMap().entries.map((entry) {
                      final index = entry.key;
                      final ageGroup = entry.value;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: _buildLegendItem(
                          ageGroup.ageGroup ?? 'غير محدد',
                          ageGroup.count ?? 0,
                          _getAgeGroupColor(index),
                          totalStories,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Top Age Group
          _buildTopAgeGroup(ageGroups),
        ],
      ),
    );
  }

  Widget _buildActivityChart(int total, int active, int inactive) {
    if (total == 0) {
      return const Center(child: Text('لا توجد بيانات'));
    }

    final activePercent = (active / total);
    final inactivePercent = (inactive / total);

    return Stack(
      children: [
        Center(
          child: SizedBox(
            width: 120,
            height: 120,
            child: CircularProgressIndicator(
              value: 1.0,
              strokeWidth: 12,
              backgroundColor: Colors.red.withOpacity(0.3),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.red),
            ),
          ),
        ),
        Center(
          child: SizedBox(
            width: 120,
            height: 120,
            child: CircularProgressIndicator(
              value: activePercent + inactivePercent,
              strokeWidth: 12,
              backgroundColor: Colors.transparent,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.orange),
            ),
          ),
        ),
        Center(
          child: SizedBox(
            width: 120,
            height: 120,
            child: CircularProgressIndicator(
              value: activePercent,
              strokeWidth: 12,
              backgroundColor: Colors.transparent,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
            ),
          ),
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$total',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'إجمالي',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAgeDistributionChart(List<StoriesByAgeGroup> ageGroups) {
    final total = ageGroups
        .map((e) => e.count ?? 0)
        .fold(0, (a, b) => a + b);

    if (total == 0) {
      return const Center(child: Text('لا توجد بيانات'));
    }

    return Stack(
      children: [
        ...ageGroups.asMap().entries.map((entry) {
          final index = entry.key;
          final ageGroup = entry.value;
          final percent = (ageGroup.count ?? 0) / total;
          final previousPercent = ageGroups
              .take(index)
              .map((e) => e.count ?? 0)
              .fold(0, (a, b) => a + b) / total;

          return Center(
            child: SizedBox(
              width: 100,
              height: 100,
              child: Transform.rotate(
                angle: -1.5708, // -90 degrees to start from top
                child: CircularProgressIndicator(
                  value: previousPercent + percent,
                  strokeWidth: 10,
                  backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _getAgeGroupColor(index),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$total',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'قصة',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLegendItem(
      String label,
      int value,
      Color color,
      int total,
      ) {
    final percentage = total > 0 ? (value / total * 100).toStringAsFixed(1) : '0';

    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 12),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Text(
          '$value ($percentage%)',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(
      String title,
      String value,
      IconData icon,
      Color color,
      ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: color,
                    fontSize: 16,
                  ),
                ),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryProgress(
      String name,
      int count,
      int maxCount,
      Color color,
      ) {
    final progress = maxCount > 0 ? count / maxCount : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              '$count',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: color.withOpacity(0.1),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 6,
          ),
        ),
      ],
    );
  }

  Widget _buildTopAgeGroup(List<StoriesByAgeGroup> ageGroups) {
    if (ageGroups.isEmpty) return const SizedBox.shrink();

    final topAgeGroup = ageGroups.reduce((a, b) =>
    (a.count ?? 0) > (b.count ?? 0) ? a : b);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.blue.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.trending_up, color: Colors.blue, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'الفئة العمرية الأكثر نشاطاً',
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  '${topAgeGroup.ageGroup} - ${topAgeGroup.count} قصة',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(int index) {
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
    return colors[index % colors.length];
  }

  Color _getAgeGroupColor(int index) {
    final colors = [
      Colors.yellow[700]!,
      Colors.green,
      Colors.blue,
      Colors.purple,
    ];
    return colors[index % colors.length];
  }
}