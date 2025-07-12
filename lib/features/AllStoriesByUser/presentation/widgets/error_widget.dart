import 'package:flutter/material.dart';

class CustomErrorWidget extends StatelessWidget {
  final Exception error;
  final VoidCallback onRetry;

  const CustomErrorWidget({
    super.key,
    required this.error,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // أيقونة الخطأ
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFFEF4444).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.error_outline_rounded,
              size: 64,
              color: Color(0xFFEF4444),
            ),
          ),

          const SizedBox(height: 24),

          // عنوان الخطأ
          const Text(
            'حدث خطأ غير متوقع',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 12),

          // وصف الخطأ
          Text(
            _getErrorMessage(error),
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 32),

          // زر إعادة المحاولة
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded, color: Colors.white),
              label: const Text(
                'إعادة المحاولة',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF667EEA),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // زر العودة للخلف
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF667EEA)),
              label: const Text(
                'العودة للخلف',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF667EEA),
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF667EEA)),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // معلومات تقنية (اختيارية)
          if (_shouldShowTechnicalDetails()) ...[
            ExpansionTile(
              title: const Text(
                'التفاصيل التقنية',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF6B7280),
                ),
              ),
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    error.toString(),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[700],
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ],
        ],
      ),
    );
  }

  String _getErrorMessage(Exception error) {
    // يمكنك تخصيص رسائل الخطأ حسب نوع الخطأ
    String errorString = error.toString().toLowerCase();

    if (errorString.contains('network') || errorString.contains('connection')) {
      return 'يرجى التحقق من اتصال الإنترنت والمحاولة مرة أخرى';
    } else if (errorString.contains('timeout')) {
      return 'انتهت مهلة الاتصال. يرجى المحاولة مرة أخرى';
    } else if (errorString.contains('server')) {
      return 'خطأ في الخادم. يرجى المحاولة لاحقاً';
    } else if (errorString.contains('unauthorized') || errorString.contains('401')) {
      return 'جلسة العمل منتهية الصلاحية. يرجى تسجيل الدخول مرة أخرى';
    } else if (errorString.contains('forbidden') || errorString.contains('403')) {
      return 'ليس لديك صلاحية للوصول إلى هذا المحتوى';
    } else if (errorString.contains('not found') || errorString.contains('404')) {
      return 'المحتوى المطلوب غير موجود';
    } else {
      return 'حدث خطأ غير متوقع. يرجى المحاولة مرة أخرى أو الاتصال بالدعم الفني';
    }
  }

  bool _shouldShowTechnicalDetails() {
    // يمكنك إضافة منطق لإظهار التفاصيل التقنية فقط في بيئة التطوير
    // أو للمستخدمين المخولين
    return true; // قم بتغيير هذا حسب متطلباتك
  }
}