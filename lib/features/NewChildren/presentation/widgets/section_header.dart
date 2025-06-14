import 'package:flutter/material.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'package:wise_child/core/resources/style_manager.dart';

class SectionHeader extends StatelessWidget {
  final String title;

  const SectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Text(
          title,
          textAlign: TextAlign.start,
          style: getBoldStyle(color: Colors.black, fontSize: 14)
              .copyWith(letterSpacing: 0.5),
        ),
      ),
    );
  }
}