import 'package:flutter/material.dart';
import 'package:wise_child/features/Home/data/models/response/get_home_request.dart';

class HomeGenderStatistics extends StatelessWidget {
  final StoriesByGender? data;

  const HomeGenderStatistics({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    if (data == null) {
      return const SizedBox.shrink();
    }

    final total = (data!.Boy ?? 0) + (data!.Girl ?? 0) + (data!.Both ?? 0);

    if (total == 0) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'توزيع القصص حسب الجنس',
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Boys
                _buildGenderRow(
                  icon: Icons.boy,
                  title: 'الأولاد',
                  count: data!.Boy ?? 0,
                  total: total,
                  color: Colors.blue,
                  textTheme: textTheme,
                ),
                const SizedBox(height: 16),

                // Girls
                _buildGenderRow(
                  icon: Icons.girl,
                  title: 'البنات',
                  count: data!.Girl ?? 0,
                  total: total,
                  color: Colors.pink,
                  textTheme: textTheme,
                ),
                const SizedBox(height: 16),

                // Both
                _buildGenderRow(
                  icon: Icons.groups,
                  title: 'الاثنان معاً',
                  count: data!.Both ?? 0,
                  total: total,
                  color: Colors.purple,
                  textTheme: textTheme,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderRow({
    required IconData icon,
    required String title,
    required int count,
    required int total,
    required Color color,
    required TextTheme textTheme,
  }) {
    final percentage = total > 0 ? (count / total * 100).toStringAsFixed(1) : '0.0';

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '$count ($percentage%)',
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: total > 0 ? count / total : 0,
                  backgroundColor: color.withOpacity(0.1),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                  minHeight: 6,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}