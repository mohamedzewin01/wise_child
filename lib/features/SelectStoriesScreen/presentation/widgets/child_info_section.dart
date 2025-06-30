import 'package:flutter/material.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'package:wise_child/core/resources/style_manager.dart';
import 'package:wise_child/features/Children/data/models/response/get_children_dto.dart';

class ChildInfoSection extends StatelessWidget {
  final Children child;
  final Animation<double> fadeAnimation;
  final Animation<Offset> slideAnimation;
  final bool isRTL;

  const ChildInfoSection({
    super.key,
    required this.child,
    required this.fadeAnimation,
    required this.slideAnimation,
    required this.isRTL,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: FadeTransition(
        opacity: fadeAnimation,
        child: SlideTransition(
          position: slideAnimation,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  ColorManager.primaryColor,
                  ColorManager.primaryColor,
                  Colors.purple.shade300,
                ],
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: ColorManager.primaryColor.withOpacity(0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                  spreadRadius: 0,
                ),
                BoxShadow(
                  color: Colors.white.withOpacity(0.8),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                  spreadRadius: -5,
                ),
              ],
            ),
            child: Row(
              textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
              children: [
                // Avatar Section
                _buildAvatarSection(),

                const SizedBox(width: 16),

                // Child Info
                Expanded(
                  child: _buildChildInfo(),
                ),

                // Stories Icon
                _buildStoriesIcon(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarSection() {
    return Hero(
      tag: 'child_avatar_select_stories_${child.idChildren}',
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.2),
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: CircleAvatar(
          radius: 28,
          backgroundColor: Colors.white,
          child: Text(
            _getInitials('${child.firstName} ${child.lastName}'),
            style: getBoldStyle(
              color: ColorManager.primaryColor,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChildInfo() {
    return Column(
      crossAxisAlignment: isRTL ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          '${child.firstName} ${child.lastName}',
          style: getBoldStyle(
            color: Colors.white,
            fontSize: 18,
          ),
          textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
        ),
        const SizedBox(height: 6),

        Wrap(
          spacing: 8,
          runSpacing: 4,
          textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
          children: [
            _buildInfoChip(
              icon: Icons.cake_outlined,
              label: _calculateAge(child.dateOfBirth),
            ),
            _buildInfoChip(
              icon: child.gender?.toLowerCase() == 'male'
                  ? Icons.male : Icons.female,
              label: child.gender ?? 'غير محدد',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStoriesIcon() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Icon(
        Icons.auto_stories,
        color: Colors.white,
        size: 24,
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
        children: [
          Icon(icon, size: 12, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  String _getInitials(String fullName) {
    if (fullName.isEmpty) return 'ط';

    List<String> nameParts = fullName.trim().split(' ');
    if (nameParts.length == 1) {
      return nameParts[0].isNotEmpty ? nameParts[0][0].toUpperCase() : 'ط';
    } else {
      String firstInitial = nameParts[0].isNotEmpty ? nameParts[0][0] : '';
      String lastInitial = nameParts[nameParts.length - 1].isNotEmpty
          ? nameParts[nameParts.length - 1][0] : '';
      return (firstInitial + lastInitial).toUpperCase();
    }
  }

  String _calculateAge(String? dateOfBirth) {
    if (dateOfBirth == null || dateOfBirth.isEmpty) return 'غير محدد';

    try {
      DateTime birthDate = DateTime.parse(dateOfBirth);
      DateTime now = DateTime.now();
      int age = now.year - birthDate.year;

      if (now.month < birthDate.month ||
          (now.month == birthDate.month && now.day < birthDate.day)) {
        age--;
      }

      return '$age سنة';
    } catch (e) {
      return 'غير محدد';
    }
  }
}