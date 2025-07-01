import 'package:flutter/material.dart';
import 'package:wise_child/features/ChildDetailsPage/presentation/widgets/components/best_playmate_card.dart';
import 'package:wise_child/features/ChildDetailsPage/presentation/widgets/components/social_item_widget.dart';

import '../components/expandable_section.dart';


class SocialConnectionsSection extends StatelessWidget {
  final dynamic childDetails;

  const SocialConnectionsSection({
    super.key,
    required this.childDetails,
  });

  @override
  Widget build(BuildContext context) {
    final hasFriends = childDetails?.friends?.isNotEmpty == true;
    final hasSiblings = childDetails?.siblings?.isNotEmpty == true;
    final hasBestPlaymate = childDetails?.bestPlaymate != null;

    if (!hasFriends && !hasSiblings && !hasBestPlaymate) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: _buildCardDecoration(),
      child: Column(
        children: [
          _buildHeader(),
          if (hasBestPlaymate) BestPlaymateCard(
            bestPlaymate: childDetails!.bestPlaymate!,
          ),
          if (hasFriends) _buildFriendsSection(),
          if (hasSiblings) _buildSiblingsSection(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.pink,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.group_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            'الروابط الاجتماعية',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFriendsSection() {
    return ExpandableSection<dynamic>(
      title: 'الأصدقاء',
      icon: Icons.people_rounded,
      color: Colors.green,
      items: childDetails!.friends!,
      itemBuilder: (friend) => SocialItemWidget(
        name: friend.friendName ?? '',
        subtitle: 'العمر: ${friend.friendAge ?? 'غير محدد'}',
        icon: Icons.person_rounded,
        color: Colors.green,
      ),
    );
  }

  Widget _buildSiblingsSection() {
    return ExpandableSection<dynamic>(
      title: 'الأشقاء',
      icon: Icons.family_restroom_rounded,
      color: Colors.orange,
      items: childDetails!.siblings!,
      itemBuilder: (sibling) => SocialItemWidget(
        name: sibling.siblingName ?? '',
        subtitle: 'العمر: ${sibling.siblingAge ?? 'غير محدد'}',
        icon: Icons.family_restroom_rounded,
        color: Colors.orange,
      ),
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