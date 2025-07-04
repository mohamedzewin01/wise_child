import 'package:flutter/material.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'package:wise_child/core/resources/style_manager.dart';

class StoryErrorWidget extends StatelessWidget {
  final VoidCallback onRetry;

  const StoryErrorWidget({
    super.key,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.red.withOpacity(0.1),
              Colors.white,
              Colors.red.withOpacity(0.05),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                // App Bar
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: ColorManager.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),

                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Error Icon
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.red.withOpacity(0.3),
                              width: 2,
                            ),
                          ),
                          child: Icon(
                            Icons.error_outline,
                            size: 50,
                            color: Colors.red.shade400,
                          ),
                        ),

                        const SizedBox(height: 24),

                        Text(
                          'حدث خطأ في تحميل التفاصيل',
                          style: getBoldStyle(
                            color: Colors.grey.shade700,
                            fontSize: 20,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          'تأكد من اتصالك بالإنترنت وحاول مرة أخرى',
                          style: getRegularStyle(
                            color: Colors.grey.shade500,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 32),

                        // Retry Button
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(horizontal: 40),
                          child: ElevatedButton.icon(
                            onPressed: onRetry,
                            icon: const Icon(Icons.refresh),
                            label: const Text('إعادة المحاولة'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorManager.primaryColor,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              elevation: 4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}