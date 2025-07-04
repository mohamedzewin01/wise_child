import 'package:flutter/material.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'package:wise_child/core/resources/style_manager.dart';
import 'package:wise_child/features/SelectStoriesScreen/data/models/response/categories_stories_dto/get_categories_stories_dto.dart';

class CategoryCardWidget extends StatelessWidget {
  final Categories category;
  final int index;
  final bool isRTL;
  final VoidCallback? onTap;

  const CategoryCardWidget({
    super.key,
    required this.category,
    required this.index,
    required this.isRTL,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final gradientColors = _getCategoryGradientColors(index);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white,
                  gradientColors[0].withOpacity(0.05),
                  Colors.white,
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: gradientColors[0].withOpacity(0.2),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
                BoxShadow(
                  color: gradientColors[0].withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
              children: [
                // Icon Section
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: gradientColors,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: gradientColors[0].withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    _getCategoryIcon(category.categoryName ?? ''),
                    size: 24,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(width: 16),

                // Content Section
                Expanded(
                  child: Column(
                    crossAxisAlignment: isRTL ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                    children: [
                      Text(
                        category.categoryName ?? 'فئة غير معروفة',
                        style: getBoldStyle(
                          color: ColorManager.primaryColor,
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                      ),

                      if (category.categoryDescription != null) ...[
                        const SizedBox(height: 6),
                        Text(
                          category.categoryDescription!,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                        ),
                      ],

                      const SizedBox(height: 12),

                      // Action hint
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: gradientColors[0].withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                          children: [
                            Icon(
                              Icons.touch_app_outlined,
                              size: 12,
                              color: gradientColors[0],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'اضغط للاستكشاف',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: gradientColors[0],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Arrow Icon
                Icon(
                  isRTL ? Icons.arrow_back_ios_rounded : Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: gradientColors[0].withOpacity(0.7),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String categoryName) {
    final name = categoryName.toLowerCase();

    // مشاكل السلوك والتربية
    if (name.contains('سلوك') || name.contains('تربية') || name.contains('تهذيب') || name.contains('انضباط')) {
      return Icons.psychology_rounded;
    }
    // مشاكل النوم
    else if (name.contains('نوم') || name.contains('أرق') || name.contains('كوابيس') || name.contains('منام')) {
      return Icons.bedtime_rounded;
    }
    // مشاكل الطعام والأكل
    else if (name.contains('طعام') || name.contains('أكل') || name.contains('شهية') || name.contains('وجبات')) {
      return Icons.restaurant_menu_rounded;
    }
    // الخوف والقلق
    else if (name.contains('خوف') || name.contains('قلق') || name.contains('خجل') || name.contains('رهاب')) {
      return Icons.sentiment_very_dissatisfied_rounded;
    }
    // مشاكل اجتماعية وصداقات
    else if (name.contains('صداقة') || name.contains('اجتماعي') || name.contains('تكوين صدقات') || name.contains('وحدة')) {
      return Icons.people_rounded;
    }
    // مشاكل المدرسة والتعليم
    else if (name.contains('مدرسة') || name.contains('دراسة') || name.contains('واجبات') || name.contains('تعليم')) {
      return Icons.school_rounded;
    }
    // مشاكل عاطفية ونفسية
    else if (name.contains('عاطفي') || name.contains('مشاعر') || name.contains('حزن') || name.contains('غضب')) {
      return Icons.emoji_emotions_rounded;
    }
    // مشاكل الثقة بالنفس
    else if (name.contains('ثقة') || name.contains('تقدير الذات') || name.contains('شخصية') || name.contains('جرأة')) {
      return Icons.emoji_events_rounded;
    }
    // مشاكل الأخوة والغيرة
    else if (name.contains('أخوة') || name.contains('غيرة') || name.contains('تنافس') || name.contains('إخوان')) {
      return Icons.family_restroom_rounded;
    }
    // مشاكل العادات السيئة
    else if (name.contains('عادات') || name.contains('مص الأصابع') || name.contains('قضم الأظافر') || name.contains('سلوكيات')) {
      return Icons.block_rounded;
    }
    // مشاكل التواصل والكلام
    else if (name.contains('تواصل') || name.contains('كلام') || name.contains('نطق') || name.contains('لغة')) {
      return Icons.record_voice_over_rounded;
    }
    // مشاكل الحمام والنظافة
    else if (name.contains('حمام') || name.contains('نظافة') || name.contains('تبول') || name.contains('تنظيف')) {
      return Icons.bathroom_rounded;
    }
    // مشاكل الانتباه والتركيز
    else if (name.contains('انتباه') || name.contains('تركيز') || name.contains('نشاط زائد') || name.contains('فرط')) {
      return Icons.visibility_rounded;
    }
    // مشاكل الكذب والصدق
    else if (name.contains('كذب') || name.contains('صدق') || name.contains('أمانة') || name.contains('حقيقة')) {
      return Icons.fact_check_rounded;
    }
    // مشاكل المشاركة
    else if (name.contains('مشاركة') || name.contains('تعاون') || name.contains('أنانية') || name.contains('عطاء')) {
      return Icons.share_rounded;
    }
    // مشاكل الطاعة والاحترام
    else if (name.contains('طاعة') || name.contains('احترام') || name.contains('تمرد') || name.contains('عصيان')) {
      return Icons.handshake_rounded;
    }
    // مشاكل الألعاب الإلكترونية والشاشات
    else if (name.contains('ألعاب') || name.contains('شاشة') || name.contains('تلفزيون') || name.contains('موبايل')) {
      return Icons.games_rounded;
    }
    // مشاكل المال والمصروف
    else if (name.contains('مال') || name.contains('مصروف') || name.contains('ادخار') || name.contains('شراء')) {
      return Icons.savings_rounded;
    }
    // مشاكل الأمان والحماية
    else if (name.contains('أمان') || name.contains('حماية') || name.contains('خطر') || name.contains('سلامة')) {
      return Icons.security_rounded;
    }
    // مشاكل التغيير والتكيف
    else if (name.contains('تغيير') || name.contains('انتقال') || name.contains('تكيف') || name.contains('جديد')) {
      return Icons.change_circle_rounded;
    }
    // مشاكل الصبر والانتظار
    else if (name.contains('صبر') || name.contains('انتظار') || name.contains('هدوء') || name.contains('تحمل')) {
      return Icons.timer_rounded;
    }
    // مشاكل الحيوانات الأليفة
    else if (name.contains('حيوان أليف') || name.contains('قطة') || name.contains('كلب') || name.contains('رعاية')) {
      return Icons.pets_rounded;
    }
    // مشاكل البيئة والطبيعة
    else if (name.contains('بيئة') || name.contains('طبيعة') || name.contains('نظافة البيئة') || name.contains('تلوث')) {
      return Icons.eco_rounded;
    }
    // مشاكل الصحة والنظافة الشخصية
    else if (name.contains('صحة') || name.contains('نظافة شخصية') || name.contains('أسنان') || name.contains('استحمام')) {
      return Icons.health_and_safety_rounded;
    }
    // مشاكل الوقت وإدارته
    else if (name.contains('وقت') || name.contains('جدول') || name.contains('تنظيم') || name.contains('مواعيد')) {
      return Icons.schedule_rounded;
    }
    // مشاكل التنمر
    else if (name.contains('تنمر') || name.contains('اعتداء') || name.contains('إيذاء') || name.contains('ظلم')) {
      return Icons.report_problem_rounded;
    }
    // مشاكل المسؤولية
    else if (name.contains('مسؤولية') || name.contains('واجبات') || name.contains('التزام') || name.contains('أعمال')) {
      return Icons.assignment_turned_in_rounded;
    }
    // مشاكل الحب والحنان
    else if (name.contains('حب') || name.contains('حنان') || name.contains('عاطفة') || name.contains('مودة')) {
      return Icons.favorite_rounded;
    }
    // مشاكل التعبير عن المشاعر
    else if (name.contains('تعبير') || name.contains('مشاعر') || name.contains('إحساس') || name.contains('كتمان')) {
      return Icons.sentiment_satisfied_alt_rounded;
    }
    // مشاكل الإبداع والموهبة
    else if (name.contains('إبداع') || name.contains('موهبة') || name.contains('فن') || name.contains('ابتكار')) {
      return Icons.palette_rounded;
    }
    // القصص التعليمية العامة
    else if (name.contains('تعليم') || name.contains('تعلم') || name.contains('معرفة') || name.contains('ثقافة')) {
      return Icons.menu_book_rounded;
    }
    // مشاكل الدين والأخلاق
    else if (name.contains('دين') || name.contains('أخلاق') || name.contains('قيم') || name.contains('إيمان')) {
      return Icons.auto_stories_rounded;
    }
    // مشاكل أخرى أو عامة
    else {
      return Icons.child_care_rounded;
    }
  }

  List<Color> _getCategoryGradientColors(int index) {
    final colorSets = [
      [ColorManager.primaryColor, Colors.blue.shade600],
      [Colors.purple.shade400, Colors.purple.shade600],
      [Colors.green.shade400, Colors.green.shade600],
      [Colors.orange.shade400, Colors.orange.shade600],
      [Colors.pink.shade400, Colors.pink.shade600],
      [Colors.teal.shade400, Colors.teal.shade600],
      [Colors.indigo.shade400, Colors.indigo.shade600],
      [Colors.red.shade400, Colors.red.shade600],
    ];
    return colorSets[index % colorSets.length];
  }
}