import 'package:flutter/material.dart';
import 'package:wise_child/core/resources/style_manager.dart';

import '../../data/models/response/story_details_dto.dart';


class ProblemSection extends StatelessWidget {
  final Problem problem;
  final bool isRTL;

  const ProblemSection({super.key,
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
                  if (problem.problemDescription != null) ...[
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
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}