import 'package:flutter/material.dart';

class ReportsErrorWidget extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;

  const ReportsErrorWidget({
    Key? key,
    required this.error,
    required this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // أيقونة الخطأ
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red.shade400,
              ),
            ),
            const SizedBox(height: 24),

            // عنوان الخطأ
            Text(
              'حدث خطأ!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.red.shade600,
              ),
            ),
            const SizedBox(height: 12),

            // وصف الخطأ
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Text(
                _getErrorMessage(error),
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.red.shade700,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),

            // أزرار الإجراءات
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // زر المحاولة مرة أخرى
                ElevatedButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh, color: Colors.white),
                  label: const Text(
                    'إعادة المحاولة',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6B73FF),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // زر العودة
                OutlinedButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.grey.shade600,
                  ),
                  label: Text(
                    'العودة',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.grey.shade300),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // معلومات إضافية
            Text(
              'إذا استمر هذا الخطأ، يرجى الاتصال بالدعم الفني',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  String _getErrorMessage(String error) {
    // تحويل رسائل الخطأ التقنية إلى رسائل مفهومة للمستخدم
    if (error.contains('network') || error.contains('internet')) {
      return 'يرجى التحقق من الاتصال بالإنترنت والمحاولة مرة أخرى';
    } else if (error.contains('timeout')) {
      return 'انتهت مهلة الاتصال، يرجى المحاولة مرة أخرى';
    } else if (error.contains('server')) {
      return 'خطأ في الخادم، يرجى المحاولة لاحقاً';
    } else if (error.contains('unauthorized') || error.contains('401')) {
      return 'انتهت صلاحية الجلسة، يرجى تسجيل الدخول مرة أخرى';
    } else if (error.contains('forbidden') || error.contains('403')) {
      return 'ليس لديك صلاحية للوصول إلى هذه البيانات';
    } else if (error.contains('not found') || error.contains('404')) {
      return 'لم يتم العثور على البيانات المطلوبة';
    } else {
      return 'حدث خطأ غير متوقع، يرجى المحاولة مرة أخرى';
    }
  }
}

// ويدجت خطأ مبسط
class SimpleErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const SimpleErrorWidget({
    Key? key,
    required this.message,
    this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 48,
            color: Colors.red.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 16,
              color: Colors.red.shade600,
            ),
            textAlign: TextAlign.center,
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ],
      ),
    );
  }
}

// ويدجت خطأ للعناصر الصغيرة
class InlineErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const InlineErrorWidget({
    Key? key,
    required this.message,
    this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Row(
        children: [
          Icon(
            Icons.warning_amber_rounded,
            size: 20,
            color: Colors.red.shade600,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontSize: 14,
                color: Colors.red.shade700,
              ),
            ),
          ),
          if (onRetry != null) ...[
            const SizedBox(width: 8),
            TextButton(
              onPressed: onRetry,
              child: Text(
                'إعادة',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.red.shade600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ويدجت خطأ مع تفاصيل أكثر
class DetailedErrorWidget extends StatefulWidget {
  final String error;
  final VoidCallback onRetry;

  const DetailedErrorWidget({
    Key? key,
    required this.error,
    required this.onRetry,
  }) : super(key: key);

  @override
  State<DetailedErrorWidget> createState() => _DetailedErrorWidgetState();
}

class _DetailedErrorWidgetState extends State<DetailedErrorWidget> {
  bool _showDetails = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red.shade400,
            ),
            const SizedBox(height: 24),

            const Text(
              'حدث خطأ!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            ElevatedButton.icon(
              onPressed: widget.onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('إعادة المحاولة'),
            ),
            const SizedBox(height: 16),

            TextButton(
              onPressed: () {
                setState(() {
                  _showDetails = !_showDetails;
                });
              },
              child: Text(
                _showDetails ? 'إخفاء التفاصيل' : 'عرض التفاصيل',
              ),
            ),

            if (_showDetails) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  widget.error,
                  style: const TextStyle(
                    fontSize: 12,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}