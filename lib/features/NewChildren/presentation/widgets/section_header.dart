import 'package:flutter/material.dart';
import 'package:wise_child/core/resources/color_manager.dart';

import 'package:wise_child/core/resources/style_manager.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final Color? color;
  final double? vertical;

  const SectionHeader({super.key, required this.title, this.color, this.vertical});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding:  EdgeInsets.symmetric(vertical: vertical??16),
        child: Text(
          title,
          textAlign: TextAlign.start,
          style: getBoldStyle(color:color?? ColorManager.primaryColor, fontSize: 14)
              .copyWith(letterSpacing: 0.5),
        ),
      ),
    );
  }
}