import 'package:flutter/material.dart';
import 'package:wise_child/features/Reports/data/models/response/reports_dto.dart';
import 'package:wise_child/features/Reports/presentation/widgets/reports_constants.dart';
import 'package:wise_child/features/Reports/presentation/widgets/utils/utils.dart';

class DetailedAnalyticsPage extends StatefulWidget {
  final ReportData childData;

  const DetailedAnalyticsPage({
    super.key,
    required this.childData,
  });

  @override
  State<DetailedAnalyticsPage> createState() => _DetailedAnalyticsPageState();
}

class _DetailedAnalyticsPageState extends State<DetailedAnalyticsPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late Map<String, dynamic> statistics;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    statistics = ReportsUtils.calculateChildStatistics(widget.childData);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'إحصائيات ${widget.childData.firstName}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: ReportsConstants.primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
            onPressed: _shareAnalytics,
          ),
          IconButton(
            icon: const Icon(Icons.download, color: Colors.white),
            onPressed: _exportAnalytics,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'نظرة عامة', icon: Icon(Icons.dashboard_outlined)),
            Tab(text: 'القصص', icon: Icon(Icons.book_outlined)),
            Tab(text: 'التقدم', icon: Icon(Icons.trending_up_outlined)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(),
          _buildStoriesTab(),
          _buildProgressTab(),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // بطاقة ملخص الطفل
          _buildChildSummaryCard(),
          const SizedBox(height: 20),

          // الإحصائيات الرئيسية
          _buildMainStatistics(),
          const SizedBox(height: 20),

          // توزيع المشاهدات
          _buildViewsDistribution(),
          const SizedBox(height: 20),

          // أفضل القصص
          _buildTopStoriesCard(),
        ],
      ),
    );
  }

  Widget _buildStoriesTab() {
    final stories = widget.childData.stories ?? [];
    final sortedStories = ReportsUtils.sortStoriesByViews(stories);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // فلاتر وخيارات الترتيب
          _buildStoriesFilters(),
          const SizedBox(height: 20),

          // قائمة القصص التفصيلية
          if (sortedStories.isNotEmpty)
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: sortedStories.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                return _buildDetailedStoryCard(sortedStories[index], index + 1);
              },
            )
          else
            const Center(
              child: Padding(
                padding: EdgeInsets.all(40),
                child: Text(
                  'لا توجد قصص لعرضها',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProgressTab() {
    final stories = widget.childData.stories ?? [];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // مخطط التقدم الزمني
          _buildProgressChart(),
          const SizedBox(height: 20),

          // إحصائيات شهرية
          _buildMonthlyStats(),
          const SizedBox(height: 20),

          // تحليل النشاط
          _buildActivityAnalysis(),
          const SizedBox(height: 20),

          // توصيات
          _buildRecommendations(),
        ],
      ),
    );
  }

  Widget _buildChildSummaryCard() {
    final age = ReportsUtils.calculateAge(widget.childData.dateOfBirth);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: ReportsConstants.primaryGradient,
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.white,
              child: Icon(
                ReportsUtils.getGenderIcon(widget.childData.gender),
                size: 40,
                color: ReportsConstants.primaryColor,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${widget.childData.firstName} ${widget.childData.lastName}',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'العمر: $age سنة • ${ReportsUtils.getGenderInArabic(widget.childData.gender)}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'عضو منذ: ${ReportsUtils.getArabicDateString(widget.childData.dateOfBirth)}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white60,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainStatistics() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'الإحصائيات الرئيسية',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 1.5,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildStatCard(
                  'إجمالي القصص',
                  statistics['totalStories'].toString(),
                  Icons.book_outlined,
                  ReportsConstants.primaryColor,
                ),
                _buildStatCard(
                  'إجمالي المشاهدات',
                  ReportsUtils.formatNumber(statistics['totalViews']),
                  Icons.visibility_outlined,
                  ReportsConstants.infoColor,
                ),
                _buildStatCard(
                  'متوسط المشاهدات',
                  statistics['averageViews'].toStringAsFixed(1),
                  Icons.analytics_outlined,
                  ReportsConstants.successColor,
                ),
                _buildStatCard(
                  'القصة الأكثر مشاهدة',
                  '${statistics['mostViewedStory']?.totalViews ?? 0}',
                  Icons.star_outlined,
                  ReportsConstants.warningColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 32, color: color),
          const SizedBox(height: 8),
          ReportsUtils.buildAnimatedCounter(
            value: int.tryParse(value.replaceAll(RegExp(r'[^\d]'), '')) ?? 0,
            duration: const Duration(milliseconds: 1000),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildViewsDistribution() {
    final distribution = statistics['viewsDistribution'] as Map<String, int>;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'توزيع أداء القصص',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildDistributionItem('ممتاز (50+ مشاهدة)', distribution['excellent']!, ReportsConstants.successColor),
            _buildDistributionItem('جيد (20-49 مشاهدة)', distribution['good']!, ReportsConstants.warningColor),
            _buildDistributionItem('متوسط (5-19 مشاهدة)', distribution['average']!, ReportsConstants.infoColor),
            _buildDistributionItem('قليل (أقل من 5)', distribution['low']!, Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildDistributionItem(String label, int count, Color color) {
    final total = statistics['totalStories'] as int;
    final percentage = total > 0 ? (count / total) : 0.0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 14),
            ),
          ),
          Text(
            '$count (${(percentage * 100).toStringAsFixed(1)}%)',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopStoriesCard() {
    final stories = widget.childData.stories ?? [];
    final topStories = ReportsUtils.sortStoriesByViews(stories).take(3).toList();

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'أفضل 3 قصص',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            if (topStories.isNotEmpty)
              ...topStories.asMap().entries.map((entry) {
                final index = entry.key;
                final story = entry.value;
                return _buildTopStoryItem(story, index + 1);
              }).toList()
            else
              const Center(
                child: Text(
                  'لا توجد قصص',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopStoryItem(Stories story, int rank) {
    final rankColors = [
      Colors.amber,
      Colors.grey[400]!,
      Colors.brown[300]!,
    ];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: rankColors[rank - 1].withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: rankColors[rank - 1],
            child: Text(
              rank.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  story.storyTitle ?? 'قصة',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'آخر مشاهدة: ${ReportsUtils.getRelativeTimeString(story.lastViewed)}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${story.totalViews} مشاهدة',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: rankColors[rank - 1],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoriesFilters() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  const Icon(Icons.sort, size: 20, color: Colors.grey),
                  const SizedBox(width: 8),
                  const Text('ترتيب حسب:'),
                  const SizedBox(width: 8),
                  DropdownButton<String>(
                    value: 'views',
                    underline: Container(),
                    items: const [
                      DropdownMenuItem(value: 'views', child: Text('المشاهدات')),
                      DropdownMenuItem(value: 'date', child: Text('التاريخ')),
                      DropdownMenuItem(value: 'title', child: Text('العنوان')),
                    ],
                    onChanged: (value) {
                      // يمكن إضافة منطق الترتيب هنا
                    },
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: _showFilterDialog,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailedStoryCard(Stories story, int index) {
    final viewsColor = ReportsUtils.getStatisticColor('views', story.totalViews ?? 0);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: viewsColor.withOpacity(0.2),
                  child: Text(
                    index.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: viewsColor,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        story.storyTitle ?? 'قصة',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'تاريخ الإنشاء: ${ReportsUtils.getArabicDateString(story.storyCreatedAt)}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: viewsColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    '${story.totalViews} مشاهدة',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // شريط التقدم
            Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: (story.totalViews ?? 0) / 100, // يمكن تعديل القيمة القصوى
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(viewsColor),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  ReportsUtils.getViewsProgressText(story.totalViews ?? 0),
                  style: TextStyle(
                    fontSize: 12,
                    color: viewsColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'آخر مشاهدة: ${ReportsUtils.getRelativeTimeString(story.lastViewed)}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  ReportsConstants.getViewsLevel(story.totalViews ?? 0),
                  style: TextStyle(
                    fontSize: 12,
                    color: viewsColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressChart() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'تطور النشاط',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              height: 200,
              child: const Center(
                child: Text(
                  'مخطط التقدم الزمني\n(يمكن إضافة مكتبة الرسوم البيانية)',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthlyStats() {
    final stories = widget.childData.stories ?? [];
    final monthlyData = _calculateMonthlyStats(stories);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'الإحصائيات الشهرية',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...monthlyData.entries.map((entry) {
              return _buildMonthlyItem(entry.key, entry.value);
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthlyItem(String month, Map<String, int> data) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              month,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          Text(
            '${data['stories']} قصة',
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          const SizedBox(width: 16),
          Text(
            '${data['views']} مشاهدة',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityAnalysis() {
    final stories = widget.childData.stories ?? [];
    final analysis = _analyzeActivity(stories);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'تحليل النشاط',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildAnalysisItem(
              'الفترة الأكثر نشاطاً',
              analysis['mostActiveDay'] ?? 'غير محدد',
              Icons.schedule,
              ReportsConstants.successColor,
            ),
            _buildAnalysisItem(
              'متوسط المشاهدات اليومية',
              '${analysis['avgDailyViews']}',
              Icons.trending_up,
              ReportsConstants.infoColor,
            ),
            _buildAnalysisItem(
              'إجمالي الأيام النشطة',
              '${analysis['activeDays']}',
              Icons.calendar_today,
              ReportsConstants.warningColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalysisItem(String title, String value, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 14),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendations() {
    final recommendations = _generateRecommendations();

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'التوصيات',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...recommendations.map((recommendation) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: ReportsConstants.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: ReportsConstants.primaryColor.withOpacity(0.2),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.lightbulb_outline,
                      color: ReportsConstants.primaryColor,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        recommendation,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Map<String, Map<String, int>> _calculateMonthlyStats(List<Stories> stories) {
    final monthlyData = <String, Map<String, int>>{};

    for (final story in stories) {
      try {
        final date = DateTime.parse(story.storyCreatedAt ?? '');
        final monthKey = '${date.year}-${date.month.toString().padLeft(2, '0')}';

        if (!monthlyData.containsKey(monthKey)) {
          monthlyData[monthKey] = {'stories': 0, 'views': 0};
        }

        monthlyData[monthKey]!['stories'] = monthlyData[monthKey]!['stories']! + 1;
        monthlyData[monthKey]!['views'] = monthlyData[monthKey]!['views']! + (story.totalViews ?? 0);
      } catch (e) {
        // تجاهل الأخطاء في تحليل التاريخ
      }
    }

    return monthlyData;
  }

  Map<String, dynamic> _analyzeActivity(List<Stories> stories) {
    if (stories.isEmpty) {
      return {
        'mostActiveDay': 'لا توجد بيانات',
        'avgDailyViews': 0,
        'activeDays': 0,
      };
    }

    // حساب متوسط المشاهدات اليومية
    final totalViews = stories.fold<int>(0, (sum, story) => sum + (story.totalViews ?? 0));
    final avgDailyViews = totalViews / stories.length;

    // حساب الأيام النشطة (الأيام التي تم فيها إنشاء قصص)
    final activeDays = stories
        .map((story) => story.storyCreatedAt)
        .where((date) => date != null)
        .map((date) => DateTime.parse(date!).day)
        .toSet()
        .length;

    return {
      'mostActiveDay': 'الأحد', // يمكن حساب هذا بناءً على البيانات الفعلية
      'avgDailyViews': avgDailyViews.toStringAsFixed(1),
      'activeDays': activeDays,
    };
  }

  List<String> _generateRecommendations() {
    final stories = widget.childData.stories ?? [];
    final totalViews = statistics['totalViews'] as int;
    final totalStories = statistics['totalStories'] as int;
    final recommendations = <String>[];

    if (totalStories == 0) {
      recommendations.add('ابدأ بإضافة المزيد من القصص لطفلك');
    } else if (totalViews < totalStories * 10) {
      recommendations.add('حاول تشجيع طفلك على مشاهدة القصص بشكل منتظم');
    }

    if (totalStories < 5) {
      recommendations.add('أضف المزيد من القصص المتنوعة لإثراء تجربة طفلك');
    }

    final lowViewsStories = stories.where((s) => (s.totalViews ?? 0) < 5).length;
    if (lowViewsStories > totalStories * 0.5) {
      recommendations.add('راجع محتوى القصص واختر ما يناسب اهتمامات طفلك');
    }

    if (totalViews > 100) {
      recommendations.add('أداء ممتاز! استمر في تشجيع طفلك على القراءة');
    }

    return recommendations.isNotEmpty
        ? recommendations
        : ['استمر في تتبع تقدم طفلك وتشجيعه على القراءة'];
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('خيارات الفلترة'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CheckboxListTile(
              title: const Text('القصص عالية المشاهدات'),
              value: false,
              onChanged: (value) {},
            ),
            CheckboxListTile(
              title: const Text('القصص الحديثة'),
              value: false,
              onChanged: (value) {},
            ),
            CheckboxListTile(
              title: const Text('القصص المفضلة'),
              value: false,
              onChanged: (value) {},
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('تطبيق'),
          ),
        ],
      ),
    );
  }

  void _shareAnalytics() {
    // يمكن إضافة منطق مشاركة الإحصائيات
    ReportsUtils.showInfoSnackBar(context, 'سيتم إضافة ميزة المشاركة قريباً');
  }

  void _exportAnalytics() {
    // يمكن إضافة منطق تصدير الإحصائيات
    final exportData = ReportsUtils.exportChildData(widget.childData);
    ReportsUtils.showSuccessSnackBar(context, 'تم تحضير البيانات للتصدير');
  }
}