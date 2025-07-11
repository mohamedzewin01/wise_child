import 'package:flutter/material.dart';

class HomeErrorWidget extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;

  const HomeErrorWidget({
    super.key,
    required this.error,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Error Icon
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.error_outline,
              size: 48,
              color: Colors.red[400],
            ),
          ),
          const SizedBox(height: 16),

          // Error Title
          Text(
            'حدث خطأ',
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.red[700],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),

          // Error Message
          Text(
            _getErrorMessage(error),
            style: textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),

          // Retry Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('حاول مرة أخرى'),
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
          const SizedBox(height: 12),

          // Support Button
          TextButton.icon(
            onPressed: () => _showSupportDialog(context),
            icon: const Icon(Icons.help_outline),
            label: const Text('تحتاج مساعدة؟'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  String _getErrorMessage(String error) {
    if (error.toLowerCase().contains('network') ||
        error.toLowerCase().contains('connection') ||
        error.toLowerCase().contains('internet')) {
      return 'تأكد من اتصالك بالإنترنت وحاول مرة أخرى';
    } else if (error.toLowerCase().contains('timeout')) {
      return 'انتهت مهلة الاتصال، يرجى المحاولة مرة أخرى';
    } else if (error.toLowerCase().contains('server')) {
      return 'خطأ في الخادم، يرجى المحاولة لاحقاً';
    } else if (error.toLowerCase().contains('unauthorized') ||
        error.toLowerCase().contains('401')) {
      return 'جلسة العمل منتهية، يرجى تسجيل الدخول مرة أخرى';
    } else {
      return 'حدث خطأ غير متوقع، يرجى المحاولة مرة أخرى';
    }
  }

  void _showSupportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('المساعدة والدعم'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('يمكنك التواصل معنا للحصول على المساعدة:'),
            const SizedBox(height: 12),
            _buildSupportOption(
              icon: Icons.email,
              title: 'البريد الإلكتروني',
              subtitle: 'support@wiseChild.com',
              onTap: () => _launchEmail(),
            ),
            const SizedBox(height: 8),
            _buildSupportOption(
              icon: Icons.phone,
              title: 'الهاتف',
              subtitle: '+966-XX-XXXX-XXX',
              onTap: () => _launchPhone(),
            ),
            const SizedBox(height: 8),
            _buildSupportOption(
              icon: Icons.chat,
              title: 'الدردشة المباشرة',
              subtitle: 'متاح 24/7',
              onTap: () => _launchChat(),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }

  Widget _buildSupportOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Icon(icon, size: 20, color: Colors.grey[600]),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }

  void _launchEmail() {
    // Launch email app
    // You can use url_launcher package: launch('mailto:support@wiseChild.com')
  }

  void _launchPhone() {
    // Launch phone app
    // You can use url_launcher package: launch('tel:+966XXXXXXXX')
  }

  void _launchChat() {
    // Open chat support
    // Navigate to chat support page or open external chat
  }
}