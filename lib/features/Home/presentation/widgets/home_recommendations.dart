import 'package:flutter/material.dart';
import 'package:wise_child/features/Home/data/models/response/get_home_request.dart';

class HomeRecommendations extends StatefulWidget {
  final DataHome? data;

  const HomeRecommendations({
    super.key,
    required this.data,
  });

  @override
  State<HomeRecommendations> createState() => _HomeRecommendationsState();
}

class _HomeRecommendationsState extends State<HomeRecommendations>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    if (widget.data == null) {
      return const SizedBox.shrink();
    }

    final recommendations = _generateRecommendations();
    if (recommendations.isEmpty) {
      return const SizedBox.shrink();
    }

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.lightbulb,
                    color: colorScheme.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'توصيات ذكية',
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.auto_awesome,
                        size: 12,
                        color: Colors.green,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'AI',
                        style: textTheme.bodySmall?.copyWith(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Recommendations List
            ...recommendations.asMap().entries.map((entry) {
              final index = entry.key;
              final recommendation = entry.value;
              return Padding(
                padding: EdgeInsets.only(bottom: index < recommendations.length - 1 ? 12 : 0),
                child: _buildRecommendationCard(
                  recommendation,
                  textTheme,
                  colorScheme,
                  index,
                ),
              );
            }).toList(),

            const SizedBox(height: 16),

            // Action Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _showDetailedRecommendations(context),
                icon: const Icon(Icons.analytics),
                label: const Text('عرض تحليل مفصل'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationCard(
      RecommendationData recommendation,
      TextTheme textTheme,
      ColorScheme colorScheme,
      int index,
      ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: recommendation.priority == RecommendationPriority.high
              ? Colors.red.withOpacity(0.3)
              : recommendation.priority == RecommendationPriority.medium
              ? Colors.orange.withOpacity(0.3)
              : Colors.blue.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: recommendation.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  recommendation.icon,
                  color: recommendation.color,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            recommendation.title,
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        _buildPriorityBadge(recommendation.priority, textTheme),
                      ],
                    ),
                    if (recommendation.impact != null)
                      Text(
                        'التأثير المتوقع: ${recommendation.impact}',
                        style: textTheme.bodySmall?.copyWith(
                          color: Colors.green[600],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            recommendation.description,
            style: textTheme.bodyMedium?.copyWith(
              color: Colors.grey[700],
              height: 1.4,
            ),
          ),
          if (recommendation.actionText != null) ...[
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () => _executeRecommendation(recommendation),
                icon: Icon(Icons.arrow_forward, size: 16),
                label: Text(recommendation.actionText!),
                style: TextButton.styleFrom(
                  foregroundColor: recommendation.color,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPriorityBadge(RecommendationPriority priority, TextTheme textTheme) {
    Color color;
    String text;

    switch (priority) {
      case RecommendationPriority.high:
        color = Colors.red;
        text = 'عالية';
        break;
      case RecommendationPriority.medium:
        color = Colors.orange;
        text = 'متوسطة';
        break;
      case RecommendationPriority.low:
        color = Colors.blue;
        text = 'منخفضة';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Text(
        text,
        style: textTheme.bodySmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  List<RecommendationData> _generateRecommendations() {
    final data = widget.data!;
    final recommendations = <RecommendationData>[];

    // Zero Views Stories Recommendation
    final zeroViews = data.storiesWithZeroViews ?? 0;
    if (zeroViews > 0) {
      recommendations.add(RecommendationData(
        title: 'قصص تحتاج ترويج',
        description: 'لديك $zeroViews قصة لم تحصل على أي مشاهدات. جرب إضافة صور جذابة أو تحسين العناوين.',
        icon: Icons.visibility_off,
        color: Colors.red,
        priority: RecommendationPriority.high,
        impact: '+${(zeroViews * 0.3).round()}% زيادة في المشاهدات',
        actionText: 'عرض القصص',
      ));
    }

    // Activity Rate Recommendation
    final totalStories = data.totalStories ?? 0;
    final activeStories = data.activeStories ?? 0;
    if (totalStories > 0) {
      final activityRate = activeStories / totalStories;
      if (activityRate < 0.7) {
        recommendations.add(RecommendationData(
          title: 'تحسين معدل النشاط',
          description: 'معدل النشاط الحالي ${(activityRate * 100).round()}%. يمكن تحسينه من خلال إضافة محتوى تفاعلي أو تحديث القصص القديمة.',
          icon: Icons.trending_up,
          color: Colors.orange,
          priority: RecommendationPriority.medium,
          impact: '+15% في التفاعل',
          actionText: 'خطة التحسين',
        ));
      }
    }

    // Category Balance Recommendation
    final categories = data.storiesByCategory ?? [];
    if (categories.isNotEmpty) {
      final categoryCounts = categories.map((e) => e.count ?? 0).toList();
      final maxCount = categoryCounts.reduce((a, b) => a > b ? a : b);
      final minCount = categoryCounts.reduce((a, b) => a < b ? a : b);

      if (maxCount > minCount * 3) {
        recommendations.add(RecommendationData(
          title: 'توازن الفئات',
          description: 'هناك تفاوت في توزيع القصص بين الفئات. جرب إضافة المزيد من القصص للفئات الأقل تمثيلاً.',
          icon: Icons.balance,
          color: Colors.blue,
          priority: RecommendationPriority.medium,
          impact: '+10% تنوع المحتوى',
          actionText: 'مراجعة الفئات',
        ));
      }
    }

    // Age Group Recommendation
    final ageGroups = data.storiesByAgeGroup ?? [];
    if (ageGroups.length < 3) {
      recommendations.add(RecommendationData(
        title: 'توسيع الفئات العمرية',
        description: 'لديك قصص لـ ${ageGroups.length} فئة عمرية فقط. إضافة قصص لفئات عمرية أخرى سيوسع جمهورك.',
        icon: Icons.child_friendly,
        color: Colors.purple,
        priority: RecommendationPriority.low,
        impact: '+25% وصول لجمهور أوسع',
        actionText: 'إضافة فئات عمرية',
      ));
    }

    // Gender Balance Recommendation
    final genderData = data.storiesByGender;
    if (genderData != null) {
      final boyStories = genderData.Boy ?? 0;
      final girlStories = genderData.Girl ?? 0;
      final bothStories = genderData.Both ?? 0;
      final genderTotal = boyStories + girlStories + bothStories;

      if (genderTotal > 0 && bothStories / genderTotal < 0.2) {
        recommendations.add(RecommendationData(
          title: 'محتوى شامل للجنسين',
          description: 'أقل من 20% من قصصك مناسبة لجميع الأطفال. إضافة المزيد من القصص الشاملة يزيد من الوصول.',
          icon: Icons.groups,
          color: Colors.teal,
          priority: RecommendationPriority.medium,
          impact: '+20% شمولية المحتوى',
          actionText: 'قصص شاملة',
        ));
      }
    }

    // Top Stories Optimization
    final topStories = data.topViewedStories ?? [];
    if (topStories.length >= 3) {
      final topViews = topStories.take(3).map((e) => e.viewsCount ?? 0).toList();
      final avgTopViews = topViews.reduce((a, b) => a + b) / topViews.length;

      recommendations.add(RecommendationData(
        title: 'استفد من القصص الناجحة',
        description: 'قصصك الأكثر مشاهدة تحصل على ${avgTopViews.round()} مشاهدة في المتوسط. جرب تطبيق نفس عوامل النجاح على قصص أخرى.',
        icon: Icons.star,
        color: Colors.amber,
        priority: RecommendationPriority.low,
        impact: '+30% نجاح القصص الجديدة',
        actionText: 'تحليل النجاح',
      ));
    }

    return recommendations.take(3).toList(); // Show max 3 recommendations
  }

  void _executeRecommendation(RecommendationData recommendation) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم تطبيق التوصية: ${recommendation.title}'),
        action: SnackBarAction(
          label: 'تراجع',
          onPressed: () {},
        ),
      ),
    );
  }

  void _showDetailedRecommendations(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.8,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Header
              Row(
                children: [
                  Icon(Icons.analytics, color: Theme.of(context).primaryColor),
                  const SizedBox(width: 12),
                  Text(
                    'تحليل مفصل وتوصيات',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Content
              Expanded(
                child: ListView(
                  controller: scrollController,
                  children: [
                    _buildDetailedAnalysis(),
                    const SizedBox(height: 20),
                    _buildActionPlan(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailedAnalysis() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.insights, color: Colors.blue),
              const SizedBox(width: 8),
              Text(
                'تحليل الأداء',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'بناءً على تحليل البيانات الحالية، إليك نظرة شاملة على أداء مكتبة القصص:',
            style: TextStyle(color: Colors.grey[700]),
          ),
          const SizedBox(height: 16),
          _buildAnalysisItem(
            'معدل النشاط العام',
            '${_calculateActivityRate()}%',
            _calculateActivityRate() > 70 ? Colors.green : Colors.orange,
          ),
          _buildAnalysisItem(
            'توزيع الفئات',
            '${widget.data?.storiesByCategory?.length ?? 0} فئة',
            Colors.blue,
          ),
          _buildAnalysisItem(
            'التنوع العمري',
            '${widget.data?.storiesByAgeGroup?.length ?? 0} فئة عمرية',
            Colors.purple,
          ),
        ],
      ),
    );
  }

  Widget _buildActionPlan() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.timeline, color: Colors.green),
              const SizedBox(width: 8),
              Text(
                'خطة العمل المقترحة',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green[800],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'خطوات موصى بها لتحسين الأداء:',
            style: TextStyle(color: Colors.grey[700]),
          ),
          const SizedBox(height: 16),
          _buildActionStep(1, 'مراجعة القصص بدون مشاهدات', 'الأسبوع الأول'),
          _buildActionStep(2, 'تحسين العناوين والأوصاف', 'الأسبوع الثاني'),
          _buildActionStep(3, 'إضافة محتوى للفئات الناقصة', 'الأسبوع الثالث'),
          _buildActionStep(4, 'تحليل الأداء وإعادة التقييم', 'الأسبوع الرابع'),
        ],
      ),
    );
  }

  Widget _buildAnalysisItem(String title, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              value,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionStep(int step, String title, String timeline) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$step',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  timeline,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  int _calculateActivityRate() {
    final total = widget.data?.totalStories ?? 0;
    final active = widget.data?.activeStories ?? 0;
    return total > 0 ? (active / total * 100).round() : 0;
  }
}

enum RecommendationPriority { high, medium, low }

class RecommendationData {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final RecommendationPriority priority;
  final String? impact;
  final String? actionText;

  RecommendationData({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.priority,
    this.impact,
    this.actionText,
  });
}