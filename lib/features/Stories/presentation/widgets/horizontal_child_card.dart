import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wise_child/assets_manager.dart';
import 'package:wise_child/core/api/api_constants.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'package:wise_child/core/resources/style_manager.dart';

class HorizontalChildCard extends StatelessWidget {
  const HorizontalChildCard({
    super.key,
    this.child,
    required this.isSelected,
    required this.onTap,
  });

  final dynamic child;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
            image: child.imageUrl != null
                ? CachedNetworkImageProvider(
                    '${ApiConstants.urlImage}${child.imageUrl}',
                  )
                : AssetImage(Assets.logoRemovebgPng),
            fit: BoxFit.fill,
          ),
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOutCubic,

          width: 60,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            gradient: isSelected
                ? LinearGradient(
                    colors: [
                      ColorManager.primaryColor.withOpacity(0.15),
                      ColorManager.primaryColor.withOpacity(0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : LinearGradient(
                    colors: [
                      ColorManager.primaryColor.withOpacity(0.05),
                      ColorManager.primaryColor.withOpacity(0.01),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected
                  ? ColorManager.primaryColor.withOpacity(0.3)
                  : Colors.transparent,
              width: 2,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: ColorManager.primaryColor.withOpacity(0.2),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              Container(
                decoration: BoxDecoration(
                  color: isSelected
                      ? ColorManager.primaryColor.withOpacity(0.1)
                      : Colors.white,
                ),
                child: Align(
                  child: Text(
                    child.firstName ?? '',

                    style: getSemiBoldStyle(
                      color: isSelected
                          ? ColorManager.white
                          : Colors.grey[700],
                      fontSize: 14,
                    ),

                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
