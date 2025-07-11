import 'package:flutter/material.dart';
import 'package:wise_child/features/Home/data/models/response/get_home_request.dart';

class HomeInsightsWidget extends StatefulWidget {
  final DataHome? data;

  const HomeInsightsWidget({
    super.key,
    required this.data,
  });

  @override
  State<HomeInsightsWidget> createState() => _HomeInsightsWidgetState();
}

class _HomeInsightsWidgetState extends State<HomeInsightsWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  int _currentInsightIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _pageController = PageController();
    _startAutoScroll();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _slideAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  void _startAutoScroll() {
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted && _getInsights().isNotEmpty) {
        final nextIndex = (_currentInsightIndex + 1) % _getInsights().length;
        _pageController.animateToPage(
          nextIndex,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        _startAutoScroll();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    if (widget.data == null) {
      return const SizedBox.shrink();
    }

    final insights = _getInsights();
    if (insights.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.insights,
                color: colorScheme.primary,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'رؤى ذكية',
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'مدعوم بالذكاء الاصطناعي',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Insights Carousel
          SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.3),
              end: Offset.zero,
            ).animate(_slideAnimation),
            child: FadeTransition(
              opacity: _slideAnimation,
              child: Container(
                height: 120,
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentInsightIndex = index;
                    });
                  },
                  itemCount: insights.length,
                  itemBuilder: (context, index) {
                    final insight = insights[index];
                    return _buildInsightCard(insight, textTheme, colorScheme);
                  },
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Page Indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              insights.length,
                  (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: _currentInsightIndex == index ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _currentInsightIndex == index
                      ? colorScheme.primary
                      : colorScheme.primary.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightCard(
      InsightData insight,
      TextTheme textTheme,
      ColorScheme colorScheme,
      ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            insight.color.withOpacity(0.8),
            insight.color,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: insight.color.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              insight.icon,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  insight.title,
                  style: textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  insight.description,
                  style: textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withOpacity(0.9),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (insight.trend != null)
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    insight.trend! > 0
                        ? Icons.trending_up
                        : insight.trend! < 0
                        ? Icons.trending_down
                        : Icons.trending_flat,
                    color: Colors.white,
                    size: 20,
                  ),
                  Text(
                    '${insight.trend!.abs()}%',
                    style: textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  List<InsightData> _getInsights() {
    final data = widget.data!;
    final insights = <InsightData>[];

    // Total Stories Insight
    final totalStories = data.totalStories ?? 0;
    if (totalStories > 0) {
      insights.add(InsightData(
        title: 'مكتبة قصص غنية',
        description: 'لديك $totalStories قصة في المكتبة، مما يوفر تنوعاً ممتازاً للأطفال',
        icon: Icons.library_books,
        color: Colors.blue,
      ));
    }

    // Activity Rate Insight
    final activeStories = data.activeStories ?? 0;
    if (totalStories > 0) {
      final activityRate = (activeStories / totalStories * 100).round();
      insights.add(InsightData(
        title: 'معدل النشاط: $activityRate%',
        description: activityRate > 70
            ? 'معدل نشاط ممتاز! معظم القصص تحظى بتفاعل جيد'
            : 'يمكن تحسين معدل النشاط من خلال ترويج القصص أكثر',
        icon: activityRate > 70 ? Icons.trending_up : Icons.trending_flat,
        color: activityRate > 70 ? Colors.green : Colors.orange,
        trend: activityRate > 70 ? 15 : -5,
      ));
    }

    // Zero Views Insight
    final zeroViews = data.storiesWithZeroViews ?? 0;
    if (zeroViews > 0) {
      insights.add(InsightData(
        title: 'قصص تحتاج اهتمام',
        description: '$zeroViews قصة لم تحصل على مشاهدات بعد. جرب ترويجها!',
        icon: Icons.visibility_off,
        color: Colors.red,
        trend: -10,
      ));
    }

    // Gender Distribution Insight
    final genderData = data.storiesByGender;
    if (genderData != null) {
      final boyStories = genderData.Boy ?? 0;
      final girlStories = genderData.Girl ?? 0;
      final bothStories = genderData.Both ?? 0;
      final genderTotal = boyStories + girlStories + bothStories;

      if (genderTotal > 0) {
        final bothPercent = (bothStories / genderTotal * 100).round();
        if (bothPercent > 30) {
          insights.add(InsightData(
            title: 'محتوى شامل',
            description: '$bothPercent% من القصص مناسبة لجميع الأطفال - توزيع ممتاز!',
            icon: Icons.groups,
            color: Colors.purple,
            trend: 8,
          ));
        }
      }
    }

    // Category Diversity Insight
    final categories = data.storiesByCategory ?? [];
    if (categories.length > 5) {
      insights.add(InsightData(
        title: 'تنوع رائع في الفئات',
        description: 'لديك ${categories.length} فئة مختلفة، مما يضمن تنوع المحتوى',
        icon: Icons.category,
        color: Colors.teal,
        trend: 12,
      ));
    }

    // Top Category Insight
    if (categories.isNotEmpty) {
      final topCategory = categories.reduce((a, b) =>
      (a.count ?? 0) > (b.count ?? 0) ? a : b);

      insights.add(InsightData(
        title: 'الفئة الأكثر شعبية',
        description: '${topCategory.categoryName} تتصدر بـ ${topCategory.count} قصة',
        icon: Icons.star,
        color: Colors.amber,
      ));
    }

    // Age Group Balance Insight
    final ageGroups = data.storiesByAgeGroup ?? [];
    if (ageGroups.length >= 3) {
      insights.add(InsightData(
        title: 'توزيع عمري متوازن',
        description: 'لديك قصص لـ ${ageGroups.length} فئة عمرية مختلفة',
        icon: Icons.child_friendly,
        color: Colors.indigo,
        trend: 5,
      ));
    }

    return insights;
  }
}

class InsightData {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final int? trend;

  InsightData({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    this.trend,
  });
}