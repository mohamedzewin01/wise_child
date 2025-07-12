import 'package:flutter/material.dart';

class ReportsConstants {
  // الألوان
  static const Color primaryColor = Color(0xFF6B73FF);
  static const Color secondaryColor = Color(0xFF9B59B6);
  static const Color successColor = Color(0xFF4CAF50);
  static const Color warningColor = Color(0xFFFFC107);
  static const Color errorColor = Color(0xFFFF6B6B);
  static const Color infoColor = Color(0xFF00BCD4);
  static const Color lightColor = Color(0xFFF5F5F5);

  // التدرجات
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryColor, secondaryColor],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Colors.white, Color(0xFFFAFAFA)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // النصوص
  static const TextStyle titleTextStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
  );

  static const TextStyle subtitleTextStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Colors.black87,
  );

  static const TextStyle bodyTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: Colors.black87,
  );

  static const TextStyle captionTextStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: Colors.grey,
  );

  static const TextStyle buttonTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  // المسافات
  static const double smallPadding = 8.0;
  static const double mediumPadding = 16.0;
  static const double largePadding = 24.0;
  static const double extraLargePadding = 32.0;

  // الأحجام
  static const double smallIconSize = 16.0;
  static const double mediumIconSize = 24.0;
  static const double largeIconSize = 32.0;
  static const double extraLargeIconSize = 48.0;

  // نصف القطر للحواف
  static const double smallRadius = 8.0;
  static const double mediumRadius = 12.0;
  static const double largeRadius = 16.0;
  static const double extraLargeRadius = 24.0;

  // الظلال
  static const BoxShadow cardShadow = BoxShadow(
    color: Color(0x10000000),
    blurRadius: 4,
    offset: Offset(0, 2),
  );

  static const BoxShadow elevatedShadow = BoxShadow(
    color: Color(0x20000000),
    blurRadius: 8,
    offset: Offset(0, 4),
  );

  // أنماط الزر
  static ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: primaryColor,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(
      horizontal: mediumPadding,
      vertical: mediumPadding,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(mediumRadius),
    ),
    elevation: 2,
  );

  static ButtonStyle secondaryButtonStyle = OutlinedButton.styleFrom(
    foregroundColor: primaryColor,
    side: const BorderSide(color: primaryColor),
    padding: const EdgeInsets.symmetric(
      horizontal: mediumPadding,
      vertical: mediumPadding,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(mediumRadius),
    ),
  );

  // أنماط البطاقات
  static BoxDecoration cardDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(largeRadius),
    boxShadow: const [cardShadow],
  );

  static BoxDecoration elevatedCardDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(largeRadius),
    boxShadow: const [elevatedShadow],
  );

  // أنماط الحاويات
  static BoxDecoration statContainerDecoration(Color color) =>
      BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(mediumRadius),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      );

  // الرموز
  static const IconData childIcon = Icons.child_care_outlined;
  static const IconData storyIcon = Icons.menu_book_rounded;
  static const IconData viewsIcon = Icons.visibility_outlined;
  static const IconData dateIcon = Icons.calendar_today_outlined;
  static const IconData statisticsIcon = Icons.analytics_outlined;
  static const IconData reviewIcon = Icons.rate_review_outlined;
  static const IconData addIcon = Icons.add;
  static const IconData refreshIcon = Icons.refresh;
  static const IconData errorIcon = Icons.error_outline;
  static const IconData loadingIcon = Icons.hourglass_empty;

  // الأبعاد
  static const double appBarHeight = 56.0;
  static const double tabBarHeight = 50.0;
  static const double bottomNavHeight = 60.0;
  static const double fabSize = 56.0;

  // المدة الزمنية للرسوم المتحركة
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);

  // قيم للإحصائيات
  static const int excellentViewsThreshold = 50;
  static const int goodViewsThreshold = 20;
  static const int averageViewsThreshold = 5;

  // رسائل
  static const String loadingMessage = 'جاري تحميل الإحصائيات...';
  static const String noDataMessage = 'لا توجد بيانات';
  static const String errorMessage = 'حدث خطأ أثناء تحميل البيانات';
  static const String retryMessage = 'إعادة المحاولة';
  static const String addChildMessage = 'إضافة طفل';
  static const String addReviewMessage = 'إضافة مراجعة';

  // تنسيقات التاريخ
  static String formatArabicDate(DateTime date) {
    final months = [
      'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
      'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  static String formatRelativeTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} سنة';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} شهر';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} يوم';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ساعة';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} دقيقة';
    } else {
      return 'الآن';
    }
  }

  // ألوان الإحصائيات
  static Color getViewsColor(int views) {
    if (views >= excellentViewsThreshold) return successColor;
    if (views >= goodViewsThreshold) return warningColor;
    if (views >= averageViewsThreshold) return infoColor;
    return Colors.grey;
  }

  static String getViewsLevel(int views) {
    if (views >= excellentViewsThreshold) return 'ممتاز';
    if (views >= goodViewsThreshold) return 'جيد';
    if (views >= averageViewsThreshold) return 'متوسط';
    return 'قليل';
  }

  // تخطيطات مجاوبة
  static bool isTablet(BuildContext context) {
    return MediaQuery
        .of(context)
        .size
        .width > 600;
  }

  static double getScreenWidth(BuildContext context) {
    return MediaQuery
        .of(context)
        .size
        .width;
  }

  static double getScreenHeight(BuildContext context) {
    return MediaQuery
        .of(context)
        .size
        .height;
  }

  // خصائص الجهاز
  static EdgeInsets getScreenPadding(BuildContext context) {
    final isTabletDevice = isTablet(context);
    return EdgeInsets.all(isTabletDevice ? largePadding : mediumPadding);
  }
}