import 'package:flutter/material.dart';
import 'package:wise_child/core/resources/style_manager.dart';
import 'package:wise_child/features/StoryInfo/data/models/response/story_info_dto.dart';

class StoryInfoProblemSection extends StatelessWidget {
  final ProblemInfo problem;
  final bool isRTL;

  const StoryInfoProblemSection({
    super.key,
    required this.problem,
    required this.isRTL,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 1400),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.orange.shade200, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.shade100,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.psychology,
                          size: 20,
                          color: Colors.orange.shade700,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'تساعد في حل:',
                        style: getBoldStyle(
                          color: Colors.orange.shade800,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    problem.problemTitle ?? 'مشكلة غير محددة',
                    style: getBoldStyle(color: Colors.orange.shade700, fontSize: 18),
                    textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                  ),
                  if (problem.problemDescription != null && problem.problemDescription!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      problem.problemDescription!,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.orange.shade600,
                        height: 1.4,
                      ),
                      textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                    ),
                  ],
                  const SizedBox(height: 12),
                  _buildProblemDetails(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProblemDetails() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.orange.shade100,
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          if (problem.problemCategoryId != null) ...[
            _buildDetailRow(
              icon: Icons.category_outlined,
              label: 'معرف فئة المشكلة',
              value: '${problem.problemCategoryId}',
            ),
            const SizedBox(height: 8),
          ],
          if (problem.createdAt != null) ...[
            _buildDetailRow(
              icon: Icons.access_time,
              label: 'تاريخ الإنشاء',
              value: _formatDate(problem.createdAt!),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
      children: [
        Icon(
          icon,
          size: 14,
          color: Colors.orange.shade600,
        ),
        const SizedBox(width: 6),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 12,
            color: Colors.orange.shade600,
            fontWeight: FontWeight.w600,
          ),
          textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 12,
              color: Colors.orange.shade700,
            ),
            textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
          ),
        ),
      ],
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }
}