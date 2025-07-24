import 'package:flutter/material.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'package:wise_child/core/resources/style_manager.dart';
import 'package:wise_child/core/widgets/avatar_image.dart';
import 'package:wise_child/core/functions/calculate_age.dart';
import 'package:wise_child/features/Children/data/models/response/get_children_dto.dart';
import 'package:wise_child/localization/locale_cubit.dart';

class StoriesHeader extends StatelessWidget {
  final Children child;
  final bool isRTL;

  const StoriesHeader({
    super.key,
    required this.child,
    required this.isRTL,
  });

  @override
  Widget build(BuildContext context) {
    final languageCode = LocaleCubit.get(context).state.languageCode;
    final ageString = calculateAgeInYearsAndMonths(
      child.dateOfBirth ?? '',
      languageCode,
    );

    return SliverAppBar(
      expandedHeight: 280,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor: ColorManager.primaryColor,
      leading: IconButton(
        icon: Icon(
          isRTL ?   Icons.arrow_back_ios:Icons.arrow_forward_ios,
          color: Colors.white,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                ColorManager.primaryColor,
                ColorManager.primaryColor.withOpacity(0.8),
              ],
            ),
          ),
          child: Stack(
            children: [
              // Background Pattern
              _buildBackgroundPattern(),

              // Content
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 22),
                    _buildAvatarSection(),

                    const SizedBox(height: 16),

                    // Child Info
                    _buildChildInfo(ageString, languageCode),

                    const SizedBox(height: 8),

                    // Stories Title
                    _buildStoriesTitle(languageCode),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackgroundPattern() {
    return Positioned.fill(
      child: CustomPaint(
        painter: _HeaderPatternPainter(),
      ),
    );
  }

  Widget _buildAvatarSection() {
    return Hero(
      tag: 'child_avatar_${child.idChildren}',
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: Colors.white.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: AvatarWidget(
          firstName: child.firstName ?? '',
          lastName: child.lastName ?? '',
          backgroundColor: Colors.white,
          textColor: ColorManager.primaryColor,
          imageUrl: child.imageUrl,
          radius: 50,
          showBorder: true,
          borderColor: Colors.white,
          borderWidth: 4,
        ),
      ),
    );
  }

  Widget _buildChildInfo(String ageString, String languageCode) {
    return Column(
      children: [
        // Name
        Text(
          '${child.firstName} ${child.lastName}',
          style: getBoldStyle(
            color: Colors.white,
            fontSize: 24,
          ),
          textAlign: TextAlign.center,
          textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
        ),

        const SizedBox(height: 8),

        // Age Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
            children: [
              Icon(
                Icons.cake_outlined,
                color: Colors.white,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                ageString,
                style: getSemiBoldStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStoriesTitle(String languageCode) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
        children: [
          Icon(
            Icons.auto_stories_rounded,
            color: Colors.white,
            size: 20,
          ),
          const SizedBox(width: 10),
          Text(
            languageCode == 'ar' ? 'قصص ${child.firstName}' : '${child.firstName}\'s Stories',
            style: getSemiBoldStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..style = PaintingStyle.fill;

    const double spacing = 30;

    for (double x = 0; x < size.width + spacing; x += spacing) {
      for (double y = 0; y < size.height + spacing; y += spacing) {
        canvas.drawCircle(
          Offset(x, y),
          2,
          paint,
        );
      }
    }

    // Add some larger circles for decoration
    final largePaint = Paint()
      ..color = Colors.white.withOpacity(0.03)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.width * 0.8, size.height * 0.2),
      40,
      largePaint,
    );

    canvas.drawCircle(
      Offset(size.width * 0.1, size.height * 0.7),
      25,
      largePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}