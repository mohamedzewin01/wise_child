import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wise_child/core/api/api_constants.dart';
import 'package:wise_child/features/Reports/data/models/response/reports_dto.dart';

class StoryCardWidget extends StatelessWidget {
  final Stories story;

  const StoryCardWidget({
    super.key,
    required this.story,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showStoryDetailsDialog(context),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade100,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // صورة القصة
            _buildStoryCover(),
            const SizedBox(width: 12),

            // معلومات القصة
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    story.storyTitle ?? 'عنوان القصة',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'تاريخ الإنشاء: ${_formatDate(story.storyCreatedAt)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'آخر مشاهدة: ${_formatDate(story.lastViewed)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),

                  // شريط التقدم للمشاهدات
                  _buildViewsProgressBar(),
                ],
              ),
            ),

            // عدد المشاهدات
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStoryColor(),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${story.totalViews ?? 0}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'مشاهدة',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                // أيقونة تفاصيل أكثر
                Icon(
                  Icons.info_outline,
                  size: 16,
                  color: Colors.grey[400],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoryCover() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: _getStoryColor().withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: _getStoryColor().withOpacity(0.2),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: story.imageCover != null && story.imageCover!.isNotEmpty
            ? Image.network(
          "${ApiConstants.urlImage}${story.imageCover}",
          width: 60,
          height: 60,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _buildDefaultCover();
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
                    : null,
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(_getStoryColor()),
              ),
            );
          },
        )
            : _buildDefaultCover(),
      ),
    );
  }

  Widget _buildDefaultCover() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _getStoryColor().withOpacity(0.3),
            _getStoryColor().withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(
        Icons.menu_book_rounded,
        size: 30,
        color: _getStoryColor(),
      ),
    );
  }

  Widget _buildViewsProgressBar() {
    final views = story.totalViews ?? 0;
    final maxViews = 100; // يمكن تعديل هذا القيمة حسب المطلوب
    final progress = views / maxViews;

    return Row(
      children: [
        Expanded(
          child: LinearProgressIndicator(
            value: progress > 1.0 ? 1.0 : progress,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(_getStoryColor()),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          _getViewsLevel(views),
          style: TextStyle(
            fontSize: 10,
            color: _getStoryColor(),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  void _showStoryDetailsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StoryDetailsDialog(story: story);
      },
    );
  }

  Color _getStoryColor() {
    final views = story.totalViews ?? 0;
    if (views >= 50) return const Color(0xFF4CAF50); // أخضر للمشاهدات العالية
    if (views >= 20) return const Color(0xFFFFC107); // أصفر للمشاهدات المتوسطة
    if (views >= 5) return const Color(0xFFFF9800);  // برتقالي للمشاهدات القليلة
    return const Color(0xFF9E9E9E); // رمادي للمشاهدات القليلة جداً
  }

  String _getViewsLevel(int views) {
    if (views >= 50) return 'ممتاز';
    if (views >= 20) return 'جيد';
    if (views >= 5) return 'متوسط';
    return 'قليل';
  }

  String _formatDate(String? date) {
    if (date == null) return 'غير محدد';
    try {
      final dateTime = DateTime.parse(date);
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inDays > 365) {
        return '${(difference.inDays / 365).floor()} سنة';
      } else if (difference.inDays > 30) {
        return '${(difference.inDays / 30).floor()} شهر';
      } else if (difference.inDays > 0) {
        return '${difference.inDays} يوم';
      } else if (difference.inHours > 0) {
        return '${difference.inHours} ساعة';
      } else {
        return 'الآن';
      }
    } catch (e) {
      return date;
    }
  }
}

// ديالوج تفاصيل القصة
class StoryDetailsDialog extends StatelessWidget {
  final Stories story;

  const StoryDetailsDialog({
    super.key,
    required this.story,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // صورة القصة الكبيرة
            _buildLargeStoryCover(),

            // محتوى التفاصيل
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // عنوان القصة
                  Text(
                    story.storyTitle ?? 'عنوان القصة',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),


                  _buildDetailRow(
                    'تاريخ الإنشاء',
                    _formatFullDate(story.storyCreatedAt),
                    Icons.calendar_today,
                  ),
                  _buildDetailRow(
                    'آخر مشاهدة',
                    _formatFullDate(story.lastViewed),
                    Icons.access_time,
                  ),
                  _buildDetailRow(
                    'عدد المشاهدات',
                    '${story.totalViews ?? 0} مشاهدة',
                    Icons.visibility,
                  ),

                  const SizedBox(height: 16),

                  // مؤشر الأداء
                  _buildPerformanceIndicator(),

                  const SizedBox(height: 20),

                  // أزرار الإجراءات
                  Row(
                    children: [

                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // يمكن إضافة منطق لعرض القصة
                            Navigator.of(context).pop();

                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _getStoryColor(),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text(
                            'إغلاق',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLargeStoryCover() {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        gradient: LinearGradient(
          colors: [
            _getStoryColor().withOpacity(0.8),
            _getStoryColor().withOpacity(0.6),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: story.imageCover != null && story.imageCover!.isNotEmpty
            ? Stack(
          children: [
           CachedNetworkImage(
             imageUrl:
              "${ApiConstants.urlImage}${story.imageCover}",
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
              progressIndicatorBuilder: (context, error, stackTrace) {
                return _buildDefaultLargeCover();
              },
            ),
            /// PLAY STORY
            // طبقة شفافة مع أيقونة التشغيل
            // Container(
            //   width: double.infinity,
            //   height: 200,
            //   decoration: BoxDecoration(
            //     gradient: LinearGradient(
            //       colors: [
            //         Colors.black.withOpacity(0.3),
            //         Colors.transparent,
            //         Colors.black.withOpacity(0.5),
            //       ],
            //       begin: Alignment.topCenter,
            //       end: Alignment.bottomCenter,
            //     ),
            //   ),
            //   child: const Center(
            //     child: Icon(
            //       Icons.play_circle_fill,
            //       size: 60,
            //       color: Colors.white,
            //     ),
            //   ),
            // ),
          ],
        )
            : _buildDefaultLargeCover(),
      ),
    );
  }

  Widget _buildDefaultLargeCover() {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _getStoryColor().withOpacity(0.8),
            _getStoryColor().withOpacity(0.4),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.menu_book_rounded,
              size: 80,
              color: Colors.white.withOpacity(0.9),
            ),
            const SizedBox(height: 8),
            Text(
              'قصة تفاعلية',
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: _getStoryColor(),
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceIndicator() {
    final views = story.totalViews ?? 0;
    final level = _getViewsLevel(views);
    final color = _getStoryColor();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'مستوى الأداء',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  level,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: (views / 100).clamp(0.0, 1.0),
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 8),
          Text(
            _getPerformanceDescription(views),
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Color _getStoryColor() {
    final views = story.totalViews ?? 0;
    if (views >= 50) return const Color(0xFF4CAF50);
    if (views >= 20) return const Color(0xFFFFC107);
    if (views >= 5) return const Color(0xFFFF9800);
    return const Color(0xFF9E9E9E);
  }

  String _getViewsLevel(int views) {
    if (views >= 50) return 'ممتاز';
    if (views >= 20) return 'جيد';
    if (views >= 5) return 'متوسط';
    return 'قليل';
  }

  String _getPerformanceDescription(int views) {
    if (views >= 50) return 'أداء رائع! هذه القصة محبوبة جداً';
    if (views >= 20) return 'أداء جيد، تحتاج المزيد من التشجيع';
    if (views >= 5) return 'بداية جيدة، يمكن تحسين الأداء';
    return 'تحتاج المزيد من الاهتمام والتشجيع';
  }

  String _formatFullDate(String? date) {
    if (date == null) return 'غير محدد';
    try {
      final dateTime = DateTime.parse(date);
      final months = [
        'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
        'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'
      ];
      return '${dateTime.day} ${months[dateTime.month - 1]} ${dateTime.year}';
    } catch (e) {
      return date;
    }
  }

  void _showStoryViewer(BuildContext context) {
    // يمكن إضافة منطق لعرض القصة هنا
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('سيتم فتح عارض القصة قريباً'),
        backgroundColor: Colors.green,
      ),
    );
  }
}