import 'package:flutter/material.dart';
import 'package:wise_child/features/ChildDetailsPage/presentation/widgets/components/info_row_widget.dart';


class StatisticsCard extends StatelessWidget {
  final dynamic childDetails;

  const StatisticsCard({
    super.key,
    required this.childDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: _buildCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 20),
          _buildStatisticsRow(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.indigo,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.analytics_rounded,
            color: Colors.white,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        const Text(
          'الإحصائيات',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildStatisticsRow() {
    return Row(
      children: [
        Expanded(
          child: StatItemWidget(
            icon: Icons.book_rounded,
            label: 'القصص',
            value: '${childDetails?.stories?.length ?? 0}',
            color: Colors.blue,
          ),
        ),
        Expanded(
          child: StatItemWidget(
            icon: Icons.people_rounded,
            label: 'الأصدقاء',
            value: '${childDetails?.friendsCount ?? 0}',
            color: Colors.green,
          ),
        ),
        Expanded(
          child: StatItemWidget(
            icon: Icons.family_restroom_rounded,
            label: 'الأشقاء',
            value: '${childDetails?.siblingsCount ?? 0}',
            color: Colors.orange,
          ),
        ),
      ],
    );
  }

  BoxDecoration _buildCardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          offset: const Offset(0, 4),
          blurRadius: 15,
        ),
      ],
    );
  }
}