import 'package:flutter/material.dart';
import 'package:wise_child/features/Reports/data/models/response/reports_dto.dart';
import '../reports_constants.dart';

class ReportsUtils {
  // حساب الإحصائيات
  static Map<String, dynamic> calculateChildStatistics(ReportData child) {
    if (child.stories == null || child.stories!.isEmpty) {
      return {
        'totalStories': 0,
        'totalViews': 0,
        'averageViews': 0.0,
        'mostViewedStory': null,
        'recentStory': null,
        'viewsDistribution': <String, int>{},
      };
    }

    final stories = child.stories!;
    final totalStories = stories.length;
    final totalViews = stories.fold<int>(
      0,
      (sum, story) => sum + (story.totalViews ?? 0),
    );
    final averageViews = totalStories > 0 ? totalViews / totalStories : 0.0;

    // القصة الأكثر مشاهدة
    final mostViewedStory = stories.reduce(
      (a, b) => (a.totalViews ?? 0) > (b.totalViews ?? 0) ? a : b,
    );

    // أحدث قصة
    final recentStory = stories.reduce((a, b) {
      final dateA = DateTime.tryParse(a.storyCreatedAt ?? '') ?? DateTime(1970);
      final dateB = DateTime.tryParse(b.storyCreatedAt ?? '') ?? DateTime(1970);
      return dateA.isAfter(dateB) ? a : b;
    });

    // توزيع المشاهدات
    final viewsDistribution = <String, int>{
      'excellent': stories
          .where(
            (s) =>
                (s.totalViews ?? 0) >= ReportsConstants.excellentViewsThreshold,
          )
          .length,
      'good': stories
          .where(
            (s) =>
                (s.totalViews ?? 0) >= ReportsConstants.goodViewsThreshold &&
                (s.totalViews ?? 0) < ReportsConstants.excellentViewsThreshold,
          )
          .length,
      'average': stories
          .where(
            (s) =>
                (s.totalViews ?? 0) >= ReportsConstants.averageViewsThreshold &&
                (s.totalViews ?? 0) < ReportsConstants.goodViewsThreshold,
          )
          .length,
      'low': stories
          .where(
            (s) => (s.totalViews ?? 0) < ReportsConstants.averageViewsThreshold,
          )
          .length,
    };

    return {
      'totalStories': totalStories,
      'totalViews': totalViews,
      'averageViews': averageViews,
      'mostViewedStory': mostViewedStory,
      'recentStory': recentStory,
      'viewsDistribution': viewsDistribution,
    };
  }

  // حساب عمر الطفل
  static int calculateAge(String? dateOfBirth) {
    if (dateOfBirth == null) return 0;

    try {
      final birthDate = DateTime.parse(dateOfBirth);
      final now = DateTime.now();
      int age = now.year - birthDate.year;

      if (now.month < birthDate.month ||
          (now.month == birthDate.month && now.day < birthDate.day)) {
        age--;
      }

      return age;
    } catch (e) {
      return 0;
    }
  }

  // تنسيق التاريخ النسبي
  static String getRelativeTimeString(String? dateString) {
    if (dateString == null) return 'غير محدد';

    try {
      final date = DateTime.parse(dateString);
      return ReportsConstants.formatRelativeTime(date);
    } catch (e) {
      return dateString;
    }
  }

  // تنسيق التاريخ العربي
  static String getArabicDateString(String? dateString) {
    if (dateString == null) return 'غير محدد';

    try {
      final date = DateTime.parse(dateString);
      return ReportsConstants.formatArabicDate(date);
    } catch (e) {
      return dateString;
    }
  }

  // الحصول على لون الإحصائية
  static Color getStatisticColor(String type, dynamic value) {
    switch (type) {
      case 'views':
        if (value is int) {
          return ReportsConstants.getViewsColor(value);
        }
        break;
      case 'stories':
        if (value is int) {
          if (value >= 10) return ReportsConstants.successColor;
          if (value >= 5) return ReportsConstants.warningColor;
          if (value >= 1) return ReportsConstants.infoColor;
          return Colors.grey;
        }
        break;
      case 'average':
        if (value is double) {
          if (value >= 30) return ReportsConstants.successColor;
          if (value >= 15) return ReportsConstants.warningColor;
          if (value >= 5) return ReportsConstants.infoColor;
          return Colors.grey;
        }
        break;
    }
    return ReportsConstants.primaryColor;
  }

  // ترتيب القصص
  static List<Stories> sortStoriesByViews(
    List<Stories> stories, {
    bool descending = true,
  }) {
    final sortedStories = List<Stories>.from(stories);
    sortedStories.sort((a, b) {
      final viewsA = a.totalViews ?? 0;
      final viewsB = b.totalViews ?? 0;
      return descending ? viewsB.compareTo(viewsA) : viewsA.compareTo(viewsB);
    });
    return sortedStories;
  }

  static List<Stories> sortStoriesByDate(
    List<Stories> stories, {
    bool descending = true,
  }) {
    final sortedStories = List<Stories>.from(stories);
    sortedStories.sort((a, b) {
      final dateA = DateTime.tryParse(a.storyCreatedAt ?? '') ?? DateTime(1970);
      final dateB = DateTime.tryParse(b.storyCreatedAt ?? '') ?? DateTime(1970);
      return descending ? dateB.compareTo(dateA) : dateA.compareTo(dateB);
    });
    return sortedStories;
  }

  // فلترة القصص
  static List<Stories> filterStoriesByViews(
    List<Stories> stories,
    int minViews,
  ) {
    return stories
        .where((story) => (story.totalViews ?? 0) >= minViews)
        .toList();
  }

  static List<Stories> filterStoriesByDateRange(
    List<Stories> stories,
    DateTime start,
    DateTime end,
  ) {
    return stories.where((story) {
      final storyDate = DateTime.tryParse(story.storyCreatedAt ?? '');
      if (storyDate == null) return false;
      return storyDate.isAfter(start) && storyDate.isBefore(end);
    }).toList();
  }

  // التحقق من صحة البيانات
  static bool isValidChild(ReportData child) {
    return child.childId != null &&
        (child.firstName != null && child.firstName!.isNotEmpty) &&
        (child.lastName != null && child.lastName!.isNotEmpty);
  }

  static bool isValidStory(Stories story) {
    return story.storyId != null &&
        (story.storyTitle != null && story.storyTitle!.isNotEmpty);
  }

  // تحويل البيانات للرسوم البيانية
  static List<Map<String, dynamic>> getViewsChartData(List<Stories> stories) {
    final sortedStories = sortStoriesByViews(stories);
    return sortedStories
        .take(10)
        .map(
          (story) => {
            'name': story.storyTitle ?? 'قصة',
            'views': story.totalViews ?? 0,
          },
        )
        .toList();
  }

  static Map<String, int> getViewsDistributionData(List<Stories> stories) {
    return {
      'ممتاز (50+)': stories.where((s) => (s.totalViews ?? 0) >= 50).length,
      'جيد (20-49)': stories
          .where((s) => (s.totalViews ?? 0) >= 20 && (s.totalViews ?? 0) < 50)
          .length,
      'متوسط (5-19)': stories
          .where((s) => (s.totalViews ?? 0) >= 5 && (s.totalViews ?? 0) < 20)
          .length,
      'قليل (0-4)': stories.where((s) => (s.totalViews ?? 0) < 5).length,
    };
  }

  // تصدير البيانات
  static Map<String, dynamic> exportChildData(ReportData child) {
    final statistics = calculateChildStatistics(child);
    return {
      'child_info': {
        'id': child.childId,
        'name': '${child.firstName} ${child.lastName}',
        'gender': child.gender,
        'date_of_birth': child.dateOfBirth,
        'age': calculateAge(child.dateOfBirth),
      },
      'statistics': statistics,
      'stories': child.stories
          ?.map(
            (story) => {
              'id': story.storyId,
              'title': story.storyTitle,
              'created_at': story.storyCreatedAt,
              'total_views': story.totalViews,
              'last_viewed': story.lastViewed,
            },
          )
          .toList(),
    };
  }

  // مساعدات للواجهة
  static String getGenderInArabic(String? gender) {
    switch (gender?.toLowerCase()) {
      case 'Male':
        return 'ذكر';
      case 'Female':
        return 'أنثى';
      default:
        return 'غير محدد';
    }
  }

  static IconData getGenderIcon(String? gender) {
    switch (gender?.toLowerCase()) {
      case 'Male':
        return Icons.boy;
      case 'Female':
        return Icons.girl;
      default:
        return Icons.person;
    }
  }

  static String formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}م';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}ك';
    } else {
      return number.toString();
    }
  }

  static String getViewsProgressText(int views) {
    if (views >= ReportsConstants.excellentViewsThreshold) {
      return 'أداء ممتاز! 🌟';
    } else if (views >= ReportsConstants.goodViewsThreshold) {
      return 'أداء جيد! 👍';
    } else if (views >= ReportsConstants.averageViewsThreshold) {
      return 'أداء متوسط';
    } else {
      return 'يحتاج تحسين';
    }
  }

  // مساعدات للرسوم المتحركة
  static Widget buildAnimatedCounter({
    required int value,
    required Duration duration,
    TextStyle? style,
  }) {
    return TweenAnimationBuilder<int>(
      tween: IntTween(begin: 0, end: value),
      duration: duration,
      builder: (context, animatedValue, child) {
        return Text(formatNumber(animatedValue), style: style);
      },
    );
  }

  static Widget buildAnimatedProgress({
    required double value,
    required Duration duration,
    Color? color,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: value),
      duration: duration,
      builder: (context, animatedValue, child) {
        return LinearProgressIndicator(
          value: animatedValue,
          backgroundColor: Colors.grey.shade200,
          valueColor: AlwaysStoppedAnimation<Color>(
            color ?? ReportsConstants.primaryColor,
          ),
        );
      },
    );
  }

  // مساعدات للتنبيهات
  static void showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: ReportsConstants.successColor,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  static void showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: ReportsConstants.errorColor,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  static void showInfoSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: ReportsConstants.infoColor,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}

// كلاس للإعدادات المحلية
// class ReportsPreferences {
//   static const String _sortingKey = 'reports_sorting_preference';
//   static const String _viewModeKey = 'reports_view_mode_preference';
//   static const String _filterKey = 'reports_filter_preference';
//
//   // يمكن استخدام SharedPreferences هنا
//   static String getSortingPreference() {
//     // return SharedPreferences.getInstance().then((prefs) => prefs.getString(_sortingKey) ?? 'views');
//     return 'views'; // القيمة الافتراضية
//   }
//
//   static String getViewModePreference() {
//     return 'grid'; // أو 'list'
//   }
//
//   static Map<String, dynamic> getFilterPreference() {
//     return {
//       'minViews': 0,
//       'dateRange': null,
//       'storyType': 'all',
//     };
//   }
// }
