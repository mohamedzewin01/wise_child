import 'package:flutter/material.dart';

class ExpandableSection<T> extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final List<T> items;
  final Widget Function(T) itemBuilder;

  const ExpandableSection({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.items,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      tilePadding: const EdgeInsets.symmetric(horizontal: 20),
      childrenPadding: const EdgeInsets.symmetric(horizontal: 20),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
      subtitle: Text(
        '${items.length} ${_getCountLabel()}',
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey.shade600,
        ),
      ),
      children: items.map(itemBuilder).toList(),
    );
  }

  String _getCountLabel() {
    if (title.contains('الأصدقاء')) {
      return items.length == 1 ? 'صديق' : 'أصدقاء';
    } else {
      return items.length == 1 ? 'شقيق' : 'أشقاء';
    }
  }
}