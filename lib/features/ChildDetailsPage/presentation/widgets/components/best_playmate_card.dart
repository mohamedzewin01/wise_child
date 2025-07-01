
import 'package:flutter/material.dart';

class BestPlaymateCard extends StatelessWidget {
  final dynamic bestPlaymate;

  const BestPlaymateCard({
    super.key,
    required this.bestPlaymate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: _buildCardDecoration(),
      child: Row(
        children: [
          _buildIcon(),
          const SizedBox(width: 16),
          Expanded(child: _buildContent()),
        ],
      ),
    );
  }

  Widget _buildIcon() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.pink,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(
        Icons.star_rounded,
        color: Colors.white,
        size: 24,
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'أفضل رفيق لعب',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.pink,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          bestPlaymate.playmateName ?? 'غير محدد',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'العمر: ${bestPlaymate.playmateAge ?? 'غير محدد'}',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  BoxDecoration _buildCardDecoration() {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Colors.pink.withOpacity(0.1),
          Colors.purple.withOpacity(0.1),
        ],
      ),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Colors.pink.withOpacity(0.3)),
    );
  }
}

